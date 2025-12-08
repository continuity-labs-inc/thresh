import SwiftUI

// MARK: - Design System Colors
extension Color {
    static let thresh = ThreshColors()
}

struct ThreshColors {
    // Mode Colors
    let capture = Color(red: 0.13, green: 0.47, blue: 0.87)    // Strong blue
    let reflect = Color(red: 0.49, green: 0.28, blue: 0.73)    // Rich purple
    let synthesis = Color(red: 0.90, green: 0.49, blue: 0.13)  // Vibrant orange

    // Entry Type Colors
    let story = Color(red: 0.18, green: 0.55, blue: 0.42)      // Forest green
    let idea = Color(red: 0.80, green: 0.55, blue: 0.08)       // Golden amber
    let question = Color(red: 0.76, green: 0.27, blue: 0.46)   // Deep pink
    let questionAnswered = Color(red: 0.40, green: 0.55, blue: 0.45) // Muted sage green

    // Entry Type Background Tints (for cards, selections, highlights)
    // These use the entry type colors at ~12% opacity for subtle differentiation
    var storyBackground: Color { story.opacity(0.12) }
    var ideaBackground: Color { idea.opacity(0.12) }
    var questionBackground: Color { question.opacity(0.12) }

    // UI Colors - Using semantic colors that adapt to light/dark mode
    let background = Color(uiColor: .systemBackground)
    let surface = Color(uiColor: .secondarySystemBackground)
    let surfaceSecondary = Color(uiColor: .tertiarySystemBackground)
    let cardBackground = Color(uiColor: .secondarySystemBackground)

    // Text Colors - Using semantic colors that adapt to light/dark mode
    let textPrimary = Color(uiColor: .label)
    let textSecondary = Color(uiColor: .secondaryLabel)
    let textTertiary = Color(uiColor: .tertiaryLabel)

    // Tier Colors
    let tierCore = Color(red: 0.72, green: 0.45, blue: 0.20)
    let tierActive = Color(red: 0.45, green: 0.45, blue: 0.50)
    let tierArchive = Color(red: 0.55, green: 0.55, blue: 0.58)
}
