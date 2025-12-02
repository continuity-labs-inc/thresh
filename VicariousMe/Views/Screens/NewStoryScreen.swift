import SwiftUI
import SwiftData

struct NewStoryScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case title, content
    }

    var body: some View {
        VStack(spacing: 0) {
            // Mode indicator
            HStack {
                Image(systemName: "book.fill")
                Text("Story Mode")
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundStyle(Color.vm.story)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.vm.story.opacity(0.1))

            ScrollView {
                VStack(spacing: 16) {
                    // Title field
                    TextField("Story Title", text: $title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .focused($focusedField, equals: .title)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Content field
                    TextEditor(text: $content)
                        .focused($focusedField, equals: .content)
                        .frame(minHeight: 200)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }

            Spacer()

            // Save button
            Button(action: saveStory) {
                Text("Save Story")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        isValid
                            ? Color.vm.story
                            : Color.vm.surfaceSecondary
                    )
                    .foregroundStyle(isValid ? .white : .secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!isValid)
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("New Story")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            focusedField = .title
        }
    }

    private var isValid: Bool {
        !title.isEmpty && !content.isEmpty
    }

    private func saveStory() {
        let story = Story(title: title, content: content)
        modelContext.insert(story)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        NewStoryScreen()
            .modelContainer(for: Story.self, inMemory: true)
    }
}
