import SwiftUI
import SwiftData

struct NewReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ActiveHabit.order) private var habits: [ActiveHabit]
    @Query private var allReflections: [Reflection]

    @State private var captureText = ""
    @State private var showingCamera = false
    @State private var isExtracting = false
    @State private var showExtractionModal = false
    @State private var extractionResult: ExtractionResult?
    @State private var savedReflection: Reflection?
    @State private var showObservationPrompts = false
    @State private var observationQuestions: [String] = []
    @State private var isAnalyzingObservation = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.thresh.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.thresh.surface))
                }
                
                Spacer()
                
                Text("New Reflection")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.thresh.textSecondary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.thresh.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.thresh.textPrimary, lineWidth: 1)
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
                    .foregroundColor(Color.thresh.capture)
                
                Text("Capture Mode")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.thresh.capture)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.thresh.capture.opacity(0.1))
            )
            .padding(.bottom, 24)
            
            // WRAP CONTENT IN SCROLLVIEW TO FIX KEYBOARD BLOCKING
            ScrollView {
                VStack(spacing: 16) {
                    // Habit Pill
                    if let habit = habits.first {
                        HabitPillView(habit: habit)
                            .padding(.horizontal, 20)
                    }

                    // Text Input
                    ZStack(alignment: .topLeading) {
                        if captureText.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("What happened? Describe a specific moment - who was there, what was said, what you noticed.")
                                    .foregroundColor(Color.thresh.textTertiary)
                                    .font(.system(size: 16))
                            }
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $captureText)
                            .foregroundColor(Color.thresh.textPrimary)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 300)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.thresh.surface)
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
        .background(Color.thresh.background)
        .overlay {
            if isExtracting {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(Color.thresh.synthesis)
                            Text("Finding stories, ideas & questions...")
                                .font(.subheadline)
                                .foregroundStyle(Color.thresh.textPrimary)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.thresh.surface)
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
        .sheet(isPresented: $showObservationPrompts) {
            if let reflection = savedReflection {
                ObservationPromptsView(
                    questions: observationQuestions,
                    onAddMore: { additionalContent in
                        reflection.captureContent += "\n\n" + additionalContent
                        reflection.updatedAt = Date()
                        showObservationPrompts = false
                        runExtraction(on: reflection.captureContent)
                    },
                    onSkip: {
                        showObservationPrompts = false
                        runExtraction(on: reflection.captureContent)
                    }
                )
            }
        }
    }
    
    private func saveCapture() {
        let trimmedText = captureText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return
        }

        // ASSIGN NEXT REFLECTION NUMBER
        let maxNumber = allReflections.map { $0.reflectionNumber }.max() ?? 0

        // CREATE NEW REFLECTION
        let newReflection = Reflection(
            captureContent: trimmedText,
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly,
            reflectionNumber: maxNumber + 1
        )

        // INSERT INTO SWIFTDATA
        modelContext.insert(newReflection)

        // SAVE TO DATABASE
        do {
            try modelContext.save()
        } catch {
            dismiss()
            return
        }

        // Store the reflection for linking extracted items
        savedReflection = newReflection

        // Run observation analysis if text is long enough
        if trimmedText.count >= 50 {
            isAnalyzingObservation = true
            isExtracting = true
            Task {
                do {
                    let analysis = try await AIService.shared.analyzeForObservationGaps(trimmedText)
                    await MainActor.run {
                        isAnalyzingObservation = false
                        if !analysis.isObservational && !analysis.followUpQuestions.isEmpty {
                            isExtracting = false
                            observationQuestions = analysis.followUpQuestions
                            showObservationPrompts = true
                        } else {
                            runExtraction(on: trimmedText)
                        }
                    }
                } catch {
                    await MainActor.run {
                        isAnalyzingObservation = false
                        runExtraction(on: trimmedText)
                    }
                }
            }
        } else {
            dismiss()
        }
    }

    private func runExtraction(on text: String) {
        guard text.count >= 50 else {
            dismiss()
            return
        }

        isExtracting = true
        Task {
            do {
                let result = try await AIService.shared.extractFromReflection(text)
                await MainActor.run {
                    isExtracting = false
                    if !result.isEmpty {
                        extractionResult = result
                        showExtractionModal = true
                    } else {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isExtracting = false
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NewReflectionScreen()
        .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self, ActiveHabit.self])
}
