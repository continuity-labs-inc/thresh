import SwiftUI

/// Vicarious Me color palette
/// Access via Color.vm.propertyName
extension Color {
    /// Vicarious Me theme colors namespace
    static let vm = VMColors()
}

/// Container for Vicarious Me theme colors
struct VMColors {
    // MARK: - Mode Colors

    /// Capture mode color - grounded, observational
    let capture = Color(hex: "4A90A4")

    /// Synthesis mode color - interpretive, meaning-making
    let synthesis = Color(hex: "9B6B9E")

    // MARK: - Semantic Colors

    /// Primary accent color
    let accent = Color(hex: "5C8A97")

    /// Success/completion color
    let success = Color(hex: "6B9E6B")

    /// Warning/attention color
    let warning = Color(hex: "D4A574")

    /// Error/danger color
    let error = Color(hex: "C75D5D")

    // MARK: - Surface Colors

    /// Background surface color
    let surface = Color(hex: "F5F5F0")

    /// Card/elevated surface color
    let surfaceElevated = Color(hex: "FFFFFF")

    /// Secondary surface color
    let surfaceSecondary = Color(hex: "EAEAE5")

    // MARK: - Text Colors

    /// Primary text color
    let textPrimary = Color(hex: "2C3E50")

    /// Secondary text color
    let textSecondary = Color(hex: "7F8C8D")

    /// Muted text color
    let textMuted = Color(hex: "95A5A6")

    // MARK: - Focus Type Colors

    /// Body focus color
    let focusBody = Color(hex: "E74C3C")

    /// Emotion focus color
    let focusEmotion = Color(hex: "E67E22")

    /// Thought focus color
    let focusThought = Color(hex: "3498DB")

    /// Relationship focus color
    let focusRelationship = Color(hex: "9B59B6")

    /// Environment focus color
    let focusEnvironment = Color(hex: "27AE60")

    /// Spirit focus color
    let focusSpirit = Color(hex: "F39C12")

    // MARK: - Tier Colors

    /// Daily tier color
    let tierDaily = Color(hex: "3498DB")

    /// Weekly tier color
    let tierWeekly = Color(hex: "9B59B6")

    /// Monthly tier color
    let tierMonthly = Color(hex: "E67E22")

    /// Seasonal tier color
    let tierSeasonal = Color(hex: "27AE60")

    /// Annual tier color
    let tierAnnual = Color(hex: "E74C3C")

    // MARK: - Helper Methods

    /// Get color for a focus type
    func color(for focusType: FocusType) -> Color {
        switch focusType {
        case .body: return focusBody
        case .emotion: return focusEmotion
        case .thought: return focusThought
        case .relationship: return focusRelationship
        case .environment: return focusEnvironment
        case .spirit: return focusSpirit
        }
    }

    /// Get color for a reflection tier
    func color(for tier: ReflectionTier) -> Color {
        switch tier {
        case .daily: return tierDaily
        case .weekly: return tierWeekly
        case .monthly: return tierMonthly
        case .seasonal: return tierSeasonal
        case .annual: return tierAnnual
        }
    }

    /// Get color for a reflection mode
    func color(for mode: ReflectionMode) -> Color {
        switch mode {
        case .capture: return capture
        case .synthesis: return synthesis
        }
    }
}

// MARK: - Color Hex Extension

extension Color {
    /// Initialize a Color from a hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
