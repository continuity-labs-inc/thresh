import SwiftUI
import SwiftData

struct NewReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var captureText = ""
    @State private var showingCamera = false
    @State private var isExtracting = false
    @State private var showExtractionModal = false
    @State private var extractionResult: ExtractionResult?
    @State private var savedReflection: Reflection?

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
            
            // WRAP CONTENT IN SCROLLVIEW TO FIX KEYBOARD BLOCKING
            ScrollView {
                VStack(spacing: 16) {
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
                            .frame(minHeight: 300)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.vm.surface)
                    )
                    .padding(.horizontal, 20)
                    
                    // Padding for keyboard
                    Color.clear.frame(height: 100)
                }
            }
            
            Spacer()
            
            // Save Button - STAYS VISIBLE WHEN KEYBOARD IS OPEN
            SaveButton(
                title: isExtracting ? "Analyzing..." : "Save Capture",
                isEnabled: !captureText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isExtracting,
                action: saveCapture,
                theme: .blue
            )
        }
        .background(Color.vm.background)
        .overlay {
            if isExtracting {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(Color.vm.synthesis)
                            Text("Finding stories, ideas & questions...")
                                .font(.subheadline)
                                .foregroundStyle(Color.vm.textPrimary)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.vm.surface)
                        )
                    }
            }
        }
        .sheet(isPresented: $showExtractionModal) {
            if let result = extractionResult, let reflection = savedReflection {
                ExtractionReviewModal(
                    extractionResult: result,
                    sourceReflection: reflection,
                    onComplete: {
                        showExtractionModal = false
                        dismiss()
                    }
                )
            }
        }
    }
    
    private func saveCapture() {
        print("🔴 DEBUG: Save button pressed")

        let trimmedText = captureText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            print("🔴 DEBUG: Text is empty, not saving")
            return
        }

        // CREATE NEW REFLECTION
        let newReflection = Reflection(
            captureContent: trimmedText,
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly
        )

        print("🔴 DEBUG: Created reflection with ID: \(newReflection.id)")

        // INSERT INTO SWIFTDATA
        modelContext.insert(newReflection)

        print("🔴 DEBUG: Inserted into modelContext")

        // SAVE TO DATABASE
        do {
            try modelContext.save()
            print("✅ SUCCESS: Reflection saved to database!")
        } catch {
            print("❌ ERROR: Failed to save - \(error.localizedDescription)")
            dismiss()
            return
        }

        // Store the reflection for linking extracted items
        savedReflection = newReflection

        // Run AI extraction if text is long enough
        if trimmedText.count >= 50 {
            isExtracting = true
            Task {
                do {
                    let result = try await AIService.shared.extractFromReflection(trimmedText)
                    await MainActor.run {
                        isExtracting = false
                        if !result.isEmpty {
                            print("✅ Extracted \(result.totalCount) items from reflection")
                            extractionResult = result
                            showExtractionModal = true
                        } else {
                            print("ℹ️ No items extracted from reflection")
                            dismiss()
                        }
                    }
                } catch {
                    await MainActor.run {
                        isExtracting = false
                        print("❌ Extraction failed: \(error.localizedDescription)")
                        dismiss()
                    }
                }
            }
        } else {
            dismiss()
        }
    }
}

#Preview {
    NewReflectionScreen()
        .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self])
}
