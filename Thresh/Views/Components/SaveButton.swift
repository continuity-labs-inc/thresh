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
            case .blue: return Color.thresh.capture
            case .green: return Color.thresh.story
            case .pink: return Color.thresh.question
            case .orange: return Color.thresh.idea
            }
        }
        
        var disabledBackground: Color {
            Color.thresh.surfaceSecondary
        }
        
        var disabledText: Color {
            Color.thresh.textTertiary
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
                            isEnabled ? Color.clear : Color.thresh.textTertiary.opacity(0.3),
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
