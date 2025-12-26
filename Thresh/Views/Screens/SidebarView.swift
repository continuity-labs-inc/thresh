import SwiftUI
import SwiftData

/// Sidebar navigation for iPad
struct SidebarView: View {
    @Environment(\.typography) private var typography
    @Binding var selectedSection: SidebarSection?
    @Query(sort: \Reflection.createdAt, order: .reverse) private var allReflections: [Reflection]
    @Query(sort: \Story.createdAt, order: .reverse) private var allStories: [Story]
    @Query(sort: \Idea.createdAt, order: .reverse) private var allIdeas: [Idea]
    @Query(sort: \Question.createdAt, order: .reverse) private var allQuestions: [Question]

    private var reflectionCount: Int {
        allReflections.filter { $0.deletedAt == nil && !$0.isArchived }.count
    }

    private var storyCount: Int {
        allStories.filter { $0.deletedAt == nil }.count
    }

    private var ideaCount: Int {
        allIdeas.filter { $0.deletedAt == nil }.count
    }

    private var questionCount: Int {
        allQuestions.filter { $0.deletedAt == nil }.count
    }

    private var marinatingCount: Int {
        allReflections.filter { $0.marinating && $0.deletedAt == nil && !$0.isArchived }.count
    }

    var body: some View {
        List(selection: $selectedSection) {
            // Capture Section
            Section {
                ForEach(SidebarSection.captureItems) { section in
                    sidebarRow(for: section)
                }
            } header: {
                Label("CAPTURE", systemImage: "camera")
                    .font(typography.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.capture)
            }

            // Library Section
            Section {
                ForEach(SidebarSection.libraryItems) { section in
                    sidebarRow(for: section, count: countFor(section))
                }
            } header: {
                Label("LIBRARY", systemImage: "books.vertical")
                    .font(typography.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.textSecondary)
            }

            // Synthesize Section
            Section {
                ForEach(SidebarSection.synthesizeItems) { section in
                    sidebarRow(for: section)
                }
            } header: {
                Label("SYNTHESIZE", systemImage: "wand.and.stars")
                    .font(typography.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.synthesis)
            }

            // Explore Section
            Section {
                ForEach(SidebarSection.exploreItems) { section in
                    HStack {
                        sidebarRow(for: section)
                        if marinatingCount > 0 {
                            Spacer()
                            Text("\(marinatingCount)")
                                .font(typography.subheadline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.orange)
                                .clipShape(Capsule())
                        }
                    }
                }
            } header: {
                Label("EXPLORE", systemImage: "sparkles")
                    .font(typography.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.synthesis)
            }

            // Manage Section
            Section {
                ForEach(SidebarSection.manageItems) { section in
                    sidebarRow(for: section)
                }
            } header: {
                Label("MANAGE", systemImage: "folder")
                    .font(typography.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.textSecondary)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Thresh")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    selectedSection = .newReflection
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(typography.title)
                        .foregroundStyle(Color.thresh.capture)
                }
            }
        }
    }

    // MARK: - Sidebar Row

    private func sidebarRow(for section: SidebarSection, count: Int? = nil) -> some View {
        Label {
            HStack {
                Text(section.title)
                    .font(typography.headline)
                if let count = count, count > 0 {
                    Spacer()
                    Text("\(count)")
                        .font(typography.subheadline)
                        .foregroundStyle(Color.thresh.textSecondary)
                }
            }
        } icon: {
            Image(systemName: section.icon)
                .font(.system(size: typography.sidebarIconSize))
                .foregroundStyle(section.color)
        }
        .tag(section)
        .padding(.vertical, typography.rowVerticalPadding)
    }

    private func countFor(_ section: SidebarSection) -> Int? {
        switch section {
        case .reflections: return reflectionCount
        case .stories: return storyCount
        case .ideas: return ideaCount
        case .questions: return questionCount
        default: return nil
        }
    }
}

#Preview {
    NavigationSplitView {
        SidebarView(selectedSection: .constant(.reflections))
            .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
    } detail: {
        Text("Detail View")
    }
}
