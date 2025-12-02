import Foundation
import SwiftUI

/// The main application state, shared across the app using the @Observable macro.
/// This provides reactive state management for core app-wide settings.
@Observable
final class AppState {
    /// Whether the user has completed the initial onboarding flow
    var hasCompletedOnboarding: Bool = false

    /// The current reflection mode (capture or synthesis)
    var currentMode: ReflectionMode = .capture

    /// The user's current development stage in their reflection practice
    var userDevelopmentStage: DevelopmentStage = .emerging

    init(
        hasCompletedOnboarding: Bool = false,
        currentMode: ReflectionMode = .capture,
        userDevelopmentStage: DevelopmentStage = .emerging
    ) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.currentMode = currentMode
        self.userDevelopmentStage = userDevelopmentStage
    }
}

/// The two primary modes of interaction in Vicarious Me
enum ReflectionMode: String, Codable, CaseIterable, Identifiable {
    /// Capture mode: for recording thoughts, stories, ideas, and questions
    case capture

    /// Synthesis mode: for reviewing, connecting, and deriving insights
    case synthesis

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .capture: return "Capture"
        case .synthesis: return "Synthesis"
        }
    }

    var systemImage: String {
        switch self {
        case .capture: return "pencil.line"
        case .synthesis: return "sparkles"
        }
    }
}

/// The user's progression stage in developing their reflection practice
enum DevelopmentStage: String, Codable, CaseIterable, Identifiable {
    /// New to reflection, needs more guidance and scaffolding
    case emerging

    /// Building reflection habits, moderate guidance
    case developing

    /// Regular reflector, lighter touch guidance
    case established

    /// Expert reflector, minimal intervention
    case fluent

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .emerging: return "Emerging"
        case .developing: return "Developing"
        case .established: return "Established"
        case .fluent: return "Fluent"
        }
    }

    var description: String {
        switch self {
        case .emerging:
            return "You're just beginning your reflection journey. I'll provide more guidance and prompts to help you get started."
        case .developing:
            return "You're building your reflection practice. I'll offer moderate support while encouraging independence."
        case .established:
            return "You have a regular reflection habit. I'll take a lighter touch, stepping in when helpful."
        case .fluent:
            return "You're an experienced reflector. I'll mostly stay out of your way, offering insights only when valuable."
        }
    }
}
