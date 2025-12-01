import SwiftUI

// MARK: - Vicarious Me Theme Colors

extension Color {
    /// Vicarious Me theme namespace
    static let vm = VMColors()
}

struct VMColors {
    // MARK: - Primary Actions

    /// Primary capture action color - energetic amber/orange
    let capture = Color(red: 0.95, green: 0.6, blue: 0.2)

    /// Synthesis/reflection color - calming purple
    let synthesis = Color(red: 0.6, green: 0.4, blue: 0.9)

    /// Success/completion color
    let success = Color(red: 0.3, green: 0.75, blue: 0.5)

    // MARK: - Surfaces

    /// Card/surface background
    let surface = Color(red: 0.12, green: 0.12, blue: 0.14)

    /// Elevated surface (modals, sheets)
    let surfaceElevated = Color(red: 0.16, green: 0.16, blue: 0.18)

    /// Background color
    let background = Color(red: 0.08, green: 0.08, blue: 0.1)

    // MARK: - Text

    /// Primary text color
    let textPrimary = Color.white

    /// Secondary/muted text
    let textSecondary = Color(white: 0.6)

    /// Tertiary/hint text
    let textTertiary = Color(white: 0.4)

    // MARK: - Focus Type Colors

    func focusColor(for type: FocusType?) -> Color {
        guard let type = type else { return textSecondary }

        switch type {
        case .work: return Color(red: 0.4, green: 0.6, blue: 0.9)
        case .personal: return Color(red: 0.9, green: 0.5, blue: 0.6)
        case .health: return Color(red: 0.5, green: 0.85, blue: 0.6)
        case .relationships: return Color(red: 0.9, green: 0.6, blue: 0.8)
        case .creativity: return Color(red: 0.95, green: 0.7, blue: 0.3)
        case .learning: return Color(red: 0.5, green: 0.7, blue: 0.9)
        case .general: return Color(white: 0.6)
        }
    }

    // MARK: - Tier Colors

    func tierColor(for tier: ReflectionTier) -> Color {
        switch tier {
        case .daily: return capture
        case .weekly: return Color(red: 0.5, green: 0.7, blue: 0.9)
        case .monthly: return synthesis
        case .yearly: return Color(red: 0.9, green: 0.5, blue: 0.6)
        }
    }
}

// MARK: - Light Mode Support

extension VMColors {
    /// Returns appropriate colors based on color scheme
    /// For now, we're dark-mode first, but this enables future light mode support
    func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark: return background
        case .light: return Color(white: 0.96)
        @unknown default: return background
        }
    }

    func adaptiveSurface(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark: return surface
        case .light: return Color.white
        @unknown default: return surface
        }
    }
}
