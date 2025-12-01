//
//  Color+VicariousMe.swift
//  VicariousMe
//
//  Design system colors for Vicarious Me.
//  Access via Color.vm namespace.
//

import SwiftUI

// MARK: - VicariousMe Color Namespace

extension Color {
    /// Vicarious Me design system colors
    static let vm = VMColors()
}

// MARK: - VMColors

struct VMColors {

    // MARK: - Surfaces

    /// Primary surface color for cards and elevated content
    var surface: Color {
        Color(.systemBackground)
    }

    /// Secondary surface with subtle distinction
    var surfaceSecondary: Color {
        Color(.secondarySystemBackground)
    }

    /// Tertiary surface for nested elements
    var surfaceTertiary: Color {
        Color(.tertiarySystemBackground)
    }

    // MARK: - Text

    /// Primary text color
    var text: Color {
        Color(.label)
    }

    /// Secondary text color for supporting information
    var textSecondary: Color {
        Color(.secondaryLabel)
    }

    /// Tertiary text color for less important elements
    var textTertiary: Color {
        Color(.tertiaryLabel)
    }

    // MARK: - Accent Colors

    /// Primary accent color
    var accent: Color {
        Color.accentColor
    }

    /// Capture mode indicator color
    var capture: Color {
        Color(.systemBlue)
    }

    /// Synthesis mode indicator color
    var synthesis: Color {
        Color(.systemPurple)
    }

    // MARK: - Semantic Colors

    /// Success state color
    var success: Color {
        Color(.systemGreen)
    }

    /// Warning state color
    var warning: Color {
        Color(.systemOrange)
    }

    /// Error state color
    var error: Color {
        Color(.systemRed)
    }

    // MARK: - Design Notes

    /// Background color for design note cards
    var noteBackground: Color {
        Color(.secondarySystemBackground)
    }

    /// Accent color for design note headers
    var noteAccent: Color {
        Color(.systemIndigo)
    }
}

// MARK: - Convenience Modifiers

extension View {
    /// Apply standard card styling
    func vmCard() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.vm.surface)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            )
    }

    /// Apply design note styling
    func vmDesignNoteCard() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.vm.noteBackground)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            )
    }
}
