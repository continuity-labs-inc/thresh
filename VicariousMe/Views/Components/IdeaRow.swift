import SwiftUI

struct IdeaRow: View {
    let idea: Idea

    var body: some View {
        NavigationLink(destination: IdeaDetailScreen(idea: idea)) {
            VStack(alignment: .leading, spacing: 8) {
                // Header with icon, category, and time
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                        Text("IDEA")
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.vm.idea)

                    if let category = idea.category {
                        Text(category)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.vm.surfaceSecondary)
                            .clipShape(Capsule())
                    }

                    Spacer()

                    Text(idea.createdAt.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Title
                Text(idea.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.primary)

                // Description preview
                Text(previewText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.vm.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var previewText: String {
        let content = idea.details
        if content.count > 80 {
            return String(content.prefix(80)) + "..."
        }
        return content
    }
}

#Preview {
    NavigationStack {
        IdeaRow(idea: Idea(
            title: "Morning Journaling Routine",
            details: "Start each day with 10 minutes of free writing before checking any devices.",
            category: "Habits"
        ))
        .padding()
    }
    .modelContainer(for: Idea.self, inMemory: true)
}
