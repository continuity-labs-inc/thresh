import SwiftUI

struct ReflectionRow: View {
    @Bindable var reflection: Reflection

    var body: some View {
        NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
            VStack(alignment: .leading, spacing: 8) {
                // Entry type badge + tier + marinating + time
                HStack {
                    EntryTypeBadge(type: reflection.entryType)
                    Text(reflection.tier.rawValue.uppercased())
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.textSecondary)

                    if reflection.marinating {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }

                    Spacer()
                    Text(reflection.createdAt.relativeFormatted)
                        .font(.caption)
                        .foregroundStyle(Color.thresh.textSecondary)
                }

                // Capture content preview
                Text(previewText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(Color.thresh.textPrimary)
            }
            .padding()
            .background(Color.thresh.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                reflection.marinating.toggle()
            } label: {
                Label(
                    reflection.marinating ? "Stop Marinating" : "Marinate This",
                    systemImage: reflection.marinating ? "flame.fill" : "flame"
                )
            }

            Divider()

            Button(role: .destructive) {
                reflection.deletedAt = Date()
                reflection.updatedAt = Date()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var previewText: String {
        let content = reflection.captureContent
        if content.count > 80 {
            return String(content.prefix(80)) + "..."
        }
        return content
    }
}

#Preview {
    NavigationStack {
        VStack {
            ReflectionRow(reflection: Reflection(
                captureContent: "Today I noticed how the morning light changes everything. The way it filters through the window creates patterns I never paid attention to before.",
                entryType: .pureCapture,
                tier: .active
            ))

            ReflectionRow(reflection: Reflection(
                captureContent: "Short capture",
                entryType: .synthesis,
                tier: .core
            ))
        }
        .padding()
    }
    .modelContainer(for: Reflection.self, inMemory: true)
}
