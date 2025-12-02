import SwiftUI
import SwiftData

struct NewReflectionScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var captureContent: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Mode indicator
            HStack {
                Image(systemName: "camera.fill")
                Text("Capture Mode")
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundStyle(Color.vm.capture)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.vm.capture.opacity(0.1))

            // Text input area
            ScrollView {
                TextEditor(text: $captureContent)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 200)
                    .padding()
                    .background(Color.vm.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }

            Spacer()

            // Save button
            Button(action: saveReflection) {
                Text("Save Capture")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        captureContent.isEmpty
                            ? Color.vm.surfaceSecondary
                            : Color.vm.capture
                    )
                    .foregroundStyle(captureContent.isEmpty ? Color.secondary : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(captureContent.isEmpty)
            .padding()
        }
        .background(Color.vm.background)
        .navigationTitle("New Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    private func saveReflection() {
        let reflection = Reflection(
            captureContent: captureContent,
            entryType: .pureCapture,
            tier: .active
        )
        modelContext.insert(reflection)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        NewReflectionScreen()
            .modelContainer(for: Reflection.self, inMemory: true)
    }
}
