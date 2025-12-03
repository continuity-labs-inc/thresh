import SwiftUI

struct SaveButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    var theme: ButtonTheme = .blue
    
    enum ButtonTheme {
        case blue, green, pink, orange
        
        var enabledBackground: Color {
            switch self {
            case .blue: return Color.vm.capture
            case .green: return Color.vm.story
            case .pink: return Color.vm.question
            case .orange: return Color.vm.idea
            }
        }
        
        var disabledBackground: Color {
            Color.vm.surfaceSecondary
        }
        
        var disabledText: Color {
            Color.vm.textTertiary
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isEnabled ? .white : theme.disabledText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(isEnabled ? theme.enabledBackground : theme.disabledBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .strokeBorder(
                            isEnabled ? Color.clear : Color.vm.textTertiary.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SaveButton(
            title: "Save Capture",
            isEnabled: true,
            action: {},
            theme: .blue
        )
        
        SaveButton(
            title: "Save Capture",
            isEnabled: false,
            action: {},
            theme: .blue
        )
        
        SaveButton(
            title: "Save Story",
            isEnabled: true,
            action: {},
            theme: .green
        )
        
        SaveButton(
            title: "Save Question",
            isEnabled: true,
            action: {},
            theme: .pink
        )
        
        SaveButton(
            title: "Save Idea",
            isEnabled: true,
            action: {},
            theme: .orange
        )
    }
    .padding()
}
