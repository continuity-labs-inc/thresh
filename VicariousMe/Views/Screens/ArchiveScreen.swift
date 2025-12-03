import SwiftUI
import SwiftData

struct ArchiveScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse)
    private var allReflections: [Reflection]

    private var archivedReflections: [Reflection] {
        allReflections.filter { $0.isArchived }
    }

    var body: some View {
        Group {
            if archivedReflections.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(archivedReflections) { reflection in
                        NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    EntryTypeBadge(type: reflection.entryType)
                                    Spacer()
                                    Text(reflection.createdAt.relativeFormatted)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Text(reflection.captureContent.prefix(100) + (reflection.captureContent.count > 100 ? "..." : ""))
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Archive")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.vm.background)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "archivebox")
                .font(.system(size: 48))
                .foregroundStyle(Color.vm.tierArchive)

            Text("Archive Empty")
                .font(.headline)

            Text("Reflections you archive will appear here for safekeeping")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ArchiveScreen()
            .modelContainer(for: Reflection.self, inMemory: true)
    }
}
