import SwiftUI

struct ObservationPromptsView: View {
    let questions: [String]
    let onAddMore: (String) -> Void
    let onSkip: () -> Void

    @State private var answerText = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header explanation
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "eye")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.thresh.capture)

                                Text("GET SPECIFIC")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.thresh.capture)
                            }

                            Text("Your reflection has some general statements. Adding concrete details makes it richer to work with later.")
                                .font(.system(size: 16))
                                .foregroundColor(Color.thresh.textSecondary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.thresh.capture.opacity(0.1))
                        )

                        // Questions as prompt cards
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Consider answering:")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color.thresh.textSecondary)

                            ForEach(questions, id: \.self) { question in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.thresh.capture)

                                    Text(question)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color.thresh.textPrimary)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.thresh.surface)
                                )
                            }
                        }

                        // Text input area
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Add more details:")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color.thresh.textSecondary)

                            ZStack(alignment: .topLeading) {
                                if answerText.isEmpty {
                                    Text("Describe what specifically happened...")
                                        .foregroundColor(Color.thresh.textTertiary)
                                        .font(.system(size: 16))
                                        .padding(.top, 12)
                                        .padding(.leading, 12)
                                }

                                TextEditor(text: $answerText)
                                    .foregroundColor(Color.thresh.textPrimary)
                                    .font(.system(size: 16))
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 150)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.thresh.surface)
                            )
                        }

                        Color.clear.frame(height: 20)
                    }
                    .padding(20)
                }

                // Bottom buttons
                VStack(spacing: 12) {
                    Button(action: {
                        let trimmed = answerText.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty {
                            onAddMore(trimmed)
                        }
                    }) {
                        Text("Add to Reflection")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                          ? Color.thresh.surfaceSecondary
                                          : Color.thresh.capture)
                            )
                    }
                    .disabled(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    Button(action: onSkip) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.thresh.textSecondary)
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .background(Color.thresh.background)
            }
            .background(Color.thresh.background)
            .navigationTitle("Add Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onSkip()
                    }
                }
            }
        }
    }
}

#Preview {
    ObservationPromptsView(
        questions: [
            "What did they specifically say?",
            "What time of day was this?",
            "What were you doing right before this happened?"
        ],
        onAddMore: { _ in },
        onSkip: {}
    )
}
