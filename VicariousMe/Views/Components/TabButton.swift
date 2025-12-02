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
                    .fontWeight(isSelected ? .semibold : .regular)

                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            isSelected
                                ? Color.vm.capture.opacity(0.2)
                                : Color.vm.surfaceSecondary
                        )
                        .clipShape(Capsule())
                }
            }
            .font(.subheadline)
            .foregroundStyle(isSelected ? Color.vm.capture : .secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected
                    ? Color.vm.capture.opacity(0.1)
                    : Color.vm.surface
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.vm.capture : Color.clear,
                        lineWidth: 1.5
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
}
