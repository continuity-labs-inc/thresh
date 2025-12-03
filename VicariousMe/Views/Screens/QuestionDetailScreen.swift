import SwiftUI
import SwiftData

struct QuestionDetailScreen: View {
    @Bindable var question: Question
    @Environment(\.modelContext) private var modelContext
    @State private var answerText: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with status
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "questionmark.circle.fill")
                        Text("QUESTION")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.vm.question)

                    if question.isAnswered {
                        Text("ANSWERED")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.15))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }

                    Spacer()
                }

                // Question text
                Text(question.text)
                    .font(.title2)
                    .fontWeight(.semibold)

                // Context (if exists)
                if let context = question.context, !context.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Context")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)

                        Text(context)
                            .font(.body)
                            .padding()
                            .background(Color.vm.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                // Answer section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Answer")
                        .font(.headline)

                    if let answer = question.answer, !answer.isEmpty {
                        Text(answer)
                            .font(.body)
                            .lineSpacing(4)
                            .padding()
                            .background(Color.vm.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        TextEditor(text: $answerText)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color.vm.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Button(action: saveAnswer) {
                            Text("Save Answer")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    answerText.isEmpty
                                        ? Color.vm.surfaceSecondary
                                        : Color.vm.question
                                )
                                .foregroundStyle(answerText.isEmpty ? Color.secondary : Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(answerText.isEmpty)
                    }
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(question.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(Color.vm.textSecondary)

                    if question.updatedAt != question.createdAt {
                        Text("Updated \(question.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Question")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            answerText = question.answer ?? ""
        }
    }

    private func saveAnswer() {
        question.answer = answerText
        question.isAnswered = true
        question.updatedAt = Date()
    }
}

#Preview {
    NavigationStack {
        QuestionDetailScreen(question: Question(
            text: "What would I do differently if I weren't afraid of failure?",
            context: "Came up during a reflection about career choices"
        ))
    }
    .modelContainer(for: Question.self, inMemory: true)
}
