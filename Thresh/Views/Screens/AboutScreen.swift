import SwiftUI

struct AboutScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    aboutSection
                    aiExtractionSection
                    archiveSection
                    dataSection
                    footerSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 32)
            }
            .background(Color.thresh.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                }
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.thresh.capture)

                Text("Thresh")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.textPrimary)
            }

            Text("Reflection as cognitive architecture.")
                .font(.subheadline)
                .foregroundStyle(Color.thresh.textSecondary)

            Rectangle()
                .fill(Color.thresh.capture)
                .frame(width: 40, height: 3)
                .clipShape(Capsule())
                .padding(.top, 4)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        AboutSectionView(
            icon: "book.pages",
            iconColor: Color.thresh.textPrimary,
            title: "About This App",
            content: "Thresh helps you capture daily moments and build narratives over time. The app is designed around two complementary modes: Capture Mode for recording what happened, and Synthesis Mode for stepping back to find patterns and meaning across your reflections."
        )
    }

    // MARK: - AI Extraction Section

    private var aiExtractionSection: some View {
        AboutSectionView(
            icon: "sparkles",
            iconColor: Color.thresh.synthesis,
            title: "How AI Extraction Works",
            content: "After you write a reflection, AI reads what you've written and identifies embedded stories, ideas, and questions. These are elements already present in your writing—the AI doesn't generate new content or interpret your experience for you. You choose what to keep and what to skip. Extracted items link back to their source reflection so you can always see where they came from."
        )
    }

    // MARK: - Archive Section

    private var archiveSection: some View {
        AboutSectionView(
            icon: "archivebox",
            iconColor: Color.thresh.textPrimary,
            title: "What Archiving Means",
            content: "Archiving a reflection removes it from your active working set—it won't appear in pattern detection, aggregation flows, or your home feed. But the reflection isn't deleted. You can always visit the Archive to browse your historical entries and unarchive anything you want to bring back into circulation. Think of it as curation, not completion."
        )
    }

    // MARK: - Data Section

    private var dataSection: some View {
        AboutSectionView(
            icon: "lock.shield",
            iconColor: Color.thresh.textPrimary,
            title: "Your Data",
            content: "Everything you write is stored locally on your device using SwiftData. Your reflections, stories, ideas, and questions never leave your phone unless you explicitly export them. There is no cloud sync, no account creation, and no data collection."
        )
    }

    // MARK: - Footer Section

    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("Thresh v0.2 Beta")
                .font(.caption)
                .foregroundStyle(Color.thresh.textSecondary)

            Text("Built with care for neurodiverse minds.")
                .font(.caption2)
                .foregroundStyle(Color.thresh.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }
}

// MARK: - About Section Component

private struct AboutSectionView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.thresh.textPrimary)
            }

            Text(content)
                .font(.body)
                .foregroundStyle(Color.thresh.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    AboutScreen()
}
