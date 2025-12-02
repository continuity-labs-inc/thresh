import SwiftUI

// MARK: - Mode Indicator

/// Visual indicator showing current capture/synthesis mode
struct ModeIndicator: View {
    let mode: ReflectionMode

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: mode == .capture ? "camera.fill" : "sparkles")
            Text(mode == .capture ? "CAPTURE MODE" : "SYNTHESIS MODE")
                .fontWeight(.semibold)
        }
        .font(.caption)
        .foregroundStyle(mode == .capture ? Color.vm.capture : Color.vm.synthesis)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(mode == .capture
                    ? Color.vm.capture.opacity(0.15)
                    : Color.vm.synthesis.opacity(0.15))
        )
    }
}

// MARK: - Focus Type Button

/// Button for selecting a focus type lens
struct FocusTypeButton: View {
    let focus: FocusType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: iconName)
                    .font(.caption)
                Text(focus.rawValue.capitalized)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.vm.capture : Color.vm.surface)
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.clear : Color.vm.textMuted.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var iconName: String {
        switch focus {
        case .body: return "figure.stand"
        case .emotion: return "heart.fill"
        case .thought: return "brain.head.profile"
        case .relationship: return "person.2.fill"
        case .environment: return "leaf.fill"
        case .spirit: return "sparkles"
        }
    }
}

// MARK: - Prompt View

/// Displays a reflective prompt with styling based on mode
struct PromptView: View {
    let prompt: Prompt
    let mode: ReflectionMode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(prompt.content)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(Color.vm.textPrimary)

            if let subtext = prompt.subtext {
                Text(subtext)
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(mode == .capture
                    ? Color.vm.capture.opacity(0.08)
                    : Color.vm.synthesis.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(mode == .capture
                    ? Color.vm.capture.opacity(0.2)
                    : Color.vm.synthesis.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Capture Text Editor

/// Styled text editor for capture/synthesis input
struct ReflectionTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let hint: String?
    let mode: ReflectionMode
    let minHeight: CGFloat

    init(
        text: Binding<String>,
        placeholder: String,
        hint: String? = nil,
        mode: ReflectionMode,
        minHeight: CGFloat = 200
    ) {
        self._text = text
        self.placeholder = placeholder
        self.hint = hint
        self.mode = mode
        self.minHeight = minHeight
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(placeholder)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.vm.textPrimary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight)
                    .padding(8)
                    .background(Color.vm.surface)

                if text.isEmpty {
                    Text("Start typing...")
                        .foregroundStyle(Color.vm.textMuted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        mode == .capture
                            ? Color.vm.capture.opacity(0.3)
                            : Color.vm.synthesis.opacity(0.3),
                        lineWidth: 1
                    )
            )

            if let hint = hint {
                Text(hint)
                    .font(.caption)
                    .foregroundStyle(Color.vm.textSecondary)
            }
        }
    }
}

// MARK: - Primary Action Button

/// Primary action button with mode-based styling
struct PrimaryActionButton: View {
    let title: String
    let icon: String?
    let mode: ReflectionMode
    let isEnabled: Bool
    let action: () -> Void

    init(
        title: String,
        icon: String? = nil,
        mode: ReflectionMode,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.mode = mode
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? modeColor : Color.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
    }

    private var modeColor: Color {
        mode == .capture ? Color.vm.capture : Color.vm.synthesis
    }
}

// MARK: - Secondary Action Button

/// Secondary/outlined action button
struct SecondaryActionButton: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let mode: ReflectionMode
    let action: () -> Void

    init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        mode: ReflectionMode,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.mode = mode
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                    if subtitle == nil {
                        Image(systemName: "arrow.right")
                    }
                }
                .font(.headline)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(modeColor.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(modeColor.opacity(0.15))
            .foregroundStyle(modeColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var modeColor: Color {
        mode == .capture ? Color.vm.capture : Color.vm.synthesis
    }
}

// MARK: - Capture Preview

/// Shows a preview of captured content
struct CapturePreview: View {
    let content: String
    let isCompact: Bool

    init(content: String, isCompact: Bool = false) {
        self.content = content
        self.isCompact = isCompact
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your capture:")
                .font(.caption)
                .foregroundStyle(Color.vm.textSecondary)

            Text(displayContent)
                .font(isCompact ? .caption : .subheadline)
                .padding(isCompact ? 8 : 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.vm.capture.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: isCompact ? 6 : 8))
        }
    }

    private var displayContent: String {
        if isCompact && content.count > 200 {
            return String(content.prefix(200)) + "..."
        }
        return content
    }
}

// MARK: - Previews

#Preview("Mode Indicator") {
    VStack(spacing: 20) {
        ModeIndicator(mode: .capture)
        ModeIndicator(mode: .synthesis)
    }
    .padding()
}

#Preview("Focus Type Buttons") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
        ForEach(FocusType.allCases, id: \.self) { focus in
            FocusTypeButton(focus: focus, isSelected: focus == .emotion) { }
        }
    }
    .padding()
}

#Preview("Prompt View") {
    VStack(spacing: 20) {
        PromptView(
            prompt: Prompt(
                id: "test",
                type: .capture,
                content: "What happened? Describe the scene.",
                subtext: "Focus on what you saw, heard, or experienced."
            ),
            mode: .capture
        )

        PromptView(
            prompt: Prompt(
                id: "test2",
                type: .synthesis,
                content: "What might this mean to you?",
                subtext: "If you want, explore what significance this holds."
            ),
            mode: .synthesis
        )
    }
    .padding()
}
