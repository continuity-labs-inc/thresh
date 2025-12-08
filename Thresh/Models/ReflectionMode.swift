import Foundation

/// The two primary modes of user interaction
enum ReflectionMode: String, Codable, CaseIterable {
    case capture
    case synthesis
    
    var displayName: String {
        switch self {
        case .capture: return "Capture"
        case .synthesis: return "Synthesis"
        }
    }
}
