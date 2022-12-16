import Foundation

class JetpackBrandingMenuCardPresenter {

    struct Config {
        let description: String
        let learnMoreButtonURL: String?
    }

    // MARK: Private Variables

    private let remoteConfigStore: RemoteConfigStore
    private let persistenceStore: UserPersistentRepository
    private let currentDateProvider: CurrentDateProvider
    private let phase: JetpackFeaturesRemovalCoordinator.GeneralPhase

    // MARK: Initializers

    init(remoteConfigStore: RemoteConfigStore = RemoteConfigStore(),
         featureFlagStore: RemoteFeatureFlagStore = RemoteFeatureFlagStore(),
         persistenceStore: UserPersistentRepository = UserDefaults.standard,
         currentDateProvider: CurrentDateProvider = DefaultCurrentDateProvider()) {
        self.remoteConfigStore = remoteConfigStore
        self.persistenceStore = persistenceStore
        self.currentDateProvider = currentDateProvider
        self.phase = JetpackFeaturesRemovalCoordinator.generalPhase(featureFlagStore: featureFlagStore)
    }

    // MARK: Public Functions

    func cardConfig() -> Config? {
        switch phase {
        case .three:
            let description = Strings.phaseThreeDescription
            let url = RemoteConfig(store: remoteConfigStore).phaseThreeBlogPostUrl.value
            return .init(description: description, learnMoreButtonURL: url)
        default:
            return nil
        }
    }

    func shouldShowCard() -> Bool {
        let showCardOnDate = showCardOnDate ?? .distantPast // If not set, then return distant past so that the condition below always succeeds
        guard shouldHideCard == false, // Card not hidden
              showCardOnDate < currentDateProvider.date(), // Interval has passed if temporarily hidden
              let _ = cardConfig() else { // Card is enabled in the current phase
            return false
        }
        return true
    }

    func remindLaterTapped() {
        let now = currentDateProvider.date()
        let duration = Constants.remindLaterDurationInDays * Constants.secondsInDay
        let newDate = now.addingTimeInterval(TimeInterval(duration))
        showCardOnDate = newDate
        trackRemindMeLaterTapped()
    }

    func hideThisTapped() {
        shouldHideCard = true
        trackHideThisTapped()
    }
}

// MARK: Analytics

extension JetpackBrandingMenuCardPresenter {

    func trackCardShown() {
        WPAnalytics.track(.jetpackBrandingMenuCardDisplayed, properties: analyticsProperties)
    }

    func trackLinkTapped() {
        WPAnalytics.track(.jetpackBrandingMenuCardLinkTapped, properties: analyticsProperties)
    }

    func trackCardTapped() {
        WPAnalytics.track(.jetpackBrandingMenuCardTapped, properties: analyticsProperties)
    }

    func trackContexualMenuAccessed() {
        WPAnalytics.track(.jetpackBrandingMenuCardContextualMenuAccessed, properties: analyticsProperties)
    }

    func trackHideThisTapped() {
        WPAnalytics.track(.jetpackBrandingMenuCardHidden, properties: analyticsProperties)
    }

    func trackRemindMeLaterTapped() {
        WPAnalytics.track(.jetpackBrandingMenuCardRemindLater, properties: analyticsProperties)
    }

    private var analyticsProperties: [String: String] {
        [Constants.phaseAnalyticsKey: phase.rawValue]
    }
}

private extension JetpackBrandingMenuCardPresenter {
    var shouldHideCard: Bool {
        get {
            persistenceStore.bool(forKey: Constants.shouldHideCardKey)
        }

        set {
            persistenceStore.set(newValue, forKey: Constants.shouldHideCardKey)
        }
    }

    var showCardOnDate: Date? {
        get {
            persistenceStore.object(forKey: Constants.showCardOnDateKey) as? Date
        }

        set {
            persistenceStore.set(newValue, forKey: Constants.showCardOnDateKey)
        }
    }
}

private extension JetpackBrandingMenuCardPresenter {
    enum Constants {
        static let secondsInDay = 86_400
        static let remindLaterDurationInDays = 7
        static let shouldHideCardKey = "JetpackBrandingShouldHideCardKey"
        static let showCardOnDateKey = "JetpackBrandingShowCardOnDateKey"
        static let phaseAnalyticsKey = "phase"
    }

    enum Strings {
        static let phaseThreeDescription = NSLocalizedString("jetpack.menuCard.description",
                                                           value: "Stats, Reader, Notifications and other features will soon move to the Jetpack mobile app.",
                                                           comment: "Description inside a menu card communicating that features are moving to the Jetpack app.")
    }
}
