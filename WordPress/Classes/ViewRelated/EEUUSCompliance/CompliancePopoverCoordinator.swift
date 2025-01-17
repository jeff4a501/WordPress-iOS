import UIKit

protocol CompliancePopoverCoordinatorProtocol {
    func presentIfNeeded()
    func navigateToSettings()
    func dismiss()
}

final class CompliancePopoverCoordinator: CompliancePopoverCoordinatorProtocol {
    private let viewController: UIViewController
    private let complianceService = ComplianceLocationService()
    private let defaults: UserDefaults

    init(viewController: UIViewController, defaults: UserDefaults = UserDefaults.standard) {
        self.viewController = viewController
        self.defaults = defaults
    }

    func presentIfNeeded() {
        guard FeatureFlag.compliancePopover.enabled, !defaults.didShowCompliancePopup else {
            return
        }
        complianceService.getIPCountryCode { [weak self] result in
            if case .success(let countryCode) = result {
                guard let self, self.shouldShowPrivacyBanner(countryCode: countryCode) else {
                    return
                }
                DispatchQueue.main.async {
                    self.presentPopover()
                }
            }
        }
    }

    func navigateToSettings() {
        viewController.dismiss(animated: true) {
            RootViewCoordinator.sharedPresenter.navigateToPrivacySettings()
        }
    }

    func dismiss() {
        viewController.dismiss(animated: true)
    }

    private func shouldShowPrivacyBanner(countryCode: String) -> Bool {
        let isCountryInEU = Self.gdprCountryCodes.contains(countryCode)
        return isCountryInEU && !defaults.didShowCompliancePopup
    }

    private func presentPopover() {
        let complianceViewModel = CompliancePopoverViewModel(
            defaults: defaults,
            contextManager: ContextManager.shared
        )
        complianceViewModel.coordinator = self
        let complianceViewController = CompliancePopoverViewController(viewModel: complianceViewModel)
        let bottomSheetViewController = BottomSheetViewController(childViewController: complianceViewController, customHeaderSpacing: 0)

        bottomSheetViewController.show(from: self.viewController)
    }
}

private extension CompliancePopoverCoordinator {
    static let gdprCountryCodes: Set<String> = [
        "AT", "AUT", // Austria
        "BE", "BEL", // Belgium
        "BG", "BGR", // Bulgaria
        "HR", "HRV", // Croatia
        "CY", "CYP", // Cyprus
        "CZ", "CZE", // Czech Republic
        "DK", "DNK", // Denmark
        "EE", "EST", // Estonia
        "FI", "FIN", // Finland
        "FR", "FRA", // France
        "DE", "DEU", // Germany
        "GR", "GRC", // Greece
        "HU", "HUN", // Hungary
        "IE", "IRL", // Ireland
        "IT", "ITA", // Italy
        "LV", "LVA", // Latvia
        "LT", "LTU", // Lithuania
        "LU", "LUX", // Luxembourg
        "MT", "MLT", // Malta
        "NL", "NLD", // Netherlands
        "NO", "NOR", // Norway
        "PL", "POL", // Poland
        "PT", "PRT", // Portugal
        "RO", "ROU", // Romania
        "SK", "SVK", // Slovakia
        "SI", "SVN", // Slovenia
        "ES", "ESP", // Spain
        "SE", "SWE", // Sweden
        "CH", "CHE", // Switzerland
        "IS",
        "LI",
        "GB",
        // *Although the UK has departed from the EU as of January 2021,
        // the GDPR was enacted before its withdrawal and is therefore considered a valid UK law.*
    ]
}

extension UserDefaults {
    static let didShowCompliancePopupKey = "didShowCompliancePopup"

    var didShowCompliancePopup: Bool {
        get {
            bool(forKey: Self.didShowCompliancePopupKey)
        } set {
            set(newValue, forKey: Self.didShowCompliancePopupKey)
        }
    }
}
