import SwiftUI
import SwiftData

struct IdeaDetailScreen: View {
    @Bindable var idea: Idea
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Edit mode state
    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var editedDetails = ""
    @State private var editedCategory = ""

    // Delete confirmation
    @State private var showDeleteConfirmation = false

    // Copy feedback
    @State private var showCopiedToast = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with category
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                        Text("IDEA")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.vm.idea)

                    if !isEditing, let category = idea.category {
                        Text(category)
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.vm.surfaceSecondary)
                            .clipShape(Capsule())
                    }

                    Spacer()
                }

                // Category (editable)
                if isEditing {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Category (optional)")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)
                        TextField("Category", text: $editedCategory)
                            .font(.subheadline)
                            .foregroundStyle(Color.vm.textPrimary)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.vm.surface)
                            )
                    }
                }

                // Title
                if isEditing {
                    TextField("Title", text: $editedTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.vm.textPrimary)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.vm.surface)
                        )
                } else {
                    Text(idea.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.vm.textPrimary)
                        .textSelection(.enabled)
                        .contextMenu {
                            Button(action: { copyText(idea.title) }) {
                                Label("Copy Title", systemImage: "doc.on.doc")
                            }
                        }
                }

                // Description
                if isEditing {
                    TextField("Details", text: $editedDetails, axis: .vertical)
                        .font(.body)
                        .foregroundStyle(Color.vm.textPrimary)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.vm.surface)
                        )
                } else {
                    Text(idea.details)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundStyle(Color.vm.textPrimary)
                        .textSelection(.enabled)
                        .contextMenu {
                            Button(action: { copyText(idea.details) }) {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                        }
                }

                // Tags (if any)
                if !idea.tags.isEmpty && !isEditing {
                    FlowLayout(spacing: 8) {
                        ForEach(idea.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.vm.ideaBackground)
                                .foregroundStyle(Color.vm.idea)
                                .clipShape(Capsule())
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
                                        .fill(Color.vm.idea)
                                )
                        }
                    }
                    .padding(.top, 8)
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(idea.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(Color.vm.textSecondary)

                    if idea.updatedAt != idea.createdAt {
                        Text("Updated \(idea.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Idea")
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
        .alert("Delete Idea?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteIdea)
        } message: {
            Text("This idea will be moved to Recently Deleted for 30 days.")
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
    }

    private func startEditing() {
        editedTitle = idea.title
        editedDetails = idea.details
        editedCategory = idea.category ?? ""
        isEditing = true
    }

    private func cancelEdit() {
        isEditing = false
        editedTitle = ""
        editedDetails = ""
        editedCategory = ""
    }

    private func saveEdit() {
        let trimmedTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = editedDetails.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCategory = editedCategory.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty && !trimmedDetails.isEmpty else { return }

        idea.title = trimmedTitle
        idea.details = trimmedDetails
        idea.category = trimmedCategory.isEmpty ? nil : trimmedCategory
        idea.updatedAt = Date()

        do {
            try modelContext.save()
            print("Idea updated successfully")
        } catch {
            print("Failed to save idea: \(error)")
        }

        isEditing = false
    }

    private func deleteIdea() {
        // Soft delete - set deletedAt timestamp
        idea.deletedAt = Date()
        idea.updatedAt = Date()

        do {
            try modelContext.save()
            print("Idea moved to Recently Deleted")
        } catch {
            print("Failed to delete idea: \(error)")
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
        var allText = idea.title
        if let category = idea.category {
            allText += " [\(category)]"
        }
        allText += "\n\n\(idea.details)"
        copyText(allText)
    }
}

#Preview {
    NavigationStack {
        IdeaDetailScreen(idea: Idea(
            title: "Morning Journaling Routine",
            details: "Start each day with 10 minutes of free writing before checking any devices. This helps clear the mind and set intentions for the day.\n\nThe key is consistency over perfection. Even a few sentences count.",
            category: "Habits"
        ))
    }
    .modelContainer(for: Idea.self, inMemory: true)
}
