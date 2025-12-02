import SwiftUI

/// Modal for reviewing and selecting extracted questions from a reflection
struct QuestionExtractionModal: View {
    let questions: [String]
    let onSave: ([String]) -> Void
    let onSkip: () -> Void

    @State private var selectedQuestions: Set<String> = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header explanation
                VStack(spacing: 8) {
                    Image(systemName: "questionmark.bubble.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.vm.synthesis)

                    Text("Questions Emerged")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("We noticed some questions in your reflection. Would you like to save any for future exploration?")
                        .font(.subheadline)
                        .foregroundStyle(Color.vm.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)

                // Questions list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(questions, id: \.self) { question in
                            QuestionSelectionRow(
                                question: question,
                                isSelected: selectedQuestions.contains(question),
                                onToggle: {
                                    toggleQuestion(question)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // Action buttons
                VStack(spacing: 12) {
                    if !selectedQuestions.isEmpty {
                        Button(action: saveSelected) {
                            HStack {
                                Image(systemName: "bookmark.fill")
                                Text("Save \(selectedQuestions.count) Question\(selectedQuestions.count == 1 ? "" : "s")")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.vm.synthesis)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Button(action: skip) {
                        Text(selectedQuestions.isEmpty ? "Skip" : "Skip questions")
                            .font(.subheadline)
                            .foregroundStyle(Color.vm.textSecondary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        if selectedQuestions.isEmpty {
                            skip()
                        } else {
                            saveSelected()
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Actions

    private func toggleQuestion(_ question: String) {
        if selectedQuestions.contains(question) {
            selectedQuestions.remove(question)
        } else {
            selectedQuestions.insert(question)
        }
    }

    private func saveSelected() {
        onSave(Array(selectedQuestions))
        dismiss()
    }

    private func skip() {
        onSkip()
        dismiss()
    }
}

// MARK: - Question Selection Row

struct QuestionSelectionRow: View {
    let question: String
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.vm.synthesis : Color.vm.textMuted)
                    .font(.title3)

                // Question text
                Text(question)
                    .font(.body)
                    .foregroundStyle(Color.vm.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected
                        ? Color.vm.synthesis.opacity(0.1)
                        : Color.vm.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected
                        ? Color.vm.synthesis.opacity(0.3)
                        : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Loading State

struct QuestionExtractionLoading: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)

            Text("Looking for questions...")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.vm.surface.opacity(0.95))
    }
}

// MARK: - Preview

#Preview {
    QuestionExtractionModal(
        questions: [
            "Why did that interaction feel so uncomfortable?",
            "What am I really looking for in this situation?",
            "How can I respond differently next time?"
        ],
        onSave: { questions in
            print("Saved: \(questions)")
        },
        onSkip: {
            print("Skipped")
        }
    )
}
