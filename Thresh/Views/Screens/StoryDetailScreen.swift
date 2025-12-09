import SwiftUI
import SwiftData

struct StoryDetailScreen: View {
    @Bindable var story: Story
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Edit mode state
    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var editedContent = ""

    // Delete confirmation
    @State private var showDeleteConfirmation = false

    // Copy feedback
    @State private var showCopiedToast = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                        Text("STORY")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.thresh.story)

                    Spacer()
                }

                // Title
                if isEditing {
                    TextField("Title", text: $editedTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.thresh.textPrimary)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.thresh.surface)
                        )
                } else {
                    Text(story.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.thresh.textPrimary)
                        .textSelection(.enabled)
                        .contextMenu {
                            Button(action: { copyText(story.title) }) {
                                Label("Copy Title", systemImage: "doc.on.doc")
                            }
                        }
                }

                // Content
                if isEditing {
                    TextField("Content", text: $editedContent, axis: .vertical)
                        .font(.body)
                        .foregroundStyle(Color.thresh.textPrimary)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.thresh.surface)
                        )
                } else {
                    Text(story.content)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundStyle(Color.thresh.textPrimary)
                        .textSelection(.enabled)
                        .contextMenu {
                            Button(action: { copyText(story.content) }) {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                        }
                }

                // Tags (if any)
                if !story.tags.isEmpty && !isEditing {
                    FlowLayout(spacing: 8) {
                        ForEach(story.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.thresh.storyBackground)
                                .foregroundStyle(Color.thresh.story)
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
                                .foregroundStyle(Color.thresh.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.thresh.surface)
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
                                        .fill(Color.thresh.story)
                                )
                        }
                    }
                    .padding(.top, 8)
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(story.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)

                    if story.updatedAt != story.createdAt {
                        Text("Updated \(story.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.thresh.background)
        .navigationTitle("Story")
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
        .alert("Delete Story?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: deleteStory)
        } message: {
            Text("This story will be moved to Recently Deleted for 30 days.")
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
        editedTitle = story.title
        editedContent = story.content
        isEditing = true
    }

    private func cancelEdit() {
        isEditing = false
        editedTitle = ""
        editedContent = ""
    }

    private func saveEdit() {
        let trimmedTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = editedContent.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty && !trimmedContent.isEmpty else { return }

        story.title = trimmedTitle
        story.content = trimmedContent
        story.updatedAt = Date()

        do {
            try modelContext.save()
        } catch {
            // Handle save error silently
        }

        isEditing = false
    }

    private func deleteStory() {
        // Soft delete - set deletedAt timestamp
        story.deletedAt = Date()
        story.updatedAt = Date()

        do {
            try modelContext.save()
        } catch {
            // Handle save error silently
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
        let allText = "\(story.title)\n\n\(story.content)"
        copyText(allText)
    }
}

// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }
            self.size.height = y + rowHeight
        }
    }
}

#Preview {
    NavigationStack {
        StoryDetailScreen(story: Story(
            title: "The Day Everything Changed",
            content: "It started like any other Tuesday morning, but by noon, I realized nothing would ever be quite the same.\n\nThe sun was streaming through my office window when I got the call. At first, I thought it was just another routine update, but the tone in their voice told me otherwise."
        ))
    }
    .modelContainer(for: Story.self, inMemory: true)
}
