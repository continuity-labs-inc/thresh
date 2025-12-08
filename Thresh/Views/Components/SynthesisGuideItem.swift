import SwiftUI

/// A single guidance item for the synthesis step.
/// Displays an icon and text to prompt reflective thinking.
struct SynthesisGuideItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.thresh.synthesis)
                .frame(width: 20)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textPrimary)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        SynthesisGuideItem(
            icon: "link",
            text: "What thread runs through these moments?"
        )
        SynthesisGuideItem(
            icon: "questionmark.circle",
            text: "What question is this week asking you?"
        )
        SynthesisGuideItem(
            icon: "sparkles",
            text: "What do you understand now that you didn't before?"
        )
    }
    .padding()
}
