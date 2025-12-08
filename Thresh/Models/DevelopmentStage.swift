import Foundation

/// Tracks user's progression in reflective writing capability
/// Based on the Enhancement Specification's progressive scaffolding system
enum DevelopmentStage: String, Codable, CaseIterable, Identifiable {
    case emerging
    case developing
    case established
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
            return "New to reflective writing; primarily descriptive"
        case .developing:
            return "Beginning to add meaning; occasional perspective-taking"
        case .established:
            return "Regular analytical elements; asks interpretive questions"
        case .fluent:
            return "Consistently knowledge-transforming; generates insight"
        }
    }
}
