import SwiftUI
import SwiftData

struct QuestionDetailScreen: View {
    @Bindable var question: Question
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var answerText: String = ""

    // Edit mode state
    @State private var isEditing = false
    @State private var editedText = ""
    @State private var editedContext = ""

    // Delete confirmation
    @State private var showDeleteConfirmation = false

    // Copy feedback
    @State private var showCopiedToast = false

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
                            .background(Color.vm.questionAnswered.opacity(0.15))
                            .foregroundStyle(Color.vm.questionAnswered)
                            .clipShape(Capsule())
                    }

                    Spacer()
                }

                // Question text
                if isEditing {
                    TextField("Question", text: $editedText, axis: .vertical)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.vm.textPrimary)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.vm.surface)
                        )
                } else {
                    Text(question.text)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.vm.textPrimary)
                        .textSelection(.enabled)
                        .contextMenu {
                            Button(action: { copyText(question.text) }) {
                                Label("Copy Question", systemImage: "doc.on.doc")
                            }
                        }
                }

                // Context (if exists or editing)
                if isEditing {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Context (optional)")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)

                        TextField("Context", text: $editedContext, axis: .vertical)
                            .font(.body)
                            .foregroundStyle(Color.vm.textPrimary)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.vm.surface)
                            )
                    }
                } else if let context = question.context, !context.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Context")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)

                        Text(context)
                            .font(.body)
                            .foregroundStyle(Color.vm.textPrimary)
                            .textSelection(.enabled)
                            .padding()
                            .background(Color.vm.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contextMenu {
                                Button(action: { copyText(context) }) {
                                    Label("Copy Context", systemImage: "doc.on.doc")
                                }
                            }
                    }
                }

                // Edit mode buttons
                if isEditing {
                    HStack(spacing: 16) {
                        Button(action: cancelEdit) {
                            Text("Cancel")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.vm.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.vm.surface)
                                )
                        }

                        Button(action: saveEdit) {
                            Text("Save Changes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.vm.question)
                                )
                        }
                    }
                    .padding(.top, 8)
                }

                // Answer section (only show when not editing the question)
                if !isEditing {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Answer")
                            .font(.headline)
                            .foregroundStyle(Color.vm.textPrimary)

                        if let answer = question.answer, !answer.isEmpty {
                            Text(answer)
                                .font(.body)
                                .lineSpacing(4)
                                .foregroundStyle(Color.vm.textPrimary)
                                .textSelection(.enabled)
                                .padding()
                                .background(Color.vm.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .contextMenu {
                                    Button(action: { copyText(answer) }) {
                                        Label("Copy Answer", systemImage: "doc.on.doc")
                                    }
                                }
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isEditing {
                    EmptyView()
                } else {
                    Menu {
                        Button(action: startEditing) {
                            Label("Edit", systemImage: "pencil")
                        }

                        Button(action: copyAllText) {
                            Label("Copy All", systemImage: "doc.on.doc")
                        }

                        Divider()

                        Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .alert("Delete Question?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteQuestion)
        } message: {
            Text("This question will be moved to Recently Deleted for 30 days.")
        }
        .overlay(alignment: .bottom) {
            if showCopiedToast {
                Text("Copied to clipboard")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.8))
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showCopiedToast)
        .onAppear {
            answerText = question.answer ?? ""
        }
    }

    private func startEditing() {
        editedText = question.text
        editedContext = question.context ?? ""
        isEditing = true
    }

    private func cancelEdit() {
        isEditing = false
        editedText = ""
        editedContext = ""
    }

    private func saveEdit() {
        let trimmedText = editedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContext = editedContext.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else { return }

        question.text = trimmedText
        question.context = trimmedContext.isEmpty ? nil : trimmedContext
        question.updatedAt = Date()

        do {
            try modelContext.save()
            print("Question updated successfully")
        } catch {
            print("Failed to save question: \(error)")
        }

        isEditing = false
    }

    private func saveAnswer() {
        question.answer = answerText
        question.isAnswered = true
        question.updatedAt = Date()

        do {
            try modelContext.save()
            print("Answer saved successfully")
        } catch {
            print("Failed to save answer: \(error)")
        }
    }

    private func deleteQuestion() {
        // Soft delete - set deletedAt timestamp
        question.deletedAt = Date()
        question.updatedAt = Date()

        do {
            try modelContext.save()
            print("Question moved to Recently Deleted")
        } catch {
            print("Failed to delete question: \(error)")
        }

        dismiss()
    }

    private func copyText(_ text: String) {
        UIPasteboard.general.string = text
        showCopiedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopiedToast = false
        }
    }

    private func copyAllText() {
        var allText = question.text
        if let context = question.context, !context.isEmpty {
            allText += "\n\nContext: \(context)"
        }
        if let answer = question.answer, !answer.isEmpty {
            allText += "\n\nAnswer: \(answer)"
        }
        copyText(allText)
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
