import SwiftUI

struct ReflectionRow: View {
    let reflection: Reflection

    var body: some View {
        NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
            VStack(alignment: .leading, spacing: 8) {
                // Entry type badge + tier + time
                HStack {
                    EntryTypeBadge(type: reflection.entryType)
                    Text(reflection.tier.rawValue.uppercased())
                        .font(.caption2)
                        .foregroundStyle(Color.thresh.textSecondary)
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
