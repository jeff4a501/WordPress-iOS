import SwiftUI

enum AppColor {

    enum Accent: String, CaseIterable {
        case pink
        case red
        case orange
        case yellow
        case celadon
        case wooCommercePurple
        case jetpackGreen
        case wordPressBlue
    }

    // MARK: API

    static private(set) var accent: Accent = savedAccent ?? defaultAccent {
        didSet {
            if accent != oldValue {
                savedAccent = accent

                NotificationCenter.default
                    .post(name: .appColorDidUpdateAccent, object: accent)
            }
        }
    }

    static var accentColor: Color {
        accent.color
    }

    static func accentColor(_ shade: MurielColorShade) -> Color {
        .muriel(accent.murielName, shade: shade)
    }

    static func updateAccent(with newAccent: Accent) {
        accent = newAccent
    }

    // MARK: Helpers

    private static var defaultAccent: Accent {
        switch appConfig {
        case .wordpress:
            return .wordPressBlue
        case .jetpack:
            return .jetpackGreen
        case .unknown:
            return .red
        }
    }

    private static var savedAccent: Accent? {
        get {
            guard let rawValue = defaults.string(forKey: savedAccentKey) else {
                return nil
            }
            return Accent(rawValue: rawValue)
        }
        set {
            if let newValue {
                defaults.set(newValue.rawValue, forKey: savedAccentKey)
            }
        }
    }

    private static var defaults: UserDefaults {
        .init(suiteName: WPAppGroupName) ?? .standard
    }

    private static var savedAccentKey: String {
        "\(appConfig.rawValue).AppColor.Accent"
    }

    private static var appConfig: AppConfig {
        if AppConfiguration.isWordPress {
            return .wordpress
        } else if AppConfiguration.isJetpack {
            return .jetpack
        } else {
            assertionFailure("unsupported configuration")
            return .unknown
        }
    }

    private enum AppConfig: String {
        case wordpress = "Wordpress"
        case jetpack = "Jetpack"
        case unknown = "Unknown"
    }

}

extension AppColor.Accent: Identifiable, CustomStringConvertible {
    var id: String {
        rawValue
    }

    var description: String {
        switch self {
        case .pink:
            return AppLocalizedString("color.pink", comment: "Title for the `Pink` app accent color")
        case .red:
            return AppLocalizedString("color.red", comment: "Title for the `Red` app accent color")
        case .orange:
            return AppLocalizedString("color.orange", comment: "Title for the `Orange` app accent color")
        case .yellow:
            return AppLocalizedString("color.yellow", comment: "Title for the `Yellow` app accent color")
        case .celadon:
            return AppLocalizedString("color.celadon", comment: "Title for the `Celadon` app accent color")
        case .wooCommercePurple:
            return AppLocalizedString("color.wooCommercePurple", comment: "Title for the `WooCommerce Purple` app accent color")
        case .jetpackGreen:
            return AppLocalizedString("color.jetpackGreen", comment: "Title for the `Jetpack Green` app accent color")
        case .wordPressBlue:
            return AppLocalizedString("color.wordPressBlue", comment: "Title for the `WordPress Blue` app accent color")
        }
    }

    var color: Color {
        switch self {
        case .pink:
            return .dynamic(
                light: .muriel(murielName, shade: .shade60),
                dark: .muriel(murielName, shade: .shade60)
            )
        case .red:
            return .dynamic(
                light: .muriel(murielName, shade: .shade60),
                dark: .muriel(murielName, shade: .shade60)
            )
        case .orange:
            return .dynamic(
                light: .muriel(murielName),
                dark: .muriel(murielName)
            )
        case .yellow:
            return .dynamic(
                light: .muriel(murielName),
                dark: .muriel(murielName)
            )
        case .celadon:
            return .dynamic(
                light: .muriel(murielName, shade: .shade60),
                dark: .muriel(murielName, shade: .shade60)
            )
        case .wooCommercePurple:
            return .dynamic(
                light: .muriel(murielName, shade: .shade60),
                dark: .muriel(murielName, shade: .shade60)
            )
        case .jetpackGreen:
            return .dynamic(
                light: .muriel(murielName),
                dark: .muriel(murielName)
            )
        case .wordPressBlue:
            return .dynamic(
                light: .muriel(murielName),
                dark: .muriel(murielName)
            )
        }
    }

    fileprivate var murielName: MurielColorName {
        switch self {
        case .pink:
            return .pink
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .celadon:
            return .celadon
        case .wooCommercePurple:
            return .wooCommercePurple
        case .jetpackGreen:
            return .jetpackGreen
        case .wordPressBlue:
            return .wordPressBlue
        }
    }

    static var allCasesSorted: [Self] {
        var all = allCases
        let firstAccent = AppColor.defaultAccent
        all.removeAll(where: { $0 == firstAccent })
        all.insert(firstAccent, at: 0)
        return all
    }
}

extension Foundation.Notification.Name {
    static let appColorDidUpdateAccent = Self("appColorDidUpdateAccent")
}

@objc extension NSNotification {
    static var appColorDidUpdateAccent: NSString {
        Foundation.Notification.Name.appColorDidUpdateAccent.rawValue as NSString
    }
}

private extension Color {
    static func muriel(
        _ name: MurielColorName,
        shade: MurielColorShade = .shade50
    ) -> Self {
        .init(
            UIColor.muriel(color: .init(name: name, shade: shade))
        )
    }

    static func dynamic(light: Color, dark: Color) -> Color {
        Color(UIColor(
            dynamicProvider: {
                $0.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
            })
        )
    }
}
