import SwiftUI

struct StoryRow: View {
    @Bindable var story: Story
    @State private var showExtractedTooltip = false

    var body: some View {
        NavigationLink(destination: StoryDetailScreen(story: story)) {
            VStack(alignment: .leading, spacing: 8) {
                // Header with icon and time
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                        Text("STORY")
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.thresh.story)

                    if story.source == .extractedFromReflection {
                        ExtractedBadge(showTooltip: $showExtractedTooltip)
                    }

                    Spacer()

                    Text(story.createdAt.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)
                }

                // Title
                Text(story.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(Color.thresh.textPrimary)

                // Content preview
                Text(previewText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(Color.thresh.textSecondary)
            }
            .padding()
            .background(Color.thresh.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                story.deletedAt = Date()
                story.updatedAt = Date()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .featureTooltip(
            title: "↗ Extracted",
            message: "This came from one of your reflections. We noticed it embedded in your writing and pulled it out so you could track it separately.\n\nTap to see the source reflection.",
            featureKey: "hasSeenExtractedIntro",
            isPresented: $showExtractedTooltip
        )
    }

    private var previewText: String {
        let content = story.content
        if content.count > 80 {
            return String(content.prefix(80)) + "..."
        }
        return content
    }
}

#Preview {
    NavigationStack {
        StoryRow(story: Story(
            title: "The Day Everything Changed",
            content: "It started like any other Tuesday morning, but by noon, I realized nothing would ever be quite the same..."
        ))
        .padding()
    }
    .modelContainer(for: Story.self, inMemory: true)
}
