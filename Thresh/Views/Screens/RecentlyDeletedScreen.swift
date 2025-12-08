import SwiftUI
import SwiftData

struct RecentlyDeletedScreen: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Reflection.deletedAt, order: .reverse)
    private var allReflections: [Reflection]

    @Query(sort: \Story.deletedAt, order: .reverse)
    private var allStories: [Story]

    @Query(sort: \Idea.deletedAt, order: .reverse)
    private var allIdeas: [Idea]

    @Query(sort: \Question.deletedAt, order: .reverse)
    private var allQuestions: [Question]

    // Filter to only deleted items
    private var deletedReflections: [Reflection] {
        allReflections.filter { $0.deletedAt != nil }
    }

    private var deletedStories: [Story] {
        allStories.filter { $0.deletedAt != nil }
    }

    private var deletedIdeas: [Idea] {
        allIdeas.filter { $0.deletedAt != nil }
    }

    private var deletedQuestions: [Question] {
        allQuestions.filter { $0.deletedAt != nil }
    }

    private var totalDeletedCount: Int {
        deletedReflections.count + deletedStories.count + deletedIdeas.count + deletedQuestions.count
    }

    private var isEmpty: Bool {
        totalDeletedCount == 0
    }

    @State private var showDeleteAllConfirmation = false

    var body: some View {
        Group {
            if isEmpty {
                emptyState
            } else {
                List {
                    // Info banner
                    Section {
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(Color.thresh.textSecondary)
                            Text("Items are automatically deleted after 30 days")
                                .font(.subheadline)
                                .foregroundStyle(Color.thresh.textSecondary)
                        }
                        .listRowBackground(Color.thresh.surface)
                    }

                    // Reflections
                    if !deletedReflections.isEmpty {
                        Section("Reflections") {
                            ForEach(deletedReflections) { reflection in
                                DeletedItemRow(
                                    icon: "doc.text",
                                    iconColor: Color.thresh.capture,
                                    title: String(reflection.captureContent.prefix(50)) + (reflection.captureContent.count > 50 ? "..." : ""),
                                    deletedAt: reflection.deletedAt,
                                    onRestore: { restoreReflection(reflection) },
                                    onDelete: { permanentlyDeleteReflection(reflection) }
                                )
                            }
                        }
                    }

                    // Stories
                    if !deletedStories.isEmpty {
                        Section("Stories") {
                            ForEach(deletedStories) { story in
                                DeletedItemRow(
                                    icon: "book.fill",
                                    iconColor: Color.thresh.story,
                                    title: story.title,
                                    deletedAt: story.deletedAt,
                                    onRestore: { restoreStory(story) },
                                    onDelete: { permanentlyDeleteStory(story) }
                                )
                            }
                        }
                    }

                    // Ideas
                    if !deletedIdeas.isEmpty {
                        Section("Ideas") {
                            ForEach(deletedIdeas) { idea in
                                DeletedItemRow(
                                    icon: "lightbulb.fill",
                                    iconColor: Color.thresh.idea,
                                    title: idea.title,
                                    deletedAt: idea.deletedAt,
                                    onRestore: { restoreIdea(idea) },
                                    onDelete: { permanentlyDeleteIdea(idea) }
                                )
                            }
                        }
                    }

                    // Questions
                    if !deletedQuestions.isEmpty {
                        Section("Questions") {
                            ForEach(deletedQuestions) { question in
                                DeletedItemRow(
                                    icon: "questionmark.circle.fill",
                                    iconColor: Color.thresh.question,
                                    title: question.text,
                                    deletedAt: question.deletedAt,
                                    onRestore: { restoreQuestion(question) },
                                    onDelete: { permanentlyDeleteQuestion(question) }
                                )
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Recently Deleted")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.thresh.background)
        .toolbar {
            if !isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteAllConfirmation = true
                    } label: {
                        Text("Delete All")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .alert("Delete All Items?", isPresented: $showDeleteAllConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive, action: deleteAllPermanently)
        } message: {
            Text("This will permanently delete \(totalDeletedCount) items. This cannot be undone.")
        }
        .onAppear {
            purgeExpiredItems()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "trash")
                .font(.system(size: 48))
                .foregroundStyle(Color.thresh.textTertiary)

            Text("No Deleted Items")
                .font(.headline)

            Text("Items you delete will appear here for 30 days before being permanently removed")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Restore Actions

    private func restoreReflection(_ reflection: Reflection) {
        reflection.deletedAt = nil
        reflection.updatedAt = Date()
        saveContext()
    }

    private func restoreStory(_ story: Story) {
        story.deletedAt = nil
        story.updatedAt = Date()
        saveContext()
    }

    private func restoreIdea(_ idea: Idea) {
        idea.deletedAt = nil
        idea.updatedAt = Date()
        saveContext()
    }

    private func restoreQuestion(_ question: Question) {
        question.deletedAt = nil
        question.updatedAt = Date()
        saveContext()
    }

    // MARK: - Permanent Delete Actions

    private func permanentlyDeleteReflection(_ reflection: Reflection) {
        modelContext.delete(reflection)
        saveContext()
    }

    private func permanentlyDeleteStory(_ story: Story) {
        modelContext.delete(story)
        saveContext()
    }

    private func permanentlyDeleteIdea(_ idea: Idea) {
        modelContext.delete(idea)
        saveContext()
    }

    private func permanentlyDeleteQuestion(_ question: Question) {
        modelContext.delete(question)
        saveContext()
    }

    private func deleteAllPermanently() {
        for reflection in deletedReflections {
            modelContext.delete(reflection)
        }
        for story in deletedStories {
            modelContext.delete(story)
        }
        for idea in deletedIdeas {
            modelContext.delete(idea)
        }
        for question in deletedQuestions {
            modelContext.delete(question)
        }
        saveContext()
    }

    // MARK: - Auto-purge expired items (30 days)

    private func purgeExpiredItems() {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()

        for reflection in deletedReflections {
            if let deletedAt = reflection.deletedAt, deletedAt < thirtyDaysAgo {
                modelContext.delete(reflection)
            }
        }
        for story in deletedStories {
            if let deletedAt = story.deletedAt, deletedAt < thirtyDaysAgo {
                modelContext.delete(story)
            }
        }
        for idea in deletedIdeas {
            if let deletedAt = idea.deletedAt, deletedAt < thirtyDaysAgo {
                modelContext.delete(idea)
            }
        }
        for question in deletedQuestions {
            if let deletedAt = question.deletedAt, deletedAt < thirtyDaysAgo {
                modelContext.delete(question)
            }
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            // Handle save error silently
        }
    }
}

// MARK: - Deleted Item Row

struct DeletedItemRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let deletedAt: Date?
    let onRestore: () -> Void
    let onDelete: () -> Void

    @State private var showDeleteConfirmation = false

    private var daysRemaining: Int {
        guard let deletedAt = deletedAt else { return 30 }
        let expirationDate = Calendar.current.date(byAdding: .day, value: 30, to: deletedAt) ?? Date()
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
        return max(0, days)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor.opacity(0.6))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(Color.thresh.textPrimary)
                    .lineLimit(1)

                Text("\(daysRemaining) days remaining")
                    .font(.caption)
                    .foregroundStyle(daysRemaining <= 7 ? .red : Color.thresh.textTertiary)
            }

            Spacer()

            HStack(spacing: 16) {
                Button(action: onRestore) {
                    Text("Restore")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.thresh.capture)
                }

                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Delete Permanently?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive, action: onDelete)
        } message: {
            Text("This cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        RecentlyDeletedScreen()
            .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
    }
}
