import SwiftUI

struct TabButton: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .fontWeight(isSelected ? .semibold : .medium)

                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(isSelected ? .white : Color.thresh.textSecondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            isSelected
                                ? Color.thresh.capture
                                : Color.thresh.surfaceSecondary
                        )
                        .clipShape(Capsule())
                }
            }
            .font(.subheadline)
            .foregroundStyle(isSelected ? Color.thresh.capture : Color.thresh.textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected
                    ? Color.thresh.capture.opacity(0.12)
                    : Color.thresh.surface
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.thresh.capture : Color.thresh.textTertiary.opacity(0.6),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        TabButton(title: "Reflections", count: 5, isSelected: true, action: {})
        TabButton(title: "Stories", count: 2, isSelected: false, action: {})
        TabButton(title: "Ideas", count: 0, isSelected: false, action: {})
    }
    .padding()
    .background(Color.thresh.background)
}
