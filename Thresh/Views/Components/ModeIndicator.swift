import SwiftUI

/// Displays the current reflection mode with appropriate visual styling.
/// Shows either Capture (camera) or Synthesis (crystal ball) mode.
struct ModeIndicator: View {
    let mode: ReflectionMode

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: mode == .capture ? "camera.fill" : "sparkles")
                .font(.subheadline)

            Text(mode == .capture ? "CAPTURE MODE" : "SYNTHESIS MODE")
                .font(.caption)
                .fontWeight(.semibold)
                .tracking(1)
        }
        .foregroundStyle(mode == .capture ? Color.thresh.capture : Color.thresh.synthesis)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill((mode == .capture ? Color.thresh.capture : Color.thresh.synthesis).opacity(0.15))
        )
    }
}

#Preview("Capture Mode") {
    ModeIndicator(mode: .capture)
        .padding()
}

#Preview("Synthesis Mode") {
    ModeIndicator(mode: .synthesis)
        .padding()
}
