import SwiftUI
import SwiftData

/// Screen for creating a new daily reflection/capture.
/// This is a placeholder that will be fully implemented in a separate blueprint.
struct NewReflectionScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedFocusType: FocusType = .story
    @State private var captureText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Mode indicator
                ModeIndicator(mode: .capture)

                // Focus type selector
                Picker("Focus", selection: $selectedFocusType) {
                    ForEach(FocusType.allCases) { type in
                        Label(type.displayName, systemImage: type.systemImage)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)

                // Capture input
                VStack(alignment: .leading, spacing: 8) {
                    Text("What would you like to capture?")
                        .font(.headline)

                    TextEditor(text: $captureText)
                        .frame(minHeight: 200)
                        .padding(8)
                        .background(Color.vm.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.vm.capture.opacity(0.3), lineWidth: 1)
                        )
                }

                Spacer()

                // Save button
                Button(action: saveCapture) {
                    Text("Save Capture")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(captureText.isEmpty ? Color.gray : Color.vm.capture)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(captureText.isEmpty)
            }
            .padding()
            .navigationTitle("New Capture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveCapture() {
        let reflection = Reflection(
            tier: .daily,
            focusType: selectedFocusType,
            captureContent: captureText,
            entryType: .capture,
            modeBalance: .captureOnly
        )

        modelContext.insert(reflection)
        dismiss()
    }
}

#Preview {
    NewReflectionScreen()
        .modelContainer(for: Reflection.self, inMemory: true)
}
