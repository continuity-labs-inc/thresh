import SwiftUI
import SwiftData

struct StoryDetailScreen: View {
    @Bindable var story: Story
    @Environment(\.modelContext) private var modelContext

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
                    .foregroundStyle(Color.vm.story)

                    Spacer()
                }

                // Title
                Text(story.title)
                    .font(.title)
                    .fontWeight(.bold)

                // Content
                Text(story.content)
                    .font(.body)
                    .lineSpacing(4)

                // Tags (if any)
                if !story.tags.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(story.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.vm.story.opacity(0.15))
                                .foregroundStyle(Color.vm.story)
                                .clipShape(Capsule())
                        }
                    }
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(story.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(Color.vm.textSecondary)

                    if story.updatedAt != story.createdAt {
                        Text("Updated \(story.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(Color.vm.textSecondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Story")
        .navigationBarTitleDisplayMode(.inline)
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
