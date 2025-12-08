import SwiftUI
import SwiftData

struct NewStoryScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var storyTitle = ""
    @State private var storyContent = ""
    
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
                
                Text("New Story")
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
                Image(systemName: "book.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.vm.story)
                
                Text("Story Mode")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.vm.story)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.vm.story.opacity(0.1))
            )
            .padding(.bottom, 24)
            
            ScrollView {
                VStack(spacing: 12) {
                    // Title Field
                    TextField("", text: $storyTitle, prompt: Text("Story title")
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
                    
                    // Story Content
                    ZStack(alignment: .topLeading) {
                        if storyContent.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tell your story in complete sentences...")
                                    .foregroundColor(Color.vm.textTertiary)
                                    .font(.system(size: 16))
                                
                                Text("Capture a scene, memory, or moment worth keeping.")
                                    .foregroundColor(Color.vm.textTertiary.opacity(0.7))
                                    .font(.system(size: 14))
                            }
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $storyContent)
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
                title: "Save Story",
                isEnabled: !storyContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: saveStory,
                theme: .green
            )
        }
        .background(Color.vm.background)
    }
    
    private func saveStory() {
        let trimmedContent = storyContent.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTitle = storyTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedContent.isEmpty else { return }
        
        let newStory = Story(
            title: trimmedTitle.isEmpty ? "Untitled Story" : trimmedTitle,
            content: trimmedContent
        )
        
        modelContext.insert(newStory)
        
        do {
            try modelContext.save()
            print("Story saved successfully")
        } catch {
            print("Error saving story: \(error)")
        }
        
        dismiss()
    }
}

#Preview {
    NewStoryScreen()
        .modelContainer(for: [Story.self])
}
