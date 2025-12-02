import SwiftUI

// MARK: - Design System Colors
extension Color {
    static let vm = VMColors()
}

struct VMColors {
    // Mode Colors
    let capture = Color(red: 0.2, green: 0.6, blue: 0.9)      // Blue - Capture mode
    let reflect = Color(red: 0.6, green: 0.4, blue: 0.8)      // Purple - Reflect mode
    let synthesis = Color(red: 0.9, green: 0.6, blue: 0.2)    // Orange - Synthesis mode

    // Entry Type Colors
    let story = Color(red: 0.3, green: 0.7, blue: 0.5)        // Green - Stories
    let idea = Color(red: 0.95, green: 0.75, blue: 0.2)       // Yellow/Gold - Ideas
    let question = Color(red: 0.8, green: 0.4, blue: 0.6)     // Pink - Questions

    // UI Colors
    let background = Color(red: 0.98, green: 0.98, blue: 1.0)
    let surface = Color.white
    let surfaceSecondary = Color(red: 0.95, green: 0.95, blue: 0.97)

    // Text Colors
    let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.15)
    let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.55)

    // Tier Colors
    let tierCore = Color(red: 0.8, green: 0.5, blue: 0.2)     // Bronze/Core
    let tierActive = Color(red: 0.6, green: 0.6, blue: 0.7)   // Silver/Active
    let tierArchive = Color(red: 0.5, green: 0.5, blue: 0.55) // Gray/Archive
}
