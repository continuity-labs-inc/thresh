import SwiftUI

struct PromptCard: View {
    let phase: Int
    let prompt: String
    let category: PromptCategory?
    var isLoading: Bool = false
    var onRefresh: (() -> Void)? = nil

    private var phaseColor: Color {
        phase == 1 ? Color.thresh.capture : Color.thresh.synthesis
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: phase == 1 ? "eye" : "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(phaseColor)

                Text(phase == 1 ? "DESCRIBE" : "REFLECT")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(phaseColor)

                if let category = category {
                    Text("• \(category.displayName)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.thresh.textTertiary)
                }

                Spacer()

                // Refresh button - available for both phases when onRefresh provided
                if let onRefresh = onRefresh {
                    Button(action: onRefresh) {
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.7)
                                .frame(width: 28, height: 28)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(phaseColor)
                                .frame(width: 28, height: 28)
                                .background(
                                    Circle()
                                        .fill(phaseColor.opacity(0.15))
                                )
                        }
                    }
                    .disabled(isLoading)
                }
            }

            if isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Generating prompt...")
                        .font(.system(size: 14))
                        .foregroundColor(Color.thresh.textTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            } else {
                Text(prompt)
                    .font(.system(size: 16))
                    .foregroundColor(Color.thresh.textPrimary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((phase == 1 ? Color.thresh.capture : Color.thresh.synthesis).opacity(0.1))
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        PromptCard(
            phase: 1,
            prompt: "Describe someone you interacted with today. How do they move? What's their voice like?",
            category: .person
        )

        PromptCard(
            phase: 2,
            prompt: "What did you leave out about them? What would they say you got wrong?",
            category: .person
        )
    }
    .padding()
    .background(Color.thresh.background)
}
