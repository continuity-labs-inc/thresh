import SwiftUI

/// Displays a prompt with its guidance text in mode-appropriate styling.
struct PromptView: View {
    let prompt: AggregationPrompt
    let mode: ReflectionMode

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Main prompt text
            Text(prompt.text)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(Color.vm.textPrimary)

            // Guidance text
            if !prompt.guidance.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb")
                        .font(.caption)
                        .foregroundStyle(mode == .capture ? Color.vm.capture : Color.vm.synthesis)

                    Text(prompt.guidance)
                        .font(.subheadline)
                        .foregroundStyle(Color.vm.textSecondary)
                        .italic()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((mode == .capture ? Color.vm.capture : Color.vm.synthesis).opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((mode == .capture ? Color.vm.capture : Color.vm.synthesis).opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    PromptView(
        prompt: AggregationPrompt(
            id: "test",
            text: "What thread runs through this week's moments?",
            guidance: "Don't summarize what happened. Ask what it means.",
            stages: [.emerging]
        ),
        mode: .synthesis
    )
    .padding()
}
