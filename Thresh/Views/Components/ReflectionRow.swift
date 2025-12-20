import SwiftUI

struct ReflectionRow: View {
    @Bindable var reflection: Reflection
    @State private var showMarinatingTooltip = false
    @AppStorage("notifications_marinating") private var marinatingRemindersEnabled = true

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
                // Show tooltip when user first holds something
                if !wasMarinating && reflection.marinating {
                    showMarinatingTooltip = true
                    // Schedule marinating reminder if enabled
                    if marinatingRemindersEnabled {
                        NotificationService.shared.scheduleMarinatingReminder(for: reflection.id, afterDays: 14)
                    }
                } else if wasMarinating && !reflection.marinating {
                    // Cancel reminder when releasing
                    NotificationService.shared.cancelMarinatingReminder(for: reflection.id)
                }
            } label: {
                Label(
                    reflection.marinating ? "Release" : "Hold This",
                    systemImage: reflection.marinating ? "hand.raised.slash.fill" : "hand.raised.fill"
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
            title: "Holding",
            message: "You're marking this as worth sitting with. Not a to-do—just a signal that something here matters, even if you don't know why yet.\n\nFind it later in Patterns → Holding.",
            featureKey: "hasSeenMarinatingIntro",
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
