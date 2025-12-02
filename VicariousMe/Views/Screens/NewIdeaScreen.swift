import SwiftUI
import SwiftData

struct NewIdeaScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case title, description, category
    }

    var body: some View {
        VStack(spacing: 0) {
            // Mode indicator
            HStack {
                Image(systemName: "lightbulb.fill")
                Text("Idea Mode")
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundStyle(Color.vm.idea)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.vm.idea.opacity(0.1))

            ScrollView {
                VStack(spacing: 16) {
                    // Title field
                    TextField("Idea Title", text: $title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .focused($focusedField, equals: .title)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Category field (optional)
                    TextField("Category (optional)", text: $category)
                        .focused($focusedField, equals: .category)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Description field
                    TextEditor(text: $description)
                        .focused($focusedField, equals: .description)
                        .frame(minHeight: 150)
                        .padding()
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }

            Spacer()

            // Save button
            Button(action: saveIdea) {
                Text("Save Idea")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        isValid
                            ? Color.vm.idea
                            : Color.vm.surfaceSecondary
                    )
                    .foregroundStyle(isValid ? .white : .secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!isValid)
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("New Idea")
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
        !title.isEmpty && !description.isEmpty
    }

    private func saveIdea() {
        let idea = Idea(
            title: title,
            description: description,
            category: category.isEmpty ? nil : category
        )
        modelContext.insert(idea)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        NewIdeaScreen()
            .modelContainer(for: Idea.self, inMemory: true)
    }
}
