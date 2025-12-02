//
//  DesignNoteView.swift
//  VicariousMe
//
//  A dismissable card that displays a design note.
//  Used to explain WHY features work the way they do.
//

import SwiftUI

// MARK: - DesignNoteView

/// A card view for displaying a design note with expand/collapse functionality
struct DesignNoteView: View {
    let note: DesignNote
    let onDismiss: () -> Void

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            header

            // Title
            Text(note.title)
                .font(.headline)
                .foregroundStyle(Color.vm.text)

            // Brief (always visible)
            Text(note.brief)
                .font(.subheadline)
                .foregroundStyle(Color.vm.text)
                .fixedSize(horizontal: false, vertical: true)

            // Expanded content
            if isExpanded {
                expandedContent
            }

            // Toggle button
            toggleButton
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.vm.surface)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        )
        .padding(.horizontal)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Image(systemName: "book.closed.fill")
                .foregroundStyle(Color.vm.noteAccent)

            Text("Design Note")
                .font(.caption)
                .fontWeight(.semibold)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(Color.vm.textSecondary)
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()

            Text(note.expanded)
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    // MARK: - Toggle Button

    private var toggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Text(isExpanded ? "Show less" : "Read more")
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(Color.vm.accent)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Compact Design Note View

/// A more compact version for inline display
struct CompactDesignNoteView: View {
    let note: DesignNote
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: "book.closed.fill")
                    .font(.body)
                    .foregroundStyle(Color.vm.noteAccent)

                VStack(alignment: .leading, spacing: 2) {
                    Text(note.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.vm.text)

                    Text(note.brief)
                        .font(.caption)
                        .foregroundStyle(Color.vm.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.vm.textTertiary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.vm.surfaceSecondary)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Design Note Banner

/// A banner-style view for showing design notes at the top of screens
struct DesignNoteBanner: View {
    let note: DesignNote
    let onDismiss: () -> Void
    let onReadMore: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(Color.vm.noteAccent)

                Text(note.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .buttonStyle(.plain)
            }
            .foregroundStyle(Color.vm.text)

            Text(note.brief)
                .font(.caption)
                .foregroundStyle(Color.vm.textSecondary)
                .lineLimit(3)

            Button(action: onReadMore) {
                Text("Learn more")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.vm.accent)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.vm.surfaceSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.vm.noteAccent.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview("Design Note View") {
    ScrollView {
        VStack(spacing: 20) {
            DesignNoteView(
                note: DesignNotesService.allNotes.first!,
                onDismiss: {}
            )

            CompactDesignNoteView(
                note: DesignNotesService.allNotes[1],
                onTap: {}
            )

            DesignNoteBanner(
                note: DesignNotesService.allNotes[2],
                onDismiss: {},
                onReadMore: {}
            )
        }
        .padding(.vertical)
    }
    .background(Color.vm.surfaceSecondary)
}
