import SwiftUI
import SwiftData

struct NewIdeaScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var ideaTitle = ""
    @State private var ideaDetails = ""
    
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
                
                Text("New Idea")
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
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.vm.idea)
                
                Text("Idea Mode")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.vm.idea)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.vm.idea.opacity(0.1))
            )
            .padding(.bottom, 24)
            
            ScrollView {
                VStack(spacing: 12) {
                    // Title Field
                    TextField("", text: $ideaTitle, prompt: Text("Idea title")
                        .foregroundColor(Color.vm.textTertiary)
                    )
                    .foregroundColor(Color.vm.textPrimary)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.vm.surface)
                    )
                    .padding(.horizontal, 20)
                    
                    // Idea Details
                    ZStack(alignment: .topLeading) {
                        if ideaDetails.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Capture your idea in complete sentences...")
                                    .foregroundColor(Color.vm.textTertiary)
                                    .font(.system(size: 16))
                                
                                Text("Record an insight, seed, or thought worth remembering.")
                                    .foregroundColor(Color.vm.textTertiary.opacity(0.7))
                                    .font(.system(size: 14))
                            }
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $ideaDetails)
                            .foregroundColor(Color.vm.textPrimary)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 300)
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
                title: "Save Idea",
                isEnabled: !ideaDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: saveIdea,
                theme: .orange
            )
        }
        .background(Color.vm.background)
    }
    
    private func saveIdea() {
        let trimmedDetails = ideaDetails.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTitle = ideaTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedDetails.isEmpty else { return }
        
        let newIdea = Idea(
            title: trimmedTitle.isEmpty ? "Untitled Idea" : trimmedTitle,
            details: trimmedDetails
        )
        
        modelContext.insert(newIdea)
        
        do {
            try modelContext.save()
            print("Idea saved successfully")
        } catch {
            print("Error saving idea: \(error)")
        }
        
        dismiss()
    }
}

#Preview {
    NewIdeaScreen()
        .modelContainer(for: [Idea.self])
}
