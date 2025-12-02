import SwiftUI

/// Overlay view displaying design notes about app philosophy
struct DesignNoteView: View {
    let note: DesignNote
    let onDismiss: () -> Void

    @State private var isVisible = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissWithAnimation()
                }

            // Note card
            VStack(spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(Color.vm.warning)
                    Text("A Note on Design")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.vm.textSecondary)
                    Spacer()
                }

                // Title
                Text(note.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.vm.textPrimary)

                // Content
                Text(note.content)
                    .font(.body)
                    .foregroundStyle(Color.vm.textPrimary)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Dismiss button
                Button(action: dismissWithAnimation) {
                    Text("Got it")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.vm.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.vm.surfaceElevated)
            )
            .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
            .padding(.horizontal, 24)
            .scaleEffect(isVisible ? 1 : 0.9)
            .opacity(isVisible ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
    }

    private func dismissWithAnimation() {
        withAnimation(.easeOut(duration: 0.2)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.vm.surface.ignoresSafeArea()

        DesignNoteView(
            note: DesignNote(
                id: "preview",
                title: "The Power of Pure Capture",
                content: """
                You just saved a pure capture—an observation without interpretation.

                This is valuable. Sometimes the most important thing is to record what happened \
                without rushing to make sense of it.

                You can always return to add meaning later, or let patterns reveal themselves \
                over time through your weekly reviews.
                """,
                trigger: .firstPureCapture
            ),
            onDismiss: { }
        )
    }
}
