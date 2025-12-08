import SwiftUI

struct QuestionRow: View {
    let question: Question

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
