import SwiftUI

struct ReflectionRow: View {
    @Bindable var reflection: Reflection
    @State private var showMarinatingTooltip = false

    var body: some View {
        NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
            VStack(alignment: .leading, spacing: 8) {
                // Reflection number + entry type badge + tier + marinating + time
                HStack {
                    if let number = reflection.reflectionNumber, number > 0 {
                        Text("#\(number)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.thresh.capture)
                    }

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
                let wasMarinating = reflection.marinating
                reflection.marinating.toggle()
                // Show tooltip when user first marinates something
                if !wasMarinating && reflection.marinating {
                    showMarinatingTooltip = true
                }
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
        .featureTooltip(
            title: "Marinating",
            message: "You've flagged this to sit with. It's not a to-do — it means 'this feels important but I don't know why yet.' Find marinating items in Patterns (sparkles button).",
            featureKey: "marinating",
            isPresented: $showMarinatingTooltip
        )
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
