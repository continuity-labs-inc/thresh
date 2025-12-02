import SwiftUI

/// Extension to provide easy access to Vicarious Me's color palette
extension Color {
    /// Access to Vicarious Me's branded colors
    static let vm = VMColors()
}

/// Vicarious Me's color palette
/// All colors are defined in Assets.xcassets with light/dark mode variants
struct VMColors: Sendable {
    /// Blue (#3B82F6) — Primary color for Capture Mode
    let capture = Color("CaptureColor")

    /// Purple (#8B5CF6) — Primary color for Synthesis Mode
    let synthesis = Color("SynthesisColor")

    /// Indigo (#6366F1) — Accent color for stories
    let story = Color("StoryColor")

    /// Emerald (#22C55E) — Accent color for ideas
    let idea = Color("IdeaColor")

    /// Amber (#F59E0B) — Accent color for questions
    let question = Color("QuestionColor")

    /// Adaptive white/gray-900 — Surface color for cards and containers
    let surface = Color("SurfaceColor")
    
    /// Adaptive gray-100/gray-800 — Secondary surface color
    let surfaceSecondary = Color("SurfaceSecondaryColor")

    /// Adaptive gray-50/black — Background color for the app
    let background = Color("BackgroundColor")
}

/// Preview helper to showcase all colors
#Preview("VM Color Palette") {
    ScrollView {
        VStack(spacing: 16) {
            ColorSwatch(name: "Capture", color: .vm.capture)
            ColorSwatch(name: "Synthesis", color: .vm.synthesis)
            ColorSwatch(name: "Story", color: .vm.story)
            ColorSwatch(name: "Idea", color: .vm.idea)
            ColorSwatch(name: "Question", color: .vm.question)
            ColorSwatch(name: "Surface", color: .vm.surface)
            ColorSwatch(name: "Background", color: .vm.background)
        }
        .padding()
    }
}

private struct ColorSwatch: View {
    let name: String
    let color: Color

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )

            Text(name)
                .font(.headline)

            Spacer()
        }
    }
}
