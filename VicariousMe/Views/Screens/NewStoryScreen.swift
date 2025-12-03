import SwiftUI

struct NewStoryScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var storyTitle = ""
    @State private var storyText = ""
    
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
            
            // Title Field
            TextField("", text: $storyTitle, prompt: Text("Title (optional)")
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
            .padding(.bottom, 12)
            
            // Story Text Input
            ZStack(alignment: .topLeading) {
                if storyText.isEmpty {
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
                
                TextEditor(text: $storyText)
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
                title: "Save Story",
                isEnabled: !storyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: saveStory,
                theme: .green
            )
        }
        .background(Color.vm.background)
    }
    
    private func saveStory() {
        // TODO: Save story logic
        print("Saving story: \(storyText)")
        dismiss()
    }
}

#Preview {
    NewStoryScreen()
}
