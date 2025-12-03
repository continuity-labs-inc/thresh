import SwiftUI

struct NewReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var captureText = ""
    @State private var showingCamera = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.vm.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.vm.surface))
                }
                
                Spacer()
                
                Text("New Reflection")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.vm.textSecondary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.vm.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.vm.textPrimary, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
            
            // Mode Badge
            HStack {
                Image(systemName: "camera.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.vm.capture)
                
                Text("Capture Mode")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.vm.capture)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.vm.capture.opacity(0.1))
            )
            .padding(.bottom, 24)
            
            // Text Input
            ZStack(alignment: .topLeading) {
                if captureText.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Describe what happened in complete sentences...")
                            .foregroundColor(Color.vm.textTertiary)
                            .font(.system(size: 16))
                        
                        Text("Write as if telling a friend about this moment.")
                            .foregroundColor(Color.vm.textTertiary.opacity(0.7))
                            .font(.system(size: 14))
                    }
                    .padding(.top, 8)
                    .padding(.leading, 5)
                }
                
                TextEditor(text: $captureText)
                    .foregroundColor(Color.vm.textPrimary)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.vm.surface)
            )
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Save Button
            SaveButton(
                title: "Save Capture",
                isEnabled: !captureText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: saveCapture,
                theme: .blue
            )
        }
        .background(Color.vm.background)
    }
    
    private func saveCapture() {
        // TODO: Save capture logic
        print("Saving capture: \(captureText)")
        dismiss()
    }
}

#Preview {
    NewReflectionScreen()
}
