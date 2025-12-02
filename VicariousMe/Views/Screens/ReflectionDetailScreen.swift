import SwiftUI
import SwiftData

struct ReflectionDetailScreen: View {
    @Bindable var reflection: Reflection
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with type and tier
                HStack {
                    EntryTypeBadge(type: reflection.entryType)
                    Spacer()
                    TierBadge(tier: reflection.tier)
                }

                // Capture content
                VStack(alignment: .leading, spacing: 8) {
                    Label("Capture", systemImage: "camera.fill")
                        .font(.caption)
                        .foregroundStyle(Color.vm.capture)

                    Text(reflection.captureContent)
                        .font(.body)
                }

                // Reflection content (if present)
                if let reflectionContent = reflection.reflectionContent, !reflectionContent.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Reflection", systemImage: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(.primary)

                        Text(reflectionContent)
                            .font(.body)
                    }
                }

                // Synthesis content (if present)
                if let synthesisContent = reflection.synthesisContent, !synthesisContent.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Synthesis", systemImage: "sparkles")
                            .font(.caption)
                            .foregroundStyle(Color.vm.synthesis)

                        Text(synthesisContent)
                            .font(.body)
                    }
                }

                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Created \(reflection.createdAt.relativeFormattedFull)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if reflection.updatedAt != reflection.createdAt {
                        Text("Updated \(reflection.updatedAt.relativeFormattedFull)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { toggleArchive() }) {
                        Label(
                            reflection.isArchived ? "Unarchive" : "Archive",
                            systemImage: reflection.isArchived ? "arrow.uturn.backward" : "archivebox"
                        )
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }

    private func toggleArchive() {
        reflection.isArchived.toggle()
        reflection.updatedAt = Date()
    }
}

// MARK: - Tier Badge
struct TierBadge: View {
    let tier: ReflectionTier

    var body: some View {
        Text(tier.rawValue.uppercased())
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch tier {
        case .core: return Color.vm.tierCore
        case .active: return Color.vm.tierActive
        case .archive: return Color.vm.tierArchive
        }
    }
}

#Preview {
    NavigationStack {
        ReflectionDetailScreen(
            reflection: Reflection(
                captureContent: "Today I noticed how the morning light changes everything.",
                reflectionContent: "This makes me think about how small details often go unnoticed.",
                synthesisContent: "Pattern: Finding beauty in everyday moments connects to my core value of mindfulness.",
                entryType: .synthesis,
                tier: .core
            )
        )
    }
    .modelContainer(for: Reflection.self, inMemory: true)
}
