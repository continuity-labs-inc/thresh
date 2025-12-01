import SwiftUI

extension Color {
    /// Vicarious Me color palette
    static let vm = VMColors()
}

struct VMColors {
    /// Capture mode color - represents observation and recording
    let capture = Color(red: 0.0, green: 0.48, blue: 1.0)  // Blue

    /// Synthesis mode color - represents interpretation and meaning
    let synthesis = Color(red: 0.6, green: 0.4, blue: 0.8)  // Purple
}
