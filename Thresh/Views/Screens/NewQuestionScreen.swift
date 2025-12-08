import SwiftUI
import SwiftData

struct NewQuestionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var questionText = ""
    @State private var questionContext = ""
    
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
            
            ScrollView {
                VStack(spacing: 12) {
                    // Question Text
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
                    
                    // Context Label
                    Text("Context (optional)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color.vm.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    // Context Field
                    ZStack(alignment: .topLeading) {
                        if questionContext.isEmpty {
                            Text("Add any context that helps explain where this question came from...")
                                .foregroundColor(Color.vm.textTertiary)
                                .font(.system(size: 16))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $questionContext)
                            .foregroundColor(Color.vm.textPrimary)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.vm.surface)
                    )
                    .padding(.horizontal, 20)
                    
                    Color.clear.frame(height: 100)
                }
            }
            
            Spacer()
            
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
        let trimmedText = questionText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContext = questionContext.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return }
        
        let newQuestion = Question(
            text: trimmedText,
            context: trimmedContext.isEmpty ? nil : trimmedContext
        )
        
        modelContext.insert(newQuestion)
        
        do {
            try modelContext.save()
            print("Question saved successfully")
        } catch {
            print("Error saving question: \(error)")
        }
        
        dismiss()
    }
}

#Preview {
    NewQuestionScreen()
        .modelContainer(for: [Question.self])
}
