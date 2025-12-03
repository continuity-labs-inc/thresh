//
//  DesignNote.swift
//  VicariousMe
//
//  Design Notes are brief, contextual explanations of WHY features work the way they do.
//  They appear at key moments, are dismissable, and collected in Settings.
//

import Foundation

// MARK: - DesignNote Model

/// A design note that explains the philosophy behind a feature
struct DesignNote: Identifiable, Hashable {
    let id: String
    let title: String
    let brief: String      // 2-4 sentences, always visible
    let expanded: String   // Full explanation
    let category: NoteCategory
    let trigger: NoteTrigger

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DesignNote, rhs: DesignNote) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - NoteCategory

/// Categories for organizing design notes
enum NoteCategory: String, CaseIterable, Identifiable {
    case foundation
    case dailyPractice
    case synthesis
    case patterns
    case perspective
    case practice

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .foundation: return "Foundation"
        case .dailyPractice: return "Daily Practice"
        case .synthesis: return "Synthesis"
        case .patterns: return "Patterns"
        case .perspective: return "Perspective"
        case .practice: return "Practice"
        }
    }

    var description: String {
        switch self {
        case .foundation:
            return "Core philosophy and principles"
        case .dailyPractice:
            return "The daily reflection workflow"
        case .synthesis:
            return "How meaning emerges over time"
        case .patterns:
            return "Recognizing themes and connections"
        case .perspective:
            return "Temporal views and time-based insights"
        case .practice:
            return "Building the reflection habit"
        }
    }
}

// MARK: - NoteTrigger

/// Triggers that determine when a design note should be shown
enum NoteTrigger: String, CaseIterable, Identifiable {
    case onboarding
    case firstDailyEntry
    case firstPureCapture
    case firstSynthesisOffer
    case firstWeeklyReflection
    case firstTimeSinceIndicator
    case firstQuestionExtraction
    case firstConnectionSurface
    case returnAfterGap
    case interpretationDriftDetected
    case interpretationDriftDetected
    case captureQualityFeedback
    case modeSwitch
    case themeEmergence
    case weeklyReviewAvailable

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .onboarding: return "Onboarding"
        case .firstDailyEntry: return "First Daily Entry"
        case .firstPureCapture: return "First Pure Capture"
        case .firstSynthesisOffer: return "First Synthesis Offer"
        case .firstWeeklyReflection: return "First Weekly Reflection"
        case .firstTimeSinceIndicator: return "First Time-Since Indicator"
        case .firstQuestionExtraction: return "First Question Extraction"
        case .firstConnectionSurface: return "First Connection Surface"
        case .returnAfterGap: return "Return After Gap"
        case .interpretationDriftDetected: return "Interpretation Drift Detected"
        case .captureQualityFeedback: return "Capture Quality Feedback"
        case .modeSwitch: return "Mode Switch"
        case .themeEmergence: return "Theme Emergence"
        case .weeklyReviewAvailable: return "Weekly Review Available"
        }
    }
}
