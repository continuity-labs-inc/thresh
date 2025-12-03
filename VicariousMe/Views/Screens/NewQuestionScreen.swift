import SwiftUI

struct NewQuestionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var questionText = ""
    @State private var contextText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.vm.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.vm.surface))
                }
                
                Spacer()
                
                Text("New Question")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.vm.textSecondary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.vm.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.vm.textPrimary, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
            
            // Mode Badge
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.vm.question)
                
                Text("Question Mode")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.vm.question)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.vm.question.opacity(0.1))
            )
            .padding(.bottom, 24)
            
            // Question Text Input
            ZStack(alignment: .topLeading) {
                if questionText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("What question are you holding?")
                            .foregroundColor(Color.vm.textTertiary)
                            .font(.system(size: 16))
                        
                        Text("Write it as a complete question.")
                            .foregroundColor(Color.vm.textTertiary.opacity(0.7))
                            .font(.system(size: 14))
                    }
                    .padding(.top, 8)
                    .padding(.leading, 5)
                }
                
                TextEditor(text: $questionText)
                    .foregroundColor(Color.vm.textPrimary)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .frame(height: 120)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.vm.surface)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            // Context Label
            Text("Context (optional)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.vm.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            
            // Context Text Input
            ZStack(alignment: .topLeading) {
                if contextText.isEmpty {
                    Text("Add any context that helps explain where this question came from...")
                        .foregroundColor(Color.vm.textTertiary)
                        .font(.system(size: 16))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                TextEditor(text: $contextText)
                    .foregroundColor(Color.vm.textPrimary)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.vm.surface)
            )
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Save Button
            SaveButton(
                title: "Save Question",
                isEnabled: !questionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: saveQuestion,
                theme: .pink
            )
        }
        .background(Color.vm.background)
    }
    
    private func saveQuestion() {
        // TODO: Save question logic
        print("Saving question: \(questionText)")
        if !contextText.isEmpty {
            print("Context: \(contextText)")
        }
        dismiss()
    }
}

#Preview {
    NewQuestionScreen()
}
