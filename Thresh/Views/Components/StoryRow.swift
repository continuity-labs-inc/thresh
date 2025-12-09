import SwiftUI

struct StoryRow: View {
    let story: Story

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
