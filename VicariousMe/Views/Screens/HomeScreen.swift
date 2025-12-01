import SwiftUI
import SwiftData

/// Home Screen - Main entry point for the app
///
/// Provides quick access to:
/// - Quick Capture (prominent, ADHD-friendly)
/// - Recent reflections
/// - Full reflection flow
struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Reflection.createdAt, order: .reverse) private var reflections: [Reflection]

    @State private var showingQuickCapture = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Quick Capture Card - Prominent placement
                    quickCaptureCard

                    // Recent reflections
                    if !reflections.isEmpty {
                        recentReflectionsSection
                    } else {
                        emptyStateView
                    }
                }
                .padding()
            }
            .background(Color.vm.background)
            .navigationTitle("Vicarious Me")
            .sheet(isPresented: $showingQuickCapture) {
                NavigationStack {
                    QuickCaptureScreen()
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    showingQuickCapture = false
                                }
                            }
                        }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Quick Capture Card

    private var quickCaptureCard: some View {
        Button {
            showingQuickCapture = true
        } label: {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.vm.capture.opacity(0.2))
                        .frame(width: 56, height: 56)

                    Image(systemName: "bolt.fill")
                        .font(.title2)
                        .foregroundStyle(Color.vm.capture)
                }

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quick Capture")
                        .font(.headline)
                        .foregroundStyle(Color.vm.textPrimary)

                    Text("Capture now, process later")
                        .font(.subheadline)
                        .foregroundStyle(Color.vm.textSecondary)
                }

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.vm.textTertiary)
            }
            .padding()
            .background(Color.vm.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.vm.capture.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Recent Reflections

    private var recentReflectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent")
                .font(.headline)
                .foregroundStyle(Color.vm.textSecondary)

            LazyVStack(spacing: 12) {
                ForEach(reflections.prefix(5)) { reflection in
                    ReflectionRow(reflection: reflection)
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.bubble")
                .font(.system(size: 48))
                .foregroundStyle(Color.vm.textTertiary)

            Text("No reflections yet")
                .font(.headline)
                .foregroundStyle(Color.vm.textSecondary)

            Text("Tap Quick Capture to get started")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

// MARK: - Reflection Row

struct ReflectionRow: View {
    let reflection: Reflection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                // Entry type badge
                HStack(spacing: 4) {
                    Image(systemName: entryTypeIcon)
                        .font(.caption2)
                    Text(reflection.entryType.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundStyle(entryTypeColor)

                Spacer()

                // Timestamp
                Text(reflection.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(Color.vm.textTertiary)
            }

            // Content preview
            Text(reflection.captureContent)
                .font(.subheadline)
                .foregroundStyle(Color.vm.textPrimary)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.vm.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var entryTypeIcon: String {
        switch reflection.entryType {
        case .pureCapture: return "bolt.fill"
        case .guided: return "list.bullet"
        case .freeform: return "pencil"
        case .synthesized: return "sparkles"
        }
    }

    private var entryTypeColor: Color {
        switch reflection.entryType {
        case .pureCapture: return Color.vm.capture
        case .guided: return Color.vm.synthesis
        case .freeform: return Color.vm.textSecondary
        case .synthesized: return Color.vm.success
        }
    }
}

// MARK: - Preview

#Preview {
    HomeScreen()
        .modelContainer(for: Reflection.self, inMemory: true)
}
