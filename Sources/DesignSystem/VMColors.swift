import SwiftUI

/// Vicarious Me color system
/// Colors are semantic—named for their purpose, not their hue.
extension Color {
    /// Vicarious Me design system colors
    static let vm = VMColors()
}

struct VMColors {
    // MARK: - Mode Colors
    /// Capture mode—observation, recording, seeing clearly
    let capture = Color(red: 0.20, green: 0.55, blue: 0.65)        // Teal/cyan - clear, observational

    /// Synthesis mode—meaning-making, interpretation, understanding
    let synthesis = Color(red: 0.65, green: 0.45, blue: 0.70)      // Purple - thoughtful, reflective

    /// Either mode—neutral, works for both
    let either = Color(red: 0.50, green: 0.55, blue: 0.60)         // Slate - balanced

    // MARK: - Tier Colors
    let daily = Color(red: 0.40, green: 0.60, blue: 0.50)          // Sage - grounded, present
    let weekly = Color(red: 0.50, green: 0.55, blue: 0.65)         // Steel blue - first synthesis
    let monthly = Color(red: 0.55, green: 0.50, blue: 0.65)        // Muted purple - deeper
    let quarterly = Color(red: 0.60, green: 0.45, blue: 0.55)      // Mauve - strategic
    let yearly = Color(red: 0.45, green: 0.40, blue: 0.55)         // Deep purple - narrative

    // MARK: - Semantic Colors
    let primary = Color(red: 0.25, green: 0.30, blue: 0.35)        // Near-black for text
    let secondary = Color(red: 0.45, green: 0.50, blue: 0.55)      // Muted for secondary text
    let tertiary = Color(red: 0.65, green: 0.68, blue: 0.72)       // Light for hints

    let background = Color(red: 0.98, green: 0.97, blue: 0.96)     // Warm white
    let surface = Color(red: 1.0, green: 0.99, blue: 0.98)         // Card background
    let surfaceElevated = Color.white                               // Elevated surfaces

    let accent = Color(red: 0.85, green: 0.55, blue: 0.35)         // Warm amber - attention
    let success = Color(red: 0.35, green: 0.60, blue: 0.45)        // Green - completion
    let warning = Color(red: 0.80, green: 0.60, blue: 0.30)        // Gold - caution
    let error = Color(red: 0.75, green: 0.35, blue: 0.35)          // Muted red - errors

    // MARK: - Quality Colors
    let qualityNeedsWork = Color(red: 0.70, green: 0.50, blue: 0.40)
    let qualityDeveloping = Color(red: 0.65, green: 0.60, blue: 0.45)
    let qualitySolid = Color(red: 0.45, green: 0.60, blue: 0.50)
    let qualityExcellent = Color(red: 0.35, green: 0.55, blue: 0.55)

    // MARK: - Helper Methods

    func color(for mode: ReflectionMode) -> Color {
        switch mode {
        case .capture: return capture
        case .synthesis: return synthesis
        }
    }

    func color(for tier: ReflectionTier) -> Color {
        switch tier {
        case .daily: return daily
        case .weekly: return weekly
        case .monthly: return monthly
        case .quarterly: return quarterly
        case .yearly: return yearly
        }
    }

    func color(for quality: CaptureQuality) -> Color {
        switch quality {
        case .needsWork: return qualityNeedsWork
        case .developing: return qualityDeveloping
        case .solid: return qualitySolid
        case .excellent: return qualityExcellent
        }
    }
}
