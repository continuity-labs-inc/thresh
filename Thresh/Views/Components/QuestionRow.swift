import SwiftUI

struct QuestionRow: View {
    @Bindable var question: Question
    @State private var showExtractedTooltip = false

    var body: some View {
        NavigationLink(destination: QuestionDetailScreen(question: question)) {
            VStack(alignment: .leading, spacing: 8) {
                // Header with icon, status, and time
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "questionmark.circle.fill")
                        Text("QUESTION")
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.thresh.question)

                    if question.source == .extractedFromReflection {
                        ExtractedBadge(showTooltip: $showExtractedTooltip)
                    }

                    if question.isAnswered {
                        Text("ANSWERED")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.thresh.questionAnswered.opacity(0.15))
                            .foregroundStyle(Color.thresh.questionAnswered)
                            .clipShape(Capsule())
                    }

                    Spacer()

                    Text(question.createdAt.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)
                }

                // Question text
                Text(question.text)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(Color.thresh.textPrimary)

                // Context preview (if exists)
                if let context = question.context, !context.isEmpty {
                    Text(context)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundStyle(Color.thresh.textSecondary)
                }
            }
            .padding()
            .background(Color.thresh.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                question.deletedAt = Date()
                question.updatedAt = Date()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .featureTooltip(
            title: "↗ Extracted",
            message: "This came from one of your reflections. We noticed it embedded in your writing and pulled it out so you could track it separately.\n\nTap to see the source reflection.",
            featureKey: "hasSeenExtractedIntro",
            isPresented: $showExtractedTooltip
        )
    }
}

#Preview {
    NavigationStack {
        VStack {
            QuestionRow(question: Question(
                text: "What would I do differently if I weren't afraid of failure?",
                context: "Came up during a reflection about career choices"
            ))

            QuestionRow(question: Question(
                text: "Why do I find it hard to celebrate my own successes?",
                isAnswered: true
            ))
        }
        .padding()
    }
    .modelContainer(for: Question.self, inMemory: true)
}
