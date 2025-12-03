import SwiftUI
import SwiftData

/// The main reflection screen implementing the Capture-First flow.
///
/// THIS IS THE MOST IMPORTANT SCREEN IN THE APP.
///
/// The flow enforces observation before interpretation:
/// 1. Mode indicator shows CAPTURE MODE
/// 2. Focus type selection (optional)
/// 3. Capture prompt + text input (REQUIRED)
/// 4. "Save Capture Only" OR "Add Interpretation" choice
/// 5. If adding interpretation: Synthesis prompt + text input (OPTIONAL)
/// 6. Save -> Question extraction (if daily)
struct NewReflectionScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(DesignNotesService.self) private var designNotes
    @Environment(PromptLibrary.self) private var promptLibrary

    // MARK: - State

    @State private var currentStep: FlowStep = .focusSelection
    @State private var selectedFocus: FocusType?
    @State private var captureText = ""
    @State private var synthesisText = ""
    @State private var currentMode: ReflectionMode = .capture
    @State private var showDesignNote = false
    @State private var currentDesignNote: DesignNote?

    // AI
    @State private var extractedQuestions: [String] = []
    @State private var isExtractingQuestions = false
    @State private var showQuestionModal = false

    // MARK: - Flow Steps

    enum FlowStep {
        case focusSelection
        case capture
        case captureComplete  // Choice point
        case synthesis
        case questionExtraction
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Main content
            ScrollView {
                VStack(spacing: 24) {
                    // Mode indicator
                    ModeIndicator(mode: currentMode)

                    // Flow content
                    switch currentStep {
                    case .focusSelection:
                        focusSelectionView
                    case .capture:
                        captureView
                    case .captureComplete:
                        captureCompleteView
                    case .synthesis:
                        synthesisView
                    case .questionExtraction:
                        EmptyView()  // Handled by modal
                    }
                }
                .padding()
            }
            .background(Color.vm.surface.ignoresSafeArea())

            // Loading overlay for question extraction
            if isExtractingQuestions {
                QuestionExtractionLoading()
            }

            // Design Note overlay
            if showDesignNote, let note = currentDesignNote {
                DesignNoteView(note: note) {
                    designNotes.markSeen(noteId: note.id)
                    showDesignNote = false
                }
            }
        }
        .navigationTitle("New Reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(Color.vm.textSecondary)
            }
        }
        .sheet(isPresented: $showQuestionModal) {
            QuestionExtractionModal(
                questions: extractedQuestions,
                onSave: saveSelectedQuestions,
                onSkip: { finishAndDismiss() }
            )
        }
        .onAppear {
            checkForDesignNote(.firstDailyEntry)
        }
    }

    // MARK: - Focus Selection View

    private var focusSelectionView: some View {
        VStack(spacing: 20) {
            // Orientation prompt
            if let prompt = promptLibrary.getPrompt(type: .orientation) {
                PromptView(prompt: prompt, mode: .capture)
            }

            Text("Choose your lens (optional)")
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)

            // Focus type grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                ForEach(FocusType.allCases, id: \.self) { focus in
                    FocusTypeButton(
                        focus: focus,
                        isSelected: selectedFocus == focus,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if selectedFocus == focus {
                                    selectedFocus = nil  // Deselect
                                } else {
                                    selectedFocus = focus
                                }
                            }
                        }
                    )
                }
            }

            Spacer().frame(height: 20)

            // Continue button
            PrimaryActionButton(
                title: selectedFocus != nil ? "Continue" : "Skip to Capture",
                icon: "arrow.right",
                mode: .capture
            ) {
                withAnimation {
                    currentStep = .capture
                }
            }
        }
    }

    // MARK: - Capture View (The Hard Part)

    private var captureView: some View {
        VStack(spacing: 20) {
            // Mode indicator emphasized
            HStack {
                Image(systemName: "camera.fill")
                Text("CAPTURE MODE")
                    .fontWeight(.semibold)
                Text("— the hard part")
                    .foregroundStyle(Color.vm.textSecondary)
            }
            .font(.caption)
            .foregroundStyle(Color.vm.capture)

            // Capture prompt
            PromptView(
                prompt: promptLibrary.getCapturePrompt(
                    focusType: selectedFocus,
                    stage: .emerging  // TODO: Get from user profile
                ),
                mode: .capture
            )

            // Capture text input
            ReflectionTextEditor(
                text: $captureText,
                placeholder: "What happened?",
                hint: "Describe what you observed—sights, sounds, words, actions.",
                mode: .capture,
                minHeight: 200
            )

            // Continue button (requires content)
            PrimaryActionButton(
                title: "Continue",
                icon: "arrow.right",
                mode: .capture,
                isEnabled: !captureText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ) {
                withAnimation {
                    currentStep = .captureComplete
                }
            }

            // Back button
            Button(action: {
                withAnimation {
                    currentStep = .focusSelection
                }
            }) {
                Text("Back to focus selection")
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textSecondary)
            }
        }
    }

    // MARK: - Capture Complete View (Choice Point)

    private var captureCompleteView: some View {
        VStack(spacing: 24) {
            // Success message
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.vm.capture)

                Text("Capture complete")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("You've recorded the moment. That's enough—or you can explore what it means.")
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textSecondary)
                    .multilineTextAlignment(.center)
            }

            // Preview of capture
            CapturePreview(content: captureText)

            // Choice buttons
            VStack(spacing: 12) {
                // Save Capture Only - PROMINENT
                Button(action: { saveAsPureCapture() }) {
                    VStack(spacing: 4) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Save Capture Only")
                        }
                        .font(.headline)
                        Text("Let meaning emerge later")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.vm.capture)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Add Interpretation - Secondary
                Button(action: {
                    withAnimation {
                        currentMode = .synthesis
                        currentStep = .synthesis
                        checkForDesignNote(.modeSwitch)
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Add Interpretation")
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.vm.synthesis.opacity(0.15))
                    .foregroundStyle(Color.vm.synthesis)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            // Marinate option
            Button(action: { saveAsMarinating() }) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("Save and let it marinate")
                }
                .font(.subheadline)
                .foregroundStyle(Color.vm.textSecondary)
            }

            // Back button
            Button(action: {
                withAnimation {
                    currentStep = .capture
                }
            }) {
                Text("Edit capture")
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textSecondary)
            }
        }
    }

    // MARK: - Synthesis View (Optional)

    private var synthesisView: some View {
        VStack(spacing: 20) {
            // Mode change indicator
            HStack {
                Image(systemName: "sparkles")
                Text("SYNTHESIS MODE")
                    .fontWeight(.semibold)
                Text("— finding meaning")
                    .foregroundStyle(Color.vm.textSecondary)
            }
            .font(.caption)
            .foregroundStyle(Color.vm.synthesis)

            // Synthesis prompt
            PromptView(
                prompt: promptLibrary.getSynthesisPrompt(
                    tier: .daily,
                    stage: .emerging
                ),
                mode: .synthesis
            )

            // Show capture for reference
            CapturePreview(content: captureText, isCompact: true)

            // Synthesis text input
            ReflectionTextEditor(
                text: $synthesisText,
                placeholder: "What does it mean? (optional)",
                hint: "If you want, explore what significance this moment holds for you.",
                mode: .synthesis,
                minHeight: 150
            )

            // Save buttons
            VStack(spacing: 12) {
                Button(action: { saveAsGroundedReflection() }) {
                    Text("Save Reflection")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(synthesisText.isEmpty ? Color.vm.capture : Color.vm.synthesis)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if !synthesisText.isEmpty {
                    Button(action: {
                        synthesisText = ""
                        saveAsPureCapture()
                    }) {
                        Text("Actually, just save the capture")
                            .font(.subheadline)
                            .foregroundStyle(Color.vm.textSecondary)
                    }
                }
            }

            // Back button
            Button(action: {
                withAnimation {
                    currentMode = .capture
                    currentStep = .captureComplete
                }
            }) {
                Text("Back to choices")
                    .font(.subheadline)
                    .foregroundStyle(Color.vm.textSecondary)
            }
        }
    }

    // MARK: - Actions

    private func saveAsPureCapture() {
        let reflection = createReflection(entryType: .pureCapture)
        modelContext.insert(reflection)
        checkForDesignNote(.firstPureCapture)
        triggerQuestionExtraction(for: reflection)
    }

    private func saveAsMarinating() {
        let reflection = createReflection(entryType: .pureCapture)
        reflection.marinating = true
        modelContext.insert(reflection)
        finishAndDismiss()
    }

    private func saveAsGroundedReflection() {
        let entryType: EntryType = synthesisText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .pureCapture
            : .groundedReflection

        let reflection = createReflection(entryType: entryType)
        modelContext.insert(reflection)

        if entryType == .groundedReflection {
            checkForDesignNote(.firstSynthesisOffer)
        }

        triggerQuestionExtraction(for: reflection)
    }

    private func createReflection(entryType: EntryType) -> Reflection {
        let trimmedCapture = captureText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSynthesis = synthesisText.trimmingCharacters(in: .whitespacesAndNewlines)

        return Reflection(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            tier: .daily,
            focusType: selectedFocus,
            captureContent: trimmedCapture,
            synthesisContent: trimmedSynthesis.isEmpty ? nil : trimmedSynthesis,
            entryType: entryType,
            modeBalance: calculateModeBalance(),
            themes: [],
            marinating: false
        )
    }

    private func calculateModeBalance() -> ModeBalance {
        let trimmedSynthesis = synthesisText.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedSynthesis.isEmpty {
            return .captureOnly
        }

        let captureLength = captureText.count
        let synthesisLength = trimmedSynthesis.count
        let total = captureLength + synthesisLength

        guard total > 0 else { return .captureOnly }

        let ratio = Double(captureLength) / Double(total)

        if ratio > 0.7 { return .captureHeavy }
        if ratio < 0.3 { return .synthesisHeavy }
        return .balanced
    }

    private func triggerQuestionExtraction(for reflection: Reflection) {
        isExtractingQuestions = true

        Task {
            let questions = await AIService.shared.extractQuestions(
                from: reflection.captureContent
            )

            await MainActor.run {
                extractedQuestions = questions
                isExtractingQuestions = false

                if !extractedQuestions.isEmpty {
                    showQuestionModal = true
                } else {
                    finishAndDismiss()
                }
            }
        }
    }

    private func saveSelectedQuestions(_ selected: [String]) {
        for questionText in selected {
            let question = Question(
                id: UUID(),
                createdAt: Date(),
                content: questionText,
                answered: false
            )
            modelContext.insert(question)
        }
        finishAndDismiss()
    }

    private func finishAndDismiss() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving: \(error)")
        }
        dismiss()
    }

    private func checkForDesignNote(_ trigger: NoteTrigger) {
        if let note = designNotes.getNoteFor(trigger: trigger),
           designNotes.shouldShow(noteId: note.id) {
            currentDesignNote = note
            showDesignNote = true
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NewReflectionScreen()
    }
    .environment(DesignNotesService())
    .environment(PromptLibrary())
    .modelContainer(for: [Reflection.self, Question.self], inMemory: true)
}
