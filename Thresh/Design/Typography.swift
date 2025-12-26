import SwiftUI

// MARK: - Adaptive Typography for iPad

/// Provides device-appropriate typography and spacing
/// iPad fonts are 40-50% larger for better readability on large screens
struct ThreshTypography {
    let isIPad: Bool

    init(sizeClass: UserInterfaceSizeClass?) {
        self.isIPad = sizeClass == .regular
    }

    // MARK: - Font Sizes (iPad = 40-50% larger)

    var largeTitle: Font {
        isIPad ? .system(size: 52, weight: .bold) : .largeTitle
    }

    var title: Font {
        isIPad ? .system(size: 44, weight: .bold) : .title
    }

    var title2: Font {
        isIPad ? .system(size: 34, weight: .bold) : .title2
    }

    var title3: Font {
        isIPad ? .system(size: 30, weight: .semibold) : .title3
    }

    var headline: Font {
        isIPad ? .system(size: 26, weight: .semibold) : .headline
    }

    var body: Font {
        isIPad ? .system(size: 24) : .body
    }

    var callout: Font {
        isIPad ? .system(size: 22) : .callout
    }

    var subheadline: Font {
        isIPad ? .system(size: 21) : .subheadline
    }

    var footnote: Font {
        isIPad ? .system(size: 18) : .footnote
    }

    var caption: Font {
        isIPad ? .system(size: 17) : .caption
    }

    var caption2: Font {
        isIPad ? .system(size: 15) : .caption2
    }

    // MARK: - Spacing (iPad = reduced horizontal, same vertical)

    /// Standard horizontal padding - reduced on iPad
    var horizontalPadding: CGFloat {
        isIPad ? 16 : 20
    }

    /// Card/container horizontal padding
    var cardHorizontalPadding: CGFloat {
        isIPad ? 12 : 16
    }

    /// Screen edge padding
    var screenEdgePadding: CGFloat {
        isIPad ? 20 : 16
    }

    /// Content max width for iPad detail views
    var maxContentWidth: CGFloat {
        isIPad ? 800 : .infinity
    }

    /// List row vertical padding
    var rowVerticalPadding: CGFloat {
        isIPad ? 12 : 4
    }

    /// Icon size multiplier for iPad
    var iconScale: CGFloat {
        isIPad ? 1.4 : 1.0
    }

    /// Sidebar icon size
    var sidebarIconSize: CGFloat {
        isIPad ? 28 : 20
    }
}

// MARK: - Environment Key

private struct TypographyKey: EnvironmentKey {
    static let defaultValue = ThreshTypography(sizeClass: nil)
}

extension EnvironmentValues {
    var typography: ThreshTypography {
        get { self[TypographyKey.self] }
        set { self[TypographyKey.self] = newValue }
    }
}

// MARK: - View Extension for Easy Access

extension View {
    /// Apply typography environment based on size class
    func adaptiveTypography(sizeClass: UserInterfaceSizeClass?) -> some View {
        self.environment(\.typography, ThreshTypography(sizeClass: sizeClass))
    }
}
