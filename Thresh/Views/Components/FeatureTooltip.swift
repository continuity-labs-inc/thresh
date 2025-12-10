import SwiftUI

/// A dismissible tooltip for feature discovery.
/// Appears every time until the user explicitly dismisses it with "Don't show again."
struct FeatureTooltip: View {
    let title: String
    let message: String
    let featureKey: String
    let onDismiss: () -> Void

    @AppStorage private var isDismissedPermanently: Bool

    init(title: String, message: String, featureKey: String, onDismiss: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.featureKey = featureKey
        self.onDismiss = onDismiss
        self._isDismissedPermanently = AppStorage(wrappedValue: false, "tooltip_dismissed_\(featureKey)")
    }

    var body: some View {
        if !isDismissedPermanently {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.thresh.textPrimary)

                Text(message)
                    .font(.caption)
                    .foregroundStyle(Color.thresh.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 12) {
                    Button("Got it") {
                        onDismiss()
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.thresh.textSecondary)

                    Spacer()

                    Button("Don't show again") {
                        isDismissedPermanently = true
                        onDismiss()
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.thresh.synthesis)
                }
            }
            .padding(16)
            .background(Color.thresh.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

/// A ViewModifier for easily attaching feature tooltips to any view.
struct FeatureTooltipModifier: ViewModifier {
    let title: String
    let message: String
    let featureKey: String
    @Binding var isPresented: Bool

    @AppStorage private var isDismissedPermanently: Bool

    init(title: String, message: String, featureKey: String, isPresented: Binding<Bool>) {
        self.title = title
        self.message = message
        self.featureKey = featureKey
        self._isPresented = isPresented
        self._isDismissedPermanently = AppStorage(wrappedValue: false, "tooltip_dismissed_\(featureKey)")
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented && !isDismissedPermanently {
                    FeatureTooltip(
                        title: title,
                        message: message,
                        featureKey: featureKey,
                        onDismiss: {
                            isPresented = false
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}

extension View {
    /// Attaches a feature discovery tooltip to this view.
    /// - Parameters:
    ///   - title: The tooltip title (displayed in bold)
    ///   - message: The tooltip message explaining the feature
    ///   - featureKey: A unique key for this feature (used to track permanent dismissal)
    ///   - isPresented: Binding to control tooltip visibility
    /// - Returns: A view with the tooltip overlay attached
    func featureTooltip(
        title: String,
        message: String,
        featureKey: String,
        isPresented: Binding<Bool>
    ) -> some View {
        modifier(FeatureTooltipModifier(
            title: title,
            message: message,
            featureKey: featureKey,
            isPresented: isPresented
        ))
    }
}

#Preview("Tooltip") {
    VStack {
        Spacer()
        Text("Content here")
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.thresh.background)
    .overlay(alignment: .bottom) {
        FeatureTooltip(
            title: "Long-press to hold",
            message: "Hold a reflection to keep it visible in the Patterns screen while you sit with it.",
            featureKey: "preview_test",
            onDismiss: {}
        )
        .padding()
    }
}
