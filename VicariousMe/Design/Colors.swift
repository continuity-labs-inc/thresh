import SwiftUI

// MARK: - Design System Colors
extension Color {
    static let vm = VMColors()
}

struct VMColors {
    // Mode Colors
    let capture = Color(red: 0.13, green: 0.47, blue: 0.87)    // Strong blue
    let reflect = Color(red: 0.49, green: 0.28, blue: 0.73)    // Rich purple
    let synthesis = Color(red: 0.90, green: 0.49, blue: 0.13)  // Vibrant orange

    // Entry Type Colors
    let story = Color(red: 0.18, green: 0.55, blue: 0.42)      // Forest green
    let idea = Color(red: 0.80, green: 0.55, blue: 0.08)       // Golden amber
    let question = Color(red: 0.76, green: 0.27, blue: 0.46)   // Deep pink

    // UI Colors
    let background = Color(red: 0.95, green: 0.95, blue: 0.97) // Light cool gray
    let surface = Color.white
    let surfaceSecondary = Color(red: 0.92, green: 0.92, blue: 0.94)
    let cardBackground = Color.white

    // Text Colors - ACTUALLY DARK
    let textPrimary = Color.black
    let textSecondary = Color(red: 0.35, green: 0.35, blue: 0.40)
    let textTertiary = Color(red: 0.55, green: 0.55, blue: 0.60)

    // Tier Colors
    let tierCore = Color(red: 0.72, green: 0.45, blue: 0.20)
    let tierActive = Color(red: 0.45, green: 0.45, blue: 0.50)
    let tierArchive = Color(red: 0.55, green: 0.55, blue: 0.58)
}
