//
//  DesignNoteStatus.swift
//  VicariousMe
//
//  SwiftData model for tracking which design notes have been seen by the user.
//

import Foundation
import SwiftData

/// Tracks the seen/dismissed status of a design note
@Model
final class DesignNoteStatus {
    /// The unique identifier of the design note
    @Attribute(.unique) var noteId: String

    /// Whether the user has seen/dismissed this note
    var seen: Bool

    /// When the note was first shown to the user
    var firstShownAt: Date?

    /// When the user dismissed the note
    var dismissedAt: Date?

    /// How many times the note has been shown
    var showCount: Int

    init(noteId: String, seen: Bool = false) {
        self.noteId = noteId
        self.seen = seen
        self.firstShownAt = nil
        self.dismissedAt = nil
        self.showCount = 0
    }

    /// Mark the note as seen/dismissed
    func markSeen() {
        if !seen {
            seen = true
            dismissedAt = Date()
        }
    }

    /// Record that the note was shown
    func recordShown() {
        if firstShownAt == nil {
            firstShownAt = Date()
        }
        showCount += 1
    }
}
