import SwiftUI
import SwiftData

struct NewReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ActiveHabit.order) private var habits: [ActiveHabit]
    @Query private var allReflections: [Reflection]
    @Query private var allUserProgress: [UserProgress]

    // Original state
    @State private var showingCamera = false
    @State private var isExtracting = false
    @State private var showExtractionModal = false
    @State private var extractionResult: ExtractionResult?
    @State private var savedReflection: Reflection?
    @State private var showObservationPrompts = false
    @State private var observationQuestions: [String] = []
    @State private var isAnalyzingObservation = false
    @State private var showTooShortMessage = false
    @State private var extractionError: String?
    @State private var showPaywall = false
    @State private var subscriptionService = SubscriptionService.shared

    // Two-phase state
    @State private var currentPhase = 1
    @State private var phase1Content = ""
    @State private var phase2Content = ""
    @State private var selectedCategory: PromptCategory?
    @State private var currentPrompt = ""
    @State private var phase2Prompt = ""
    @State private var captureAnalysis: CaptureAnalysis?
    @State private var isAnalyzingPhase1 = false
    @State private var showTwoPhaseTooltip = true
    @State private var isLoadingPhase1Prompt = false

    // Open prompt (no category selected - AI will detect)
    private let openPrompt = "What moment from today is still with you? Describe what happened—who was there, what was said, what you noticed."

    private var userProgress: UserProgress? {
        allUserProgress.first
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView

            // Mode Badge with phase indicator
            modeBadge

            // Content based on phase
            if currentPhase == 1 {
                phase1View
            } else {
                phase2View
            }
        }
        .background(Color.thresh.background)
        .overlay {
            if isExtracting {
                extractingOverlay
            }
            if isAnalyzingPhase1 {
                analyzingPhase1Overlay
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
                    },
                    onSkip: {
                        showObservationPrompts = false
                    }
                )
            }
        }
        .alert("Reflection Too Short", isPresented: $showTooShortMessage) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Add at least 20 characters for AI analysis to find stories, ideas, and questions.")
        }
        .alert("Extraction Error", isPresented: .init(
            get: { extractionError != nil },
            set: { if !$0 { extractionError = nil } }
        )) {
            Button("OK") {
                extractionError = nil
                dismiss()
            }
        } message: {
            Text(extractionError ?? "Unknown error")
        }
        .sheet(isPresented: $showPaywall) {
            PaywallScreen()
        }
        .featureTooltip(
            title: "Two-Phase Reflection",
            message: "First describe what happened concretely, then reflect on why you noticed it. This builds observation skills over time.",
            featureKey: "two_phase_intro",
            isPresented: $showTwoPhaseTooltip
        )
        .onAppear {
            loadPhase1Prompt()
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            // Left side: Back button in Phase 2, spacer in Phase 1
            if currentPhase == 2 {
                Button(action: {
                    withAnimation { currentPhase = 1 }
                }) {
                    Text("Back")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.thresh.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.thresh.textPrimary, lineWidth: 1)
                        )
                }
            } else {
                // Spacer to balance Cancel button
                Color.clear
                    .frame(width: 60, height: 44)
            }

            Spacer()

            Text(currentPhase == 1 ? "Describe" : "Reflect")
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
    }

    // MARK: - Mode Badge

    private var modeBadge: some View {
        HStack {
            Image(systemName: currentPhase == 1 ? "eye" : "sparkles")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(currentPhase == 1 ? Color.thresh.capture : Color.thresh.synthesis)

            Text(currentPhase == 1 ? "Phase 1: Describe" : "Phase 2: Reflect")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(currentPhase == 1 ? Color.thresh.capture : Color.thresh.synthesis)

            // Phase indicator dots
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.thresh.capture)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(currentPhase == 2 ? Color.thresh.synthesis : Color.thresh.textTertiary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
            .padding(.leading, 8)

            // Show extraction counter for free tier
            ExtractionCounterBadge()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill((currentPhase == 1 ? Color.thresh.capture : Color.thresh.synthesis).opacity(0.1))
        )
        .padding(.bottom, 24)
    }

    // MARK: - Phase 1 View

    private var phase1View: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    // Habit Pill
                    if let habit = habits.first {
                        HabitPillView(habit: habit)
                            .padding(.horizontal, 20)
                    }

                    // Prompt Card with refresh button for AI prompts
                    PromptCard(
                        phase: 1,
                        prompt: currentPrompt,
                        category: selectedCategory,
                        isLoading: isLoadingPhase1Prompt,
                        onRefresh: refreshPhase1Prompt
                    )
                    .padding(.horizontal, 20)

                    // Category Pills (horizontal scroll)
                    categoryPillsView
                        .padding(.horizontal, 20)

                    // Text Input
                    ZStack(alignment: .topLeading) {
                        if phase1Content.isEmpty {
                            Text("Start writing...")
                                .foregroundColor(Color.thresh.textTertiary)
                                .font(.system(size: 16))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }

                        TextEditor(text: $phase1Content)
                            .foregroundColor(Color.thresh.textPrimary)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 250)
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

            // Continue Button (appears after 50+ chars)
            SaveButton(
                title: "Continue →",
                isEnabled: phase1Content.trimmingCharacters(in: .whitespacesAndNewlines).count >= 50,
                action: transitionToPhase2,
                theme: .blue
            )
        }
    }

    // MARK: - Category Pills

    private var categoryPillsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Or try a specific lens:")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color.thresh.textTertiary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // "Open" pill to reset to no category
                    CategoryPill(
                        title: "Open",
                        isSelected: selectedCategory == nil,
                        action: { selectCategory(nil) }
                    )

                    ForEach(PromptCategory.allCases, id: \.self) { category in
                        CategoryPill(
                            title: category.displayName,
                            isSelected: selectedCategory == category,
                            action: { selectCategory(category) }
                        )
                    }
                }
            }
        }
    }

    private func selectCategory(_ category: PromptCategory?) {
        // Don't allow switching while loading
        guard !isLoadingPhase1Prompt else { return }

        withAnimation(.easeInOut(duration: 0.2)) {
            selectedCategory = category
        }

        // Generate AI prompt for the selected category
        generatePhase1Prompt(for: category)
    }

    private func generatePhase1Prompt(for category: PromptCategory?) {
        isLoadingPhase1Prompt = true

        Task {
            let prompt = await AIService.shared.generatePhase1Prompt(category: category)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentPrompt = prompt
                    isLoadingPhase1Prompt = false
                }
            }
        }
    }

    private func refreshPhase1Prompt() {
        generatePhase1Prompt(for: selectedCategory)
    }

    // MARK: - Phase 2 View

    private var phase2View: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    // Collapsed Phase 1 content
                    CollapsedCaptureCard(content: phase1Content)
                        .padding(.horizontal, 20)

                    // Phase 2 prompt card with refresh
                    PromptCard(
                        phase: 2,
                        prompt: phase2Prompt,
                        category: selectedCategory,
                        onRefresh: refreshPhase2Prompt
                    )
                    .padding(.horizontal, 20)

                    // Text Editor for Phase 2
                    ZStack(alignment: .topLeading) {
                        if phase2Content.isEmpty {
                            Text("Reflect on what you described...")
                                .foregroundColor(Color.thresh.textTertiary)
                                .font(.system(size: 16))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }

                        TextEditor(text: $phase2Content)
                            .foregroundColor(Color.thresh.textPrimary)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
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

            // Buttons
            HStack(spacing: 12) {
                Button(action: { saveCapture(phase2Skipped: true) }) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.thresh.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .strokeBorder(Color.thresh.textTertiary, lineWidth: 1)
                        )
                }

                SaveButton(
                    title: isExtracting ? "Analyzing..." : "Save Capture",
                    isEnabled: !isExtracting,
                    action: { saveCapture(phase2Skipped: false) },
                    theme: .blue
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Overlays

    private var extractingOverlay: some View {
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

    private var analyzingPhase1Overlay: some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color.thresh.capture)
                    Text("Analyzing your capture...")
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

    // MARK: - Actions

    private func loadPhase1Prompt() {
        // Start with open prompt by default (no category selected)
        // AI will detect category during analysis
        selectedCategory = nil
        currentPrompt = openPrompt
    }

    private func createUserProgress() -> UserProgress {
        let newProgress = UserProgress()
        modelContext.insert(newProgress)
        try? modelContext.save()
        return newProgress
    }

    private func transitionToPhase2() {
        isAnalyzingPhase1 = true
        Task {
            do {
                let analysis = try await AIService.shared.analyzeCapture(phase1Content)
                await MainActor.run {
                    captureAnalysis = analysis

                    // Use AI-generated contextual prompt if available, otherwise fall back to static
                    if let aiPrompt = analysis.suggestedPhase2Prompt, !aiPrompt.isEmpty {
                        phase2Prompt = aiPrompt
                    } else {
                        // Fallback to service-generated prompt with key element
                        phase2Prompt = TwoPhasePromptService.shared.getPhase2Prompt(
                            category: selectedCategory ?? .moment,
                            keyElement: analysis.keyElement,
                            stage: userProgress?.currentStage ?? 1
                        )
                    }

                    isAnalyzingPhase1 = false
                    withAnimation { currentPhase = 2 }
                }
            } catch {
                // Fallback: use category-based Phase 2 prompt without AI analysis
                await MainActor.run {
                    phase2Prompt = selectedCategory?.randomPhase2Prompt() ?? "Why did you choose those details?"
                    isAnalyzingPhase1 = false
                    withAnimation { currentPhase = 2 }
                }
            }
        }
    }

    private func refreshPhase2Prompt() {
        guard let category = selectedCategory else { return }

        // Get all prompts for this category, excluding the current one
        let allPrompts = category.phase2Prompts
        let otherPrompts = allPrompts.filter { $0 != phase2Prompt }

        if let newPrompt = otherPrompts.randomElement() {
            withAnimation(.easeInOut(duration: 0.2)) {
                phase2Prompt = newPrompt
            }
        } else {
            // Fallback if somehow we only have one prompt
            withAnimation(.easeInOut(duration: 0.2)) {
                phase2Prompt = "Why did you choose those details? What did you leave out?"
            }
        }
    }

    private func saveCapture(phase2Skipped: Bool) {
        let trimmedPhase1 = phase1Content.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhase2 = phase2Content.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPhase1.isEmpty else { return }

        // ASSIGN NEXT REFLECTION NUMBER
        let maxNumber = allReflections.compactMap { $0.reflectionNumber }.max() ?? 0

        // CREATE NEW REFLECTION
        let newReflection = Reflection(
            captureContent: trimmedPhase1,
            reflectionContent: phase2Skipped ? nil : (trimmedPhase2.isEmpty ? nil : trimmedPhase2),
            entryType: phase2Skipped ? .pureCapture : .groundedReflection,
            tier: .active,
            modeBalance: phase2Skipped ? .captureOnly : .captureWithReflection,
            reflectionNumber: maxNumber + 1
        )

        // Set prompt metadata
        newReflection.promptCategory = selectedCategory?.rawValue
        newReflection.promptDomain = captureAnalysis?.domain
        newReflection.phase2Completed = !phase2Skipped && !trimmedPhase2.isEmpty
        newReflection.observationDepth = captureAnalysis?.observationDepth

        // INSERT INTO SWIFTDATA
        modelContext.insert(newReflection)

        // SAVE TO DATABASE
        do {
            try modelContext.save()
            print("✅ Reflection saved: \(trimmedPhase1.prefix(50))...")

            // Save to ContinuityCore for cross-app visibility
            newReflection.saveToContinuityStore()

            // Record progress
            if let progress = userProgress {
                StageProgressionService.shared.recordCapture(
                    userProgress: progress,
                    reflection: newReflection,
                    modelContext: modelContext
                )
            }
        } catch {
            print("❌ Failed to save reflection: \(error)")
            dismiss()
            return
        }

        // Store the reflection for linking extracted items
        savedReflection = newReflection

        // Check minimum length for AI analysis
        guard trimmedPhase1.count >= 20 else {
            print("⚠️ Reflection too short (\(trimmedPhase1.count) chars) for AI analysis")
            showTooShortMessage = true
            return
        }

        // Check if user can extract (free tier limit)
        guard subscriptionService.canExtract else {
            print("⚠️ Free tier extraction limit reached")
            showPaywall = true
            return
        }

        // Run extraction
        isExtracting = true
        Task {
            await runExtractionAsync(on: trimmedPhase1)
        }
    }

    private func runExtractionAsync(on text: String) async {
        print("🔍 Starting extraction for text: \(text.prefix(50))...")
        do {
            let result = try await AIService.shared.extractFromReflection(text)

            // Record extraction usage for free tier tracking
            subscriptionService.recordExtraction()

            await MainActor.run {
                isExtracting = false
                extractionResult = result
                if result.isEmpty {
                    print("ℹ️ Extraction complete but found nothing")
                } else {
                    print("✅ Extraction found: \(result.stories.count) stories, \(result.ideas.count) ideas, \(result.questions.count) questions")
                }
                // Always show the modal so user knows extraction ran
                showExtractionModal = true
            }
        } catch {
            print("❌ Extraction failed: \(error)")
            await MainActor.run {
                isExtracting = false
                extractionError = "AI extraction failed: \(error.localizedDescription)"
            }
        }
    }
}

// MARK: - Category Pill Component

private struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : Color.thresh.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.thresh.capture : Color.thresh.surface)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.clear : Color.thresh.textTertiary.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NewReflectionScreen()
        .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self, ActiveHabit.self, UserProgress.self])
}
