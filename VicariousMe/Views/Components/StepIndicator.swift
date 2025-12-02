import SwiftUI

/// The steps in the weekly synthesis flow
enum SynthesisStep: Int, CaseIterable, Identifiable {
    /// Review and select captures from the week
    case review = 0

    /// Add revision layers to selected captures
    case revise = 1

    /// Write the synthesis
    case synthesize = 2

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .review: return "Review"
        case .revise: return "Revise"
        case .synthesize: return "Synthesize"
        }
    }

    var icon: String {
        switch self {
        case .review: return "eye"
        case .revise: return "pencil"
        case .synthesize: return "sparkles"
        }
    }
}

/// Displays progress through the synthesis steps
struct StepIndicator: View {
    let currentStep: SynthesisStep

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SynthesisStep.allCases) { step in
                stepView(for: step)

                if step != .synthesize {
                    connector(after: step)
                }
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func stepView(for step: SynthesisStep) -> some View {
        let isCompleted = step.rawValue < currentStep.rawValue
        let isCurrent = step == currentStep

        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isCompleted || isCurrent ? Color.vm.synthesis : Color.vm.surface)
                    .frame(width: 32, height: 32)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: step.icon)
                        .font(.caption)
                        .foregroundStyle(isCurrent ? .white : .secondary)
                }
            }

            Text(step.title)
                .font(.caption2)
                .foregroundStyle(isCurrent ? Color.vm.synthesis : .secondary)
        }
    }

    @ViewBuilder
    private func connector(after step: SynthesisStep) -> some View {
        let isCompleted = step.rawValue < currentStep.rawValue

        Rectangle()
            .fill(isCompleted ? Color.vm.synthesis : Color.vm.surface)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
    }
}

#Preview("Review Step") {
    StepIndicator(currentStep: .review)
        .padding()
}

#Preview("Revise Step") {
    StepIndicator(currentStep: .revise)
        .padding()
}

#Preview("Synthesize Step") {
    StepIndicator(currentStep: .synthesize)
        .padding()
}
