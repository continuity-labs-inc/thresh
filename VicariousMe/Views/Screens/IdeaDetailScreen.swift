import SwiftUI
import SwiftData

struct IdeaDetailScreen: View {
    @Bindable var idea: Idea
    @Environment(\.modelContext) private var modelContext

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

                    if let category = idea.category {
                        Text(category)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.vm.surfaceSecondary)
                            .clipShape(Capsule())
                    }

                    Spacer()
                }

                // Title
                Text(idea.title)
                    .font(.title)
                    .fontWeight(.bold)

                // Description
                Text(idea.details)
                    .font(.body)
                    .lineSpacing(4)

                // Tags (if any)
                if !idea.tags.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(idea.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.vm.idea.opacity(0.15))
                                .foregroundStyle(Color.vm.idea)
                                .clipShape(Capsule())
                        }
                    }
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(idea.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if idea.updatedAt != idea.createdAt {
                        Text("Updated \(idea.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Idea")
        .navigationBarTitleDisplayMode(.inline)
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
