import SwiftUI
import SwiftData

/// Quick Capture Mode - ADHD-friendly minimal friction entry
///
/// Design principles:
/// - One prompt: "What's on your mind? Just capture it."
/// - One text field
/// - One save button
/// - No focus type, no interpretation, no question extraction
/// - Entry saved as pure capture
///
/// Maximum speed, minimal decisions.
struct QuickCaptureScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var captureText = ""
    @FocusState private var isTextFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            // Mode indicator
            HStack {
                Image(systemName: "bolt.fill")
                Text("QUICK CAPTURE")
                    .fontWeight(.semibold)
            }
            .font(.caption)
            .foregroundStyle(Color.vm.capture)

            // Prompt
            Text("What's on your mind? Just capture it.")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)

            // Text input
            TextEditor(text: $captureText)
                .focused($isTextFocused)
                .frame(minHeight: 150)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(Color.vm.surface)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.vm.capture.opacity(0.6), lineWidth: 1)
                )

            Spacer()

            // Save button
            Button(action: saveAndDismiss) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Save")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(captureText.isEmpty ? Color.vm.textSecondary : Color.vm.capture)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(captureText.isEmpty)
        }
        .padding()
        .navigationTitle("Quick Capture")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isTextFocused = true
        }
    }

    private func saveAndDismiss() {
        let reflection = Reflection(
            captureContent: captureText,
            entryType: .pureCapture,
            tier: .daily,
            modeBalance: .captureOnly,
            themes: [],
            marinating: false
        )
        modelContext.insert(reflection)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        QuickCaptureScreen()
    }
    .modelContainer(for: Reflection.self, inMemory: true)
    .preferredColorScheme(.dark)
}
