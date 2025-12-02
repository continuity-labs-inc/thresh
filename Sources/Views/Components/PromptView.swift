import SwiftUI

/// A view component that displays a reflection prompt.
/// Visually differentiates capture prompts from synthesis prompts.
struct PromptView: View {
    let prompt: Prompt
    let mode: ReflectionMode

    /// Optional callback when the follow-up is tapped
    var onFollowUpTap: (() -> Void)? = nil

    /// Whether to show the follow-up prompt
    var showFollowUp: Bool = true

    /// Compact mode for smaller displays
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 6 : 8) {
            // Mode indicator
            HStack(spacing: 6) {
                Image(systemName: mode == .capture ? "camera.fill" : "sparkles")
                    .font(compact ? .caption2 : .caption)
                Text(mode == .capture ? "CAPTURE" : "SYNTHESIS")
                    .font(compact ? .caption2 : .caption)
                    .fontWeight(.semibold)
                    .tracking(0.5)
            }
            .foregroundStyle(modeColor)

            // Prompt text
            if !prompt.text.isEmpty {
                Text(prompt.text)
                    .font(compact ? .subheadline : .body)
                    .italic()
                    .foregroundStyle(Color.vm.primary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                // Blank space prompt for fluent users
                Text("What do you want to capture?")
                    .font(compact ? .subheadline : .body)
                    .italic()
                    .foregroundStyle(Color.vm.tertiary)
            }

            // Follow-up prompt (if available and enabled)
            if showFollowUp, let followUp = prompt.followUp {
                Button(action: { onFollowUpTap?() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.turn.down.right")
                            .font(.caption2)
                        Text(followUp)
                            .font(.caption)
                            .italic()
                    }
                    .foregroundStyle(Color.vm.secondary)
                }
                .buttonStyle(.plain)
                .disabled(onFollowUpTap == nil)
            }
        }
        .padding(compact ? 12 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: compact ? 8 : 12)
                .fill(modeColor.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: compact ? 8 : 12)
                .stroke(modeColor.opacity(0.2), lineWidth: 1)
        )
    }

    private var modeColor: Color {
        mode == .capture ? Color.vm.capture : Color.vm.synthesis
    }
}

// MARK: - Prompt Card View

/// A larger card-style prompt view for featured prompts
struct PromptCardView: View {
    let prompt: Prompt
    let mode: ReflectionMode
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 12) {
                // Mode badge
                HStack {
                    Label(
                        mode == .capture ? "Capture" : "Synthesis",
                        systemImage: mode == .capture ? "camera.fill" : "sparkles"
                    )
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(modeColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(modeColor.opacity(0.15))
                    )

                    Spacer()

                    if prompt.isHumor {
                        Image(systemName: "face.smiling")
                            .font(.caption)
                            .foregroundStyle(Color.vm.tertiary)
                    }
                }

                // Prompt text
                Text(prompt.text)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.vm.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                // Follow-up hint
                if let followUp = prompt.followUp {
                    Text(followUp)
                        .font(.subheadline)
                        .foregroundStyle(Color.vm.secondary)
                        .italic()
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.vm.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(modeColor.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var modeColor: Color {
        mode == .capture ? Color.vm.capture : Color.vm.synthesis
    }
}

// MARK: - Capture Quality Prompt View

/// A specialized view for capture quality improvement prompts
struct CaptureQualityPromptView: View {
    let prompt: Prompt
    let gap: CaptureGap?
    var onApply: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                Image(systemName: "arrow.up.circle")
                    .foregroundStyle(Color.vm.accent)
                Text("Improve your capture")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.vm.accent)
                Spacer()
            }

            // Suggestion
            Text(prompt.text)
                .font(.subheadline)
                .foregroundStyle(Color.vm.primary)
                .fixedSize(horizontal: false, vertical: true)

            // Follow-up
            if let followUp = prompt.followUp {
                Text(followUp)
                    .font(.caption)
                    .foregroundStyle(Color.vm.secondary)
                    .italic()
            }

            // Apply button
            if let onApply = onApply {
                Button(action: onApply) {
                    Text("Add details")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.vm.capture.opacity(0.15))
                        .foregroundStyle(Color.vm.capture)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vm.accent.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.vm.accent.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Aggregation Prompt View

/// A view for tier aggregation prompts (weekly, monthly, etc.)
struct AggregationPromptView: View {
    let prompt: Prompt
    let tier: ReflectionTier

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Tier indicator
            HStack {
                Image(systemName: tierIcon)
                Text(tier.displayName.uppercased() + " SYNTHESIS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .tracking(0.5)
            }
            .foregroundStyle(Color.vm.color(for: tier))

            // Main prompt
            Text(prompt.text)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(Color.vm.primary)

            // Follow-up
            if let followUp = prompt.followUp {
                Text(followUp)
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.secondary)
                    .italic()
            }

            // Tier description
            Text(tier.synthesisDescription)
                .font(.caption)
                .foregroundStyle(Color.vm.tertiary)
                .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.vm.color(for: tier).opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.vm.color(for: tier).opacity(0.25), lineWidth: 1)
        )
    }

    private var tierIcon: String {
        switch tier {
        case .daily: return "sun.max"
        case .weekly: return "calendar.badge.clock"
        case .monthly: return "calendar"
        case .quarterly: return "chart.bar"
        case .yearly: return "star.circle"
        }
    }
}

// MARK: - Preview Provider

#Preview("Capture Prompt") {
    VStack(spacing: 16) {
        PromptView(
            prompt: Prompt(
                id: "test_capture",
                mode: .capture,
                type: .primary,
                text: "Describe the scene like a camera would record it. No meanings—just what happened.",
                followUp: "What detail stands out most?"
            ),
            mode: .capture
        )

        PromptView(
            prompt: Prompt(
                id: "test_synthesis",
                mode: .synthesis,
                type: .primary,
                text: "Now that you've captured it: why did this stick with you?",
                followUp: "What does that tell you about what you value?"
            ),
            mode: .synthesis
        )
    }
    .padding()
    .background(Color.vm.background)
}

#Preview("Prompt Card") {
    PromptCardView(
        prompt: Prompt(
            id: "card_test",
            mode: .capture,
            type: .primary,
            text: "What did you see, hear, smell, or feel? One specific detail.",
            followUp: "Can you add another sensory detail?",
            isHumor: false
        ),
        mode: .capture
    )
    .padding()
    .background(Color.vm.background)
}

#Preview("Aggregation Prompt") {
    AggregationPromptView(
        prompt: Prompt(
            id: "agg_test",
            mode: .synthesis,
            type: .aggregation,
            tier: .weekly,
            text: "If this week were a chapter, what would it be called?",
            followUp: "What's the first line of the next chapter?"
        ),
        tier: .weekly
    )
    .padding()
    .background(Color.vm.background)
}
