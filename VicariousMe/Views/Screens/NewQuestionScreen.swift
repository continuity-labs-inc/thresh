import SwiftUI
import SwiftData

struct NewQuestionScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var questionText: String = ""
    @State private var context: String = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case question, context
    }

    var body: some View {
        VStack(spacing: 0) {
            // Mode indicator
            HStack {
                Image(systemName: "questionmark.circle.fill")
                Text("Question Mode")
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundStyle(Color.vm.question)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.vm.question.opacity(0.1))

            ScrollView {
                VStack(spacing: 16) {
                    // Question field
                    TextField("What's your question?", text: $questionText, axis: .vertical)
                        .font(.title3)
                        .focused($focusedField, equals: .question)
                        .lineLimit(3...6)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Context field (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Context (optional)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $context)
                            .focused($focusedField, equals: .context)
                            .frame(minHeight: 100)
                            .padding()
                            .background(Color.vm.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }

            Spacer()

            // Save button
            Button(action: saveQuestion) {
                Text("Save Question")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        isValid
                            ? Color.vm.question
                            : Color.vm.surfaceSecondary
                    )
                    .foregroundStyle(isValid ? .white : .secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!isValid)
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("New Question")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            focusedField = .question
        }
    }

    private var isValid: Bool {
        !questionText.isEmpty
    }

    private func saveQuestion() {
        let question = Question(
            text: questionText,
            context: context.isEmpty ? nil : context
        )
        modelContext.insert(question)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        NewQuestionScreen()
            .modelContainer(for: Question.self, inMemory: true)
    }
}
