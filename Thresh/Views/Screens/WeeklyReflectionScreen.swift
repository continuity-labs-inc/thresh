import SwiftUI
import SwiftData

struct WeeklyReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Reflection.createdAt, order: .reverse)
    private var allReflections: [Reflection]

    @Query(sort: \ActiveHabit.order) private var habits: [ActiveHabit]

    private var filteredReflections: [Reflection] {
        allReflections.filter { $0.tier == .daily || $0.tier == .active }
    }

    @State private var currentStep = 1
    @State private var selectedReflections: Set<UUID> = []
    @State private var synthesisText = ""
    @State private var bakhtinianText = ""
    @State private var showBakhtinianPrompt = false
    @State private var showWeeklyTooltip = true
    @State private var suggestedConnections: [Connection] = []
    @State private var isAnalyzing = false
    @State private var showHabitPrompt = false
    @FocusState private var isTextEditorFocused: Bool
    
    // Get reflections from last 7 days
    private var recentReflections: [Reflection] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return filteredReflections.filter { $0.createdAt >= sevenDaysAgo }
    }

    // Phase 2 skip rate for nudge display
    private var phase2SkipRate: Double {
        let total = recentReflections.count
        guard total > 0 else { return 0 }
        let skipped = recentReflections.filter { !$0.phase2Completed }.count
        return Double(skipped) / Double(total)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header - always visible
            headerView
            
            // Synthesis Mode Badge
            if !isTextEditorFocused {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.thresh.synthesis)
                    
                    Text("SYNTHESIS MODE")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.thresh.synthesis)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.thresh.synthesis.opacity(0.1)))
                .padding(.bottom, 24)
                
                // Step Indicators
                stepIndicator
            }
            
            // Content based on step
            if currentStep == 1 {
                reviewStep
            } else if currentStep == 2 {
                writeStep
            } else {
                refineStep
            }
        }
        .background(Color.thresh.background)
        .onTapGesture {
            isTextEditorFocused = false
        }
        .featureTooltip(
            title: "Weekly Synthesis",
            message: "Select captures that feel connected, then write about the thread between them. This isn't a summary — it's finding what the moments mean together.",
            featureKey: "weekly_synthesis",
            isPresented: $showWeeklyTooltip
        )
        .sheet(isPresented: $showHabitPrompt) {
            HabitIntentionSheet(
                isPresented: $showHabitPrompt,
                onSave: { intention in
                    createNewHabit(with: intention)
                    dismiss()
                }
            )
        }
        .onChange(of: showHabitPrompt) { _, newValue in
            // If sheet was dismissed without saving (skipped), dismiss the screen
            if !newValue && habits.first?.isDefault == true {
                dismiss()
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            // Spacer to balance layout (NavigationStack provides back if needed)
            Color.clear.frame(width: 60, height: 44)

            Spacer()

            Text("Weekly Reflection")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.thresh.textPrimary)

            Spacer()

            // Done button when keyboard is up, Cancel otherwise
            if isTextEditorFocused {
                Button(action: { isTextEditorFocused = false }) {
                    Text("Done")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.thresh.synthesis)
                }
                .frame(width: 60, height: 44)
            } else {
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.thresh.textSecondary)
                }
                .frame(width: 60, height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, isTextEditorFocused ? 8 : 16)
    }
    
    // MARK: - Step Indicator
    
    private var stepIndicator: some View {
        HStack(spacing: 12) {
            stepDot(number: 1, label: "Review", isActive: currentStep >= 1)
            Spacer()
            stepDot(number: 2, label: "Write", isActive: currentStep >= 2)
            Spacer()
            stepDot(number: 3, label: "Refine", isActive: currentStep >= 3)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 32)
    }
    
    private func stepDot(number: Int, label: String, isActive: Bool) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(isActive ? Color.thresh.synthesis : Color.thresh.surfaceSecondary)
                .frame(width: 36, height: 36)
                .overlay(
                    Text("\(number)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isActive ? .white : Color.thresh.textTertiary)
                )

            // ALWAYS show label, just dim inactive ones
            Text(label)
                .font(.system(size: 12, weight: currentStep == number ? .semibold : .regular))
                .foregroundColor(currentStep == number ? Color.thresh.synthesis : Color.thresh.textTertiary)
        }
    }
    
    // MARK: - Step 1: Review
    
    private var reviewStep: some View {
        VStack(spacing: 16) {
            if recentReflections.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Habit check-in summary
                        if let habit = habits.first {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "flame")
                                        .foregroundColor(.orange)
                                    Text(habit.intention)
                                        .font(.headline)
                                        .foregroundStyle(Color.thresh.textPrimary)
                                }
                                Text("Checked in \(habit.checkInCountThisWeek) times this week")
                                    .font(.subheadline)
                                    .foregroundColor(Color.thresh.textSecondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.thresh.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        }

                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select captures to include")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.thresh.textPrimary)

                            Text("Choose the moments from this week that feel connected or worth synthesizing.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.thresh.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        // Phase 2 skip rate nudge
                        if phase2SkipRate > 0.5 && recentReflections.count >= 3 {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 16))
                                Text("Most of your captures this week skipped the reflection phase. The second phase builds analytical depth—try it more next week.")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.thresh.textSecondary)
                            }
                            .padding(12)
                            .background(Color.orange.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 20)
                        }

                        // Reflection List
                        ForEach(recentReflections) { reflection in
                            CaptureRow(
                                reflection: reflection,
                                isSelected: selectedReflections.contains(reflection.id),
                                onToggle: { toggleSelection(reflection.id) }
                            )
                        }
                        
                        Color.clear.frame(height: 100)
                    }
                }
            }
            
            Spacer()
            
            // Next Button
            SaveButton(
                title: "Continue to Write (\(selectedReflections.count))",
                isEnabled: !selectedReflections.isEmpty,
                action: {
                    let selected = recentReflections.filter { selectedReflections.contains($0.id) }
                    Task {
                        isAnalyzing = true
                        withAnimation { currentStep = 2 }
                        suggestedConnections = await AIService.shared.detectConnections(in: selected)
                        isAnalyzing = false
                    }
                },
                theme: .orange
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "camera")
                .font(.system(size: 60))
                .foregroundColor(Color.thresh.textTertiary)
                .padding(.vertical, 20)
            
            Text("No captures this week")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.thresh.textPrimary)
            
            Text("Weekly synthesis works best with daily captures to draw from. Start capturing your moments to build material for reflection.")
                .font(.system(size: 16))
                .foregroundColor(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Create a Capture")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(RoundedRectangle(cornerRadius: 28).fill(Color.thresh.capture))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Step 2: Write
    
    // Computed property for Continue button state
    private var canContinueToRefine: Bool {
        !synthesisText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var writeStep: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        // Loading state while analyzing patterns
                        if isAnalyzing {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Looking for patterns...")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.thresh.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }

                        // Selected Captures Summary - show at top for context
                        if !isTextEditorFocused && !selectedReflections.isEmpty {
                            selectedCapturesSummary
                                .padding(.horizontal, 20)
                        }

                        // Habit Check-In Card (SEPARATE from synthesis prompt)
                        if !isTextEditorFocused, let habit = habits.first, !habit.isDefault {
                            habitCheckInCard(habit: habit)
                                .padding(.horizontal, 20)
                        }

                        // Patterns We Noticed section - only show if real patterns exist
                        if !isAnalyzing && !suggestedConnections.isEmpty && !isTextEditorFocused {
                            let realConnections = suggestedConnections.filter { !$0.description.isEmpty }
                            if !realConnections.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Patterns We Noticed")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Color.thresh.synthesis)

                                    ForEach(realConnections.prefix(3)) { connection in
                                        HStack(alignment: .top, spacing: 8) {
                                            Image(systemName: "link")
                                                .font(.system(size: 12))
                                                .foregroundStyle(Color.thresh.synthesis)
                                            Text(connection.description)
                                                .font(.system(size: 14))
                                                .foregroundStyle(Color.thresh.textSecondary)
                                        }
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.thresh.synthesis.opacity(0.08))
                                )
                                .padding(.horizontal, 20)
                            }
                        }

                        // Synthesis Prompt - CLEAR and PROMINENT
                        if !isTextEditorFocused {
                            synthesisPromptCard
                                .padding(.horizontal, 20)
                        }

                        // Synthesis Text Editor - LARGER
                        synthesisTextEditor
                            .padding(.horizontal, 20)
                            .id("textEditor")

                        Color.clear.frame(height: isTextEditorFocused ? 20 : 100)
                    }
                    .padding(.top, 8)
                }
                .onChange(of: isTextEditorFocused) { _, focused in
                    if focused {
                        withAnimation {
                            proxy.scrollTo("textEditor", anchor: .top)
                        }
                    }
                }
            }

            // Bottom Navigation with helper text
            writeStepBottomButtons
        }
    }

    // MARK: - Write Step Components

    private var selectedCapturesSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("SELECTED CAPTURES")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.thresh.textTertiary)

                Spacer()

                Text("\(selectedReflections.count) selected")
                    .font(.system(size: 12))
                    .foregroundColor(Color.thresh.textTertiary)
            }

            // Show first 2-3 captures as collapsed previews
            let selected = recentReflections.filter { selectedReflections.contains($0.id) }
            ForEach(selected.prefix(3)) { reflection in
                Text(reflection.captureContent)
                    .font(.system(size: 13))
                    .foregroundColor(Color.thresh.textSecondary)
                    .lineLimit(2)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.thresh.surface)
                    )
            }

            if selected.count > 3 {
                Text("+ \(selected.count - 3) more")
                    .font(.system(size: 12))
                    .foregroundColor(Color.thresh.textTertiary)
            }
        }
    }

    private func habitCheckInCard(habit: ActiveHabit) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "flame")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)
                Text("HABIT CHECK-IN")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.orange)
            }

            Text("How did \"\(habit.intention)\" go this week?")
                .font(.system(size: 14))
                .foregroundColor(Color.thresh.textSecondary)

            Text("Checked in \(habit.checkInCountThisWeek) times")
                .font(.system(size: 12))
                .foregroundColor(Color.thresh.textTertiary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange.opacity(0.08))
        )
    }

    private var synthesisPromptCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.thresh.synthesis)

                Text("SYNTHESIS PROMPT")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.thresh.synthesis)
            }

            Text("What thread connects these moments? What patterns or meaning emerge when you see them together?")
                .font(.system(size: 16))
                .foregroundColor(Color.thresh.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.thresh.synthesis.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.thresh.synthesis.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var synthesisTextEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isTextEditorFocused {
                Text("Write your synthesis:")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.thresh.textSecondary)
            }

            ZStack(alignment: .topLeading) {
                if synthesisText.isEmpty {
                    Text("Write your synthesis here. What do these moments mean together?")
                        .foregroundColor(Color.thresh.textTertiary)
                        .font(.system(size: 16))
                        .padding(.top, 12)
                        .padding(.leading, 12)
                }

                TextEditor(text: $synthesisText)
                    .foregroundColor(Color.thresh.textPrimary)
                    .font(.system(size: 16))
                    .scrollContentBackground(.hidden)
                    .focused($isTextEditorFocused)
                    .frame(minHeight: 200) // LARGER text area
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.thresh.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isTextEditorFocused ? Color.thresh.synthesis : Color.clear, lineWidth: 2)
            )

            // Word count hint
            HStack {
                Spacer()
                Text("\(synthesisText.split(separator: " ").count) words")
                    .font(.system(size: 12))
                    .foregroundColor(Color.thresh.textTertiary)
            }
        }
    }

    private var writeStepBottomButtons: some View {
        VStack(spacing: 8) {
            // Helper text when button is disabled
            if !canContinueToRefine {
                Text("Write your synthesis to continue")
                    .font(.system(size: 12))
                    .foregroundColor(Color.thresh.textTertiary)
            }

            HStack(spacing: 12) {
                Button(action: {
                    isTextEditorFocused = false
                    withAnimation { currentStep = 1 }
                }) {
                    Text("Back")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.thresh.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .strokeBorder(Color.thresh.textPrimary, lineWidth: 1.5)
                        )
                }

                Button(action: {
                    isTextEditorFocused = false
                    withAnimation { currentStep = 3 }
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(canContinueToRefine ? Color.thresh.synthesis : Color.thresh.surfaceSecondary)
                        )
                }
                .disabled(!canContinueToRefine)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color.thresh.background)
    }
    
    // MARK: - Step 3: Refine (Bakhtinian)
    
    private var refineStep: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        // Optional Bakhtinian Prompt - hide when keyboard up
                        if !isTextEditorFocused {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "person.2")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color.thresh.reflect)
                                    
                                    Text("PERSPECTIVE PROMPT")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color.thresh.reflect)
                                    
                                    Spacer()
                                    
                                    Text("Optional")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.thresh.textTertiary)
                                }
                                
                                Text("Retell this week from someone else's perspective—a person who appears in your reflections. How might they describe these same days?")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.thresh.textSecondary)
                                    .italic()
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.thresh.reflect.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(Color.thresh.reflect.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                        }
                        
                        // Bakhtinian Text Editor
                        VStack(alignment: .leading, spacing: 8) {
                            if isTextEditorFocused {
                                Text("Write from another perspective:")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.thresh.textSecondary)
                                    .padding(.horizontal, 20)
                            }
                            
                            ZStack(alignment: .topLeading) {
                                if bakhtinianText.isEmpty {
                                    Text("Write from another perspective...")
                                        .foregroundColor(Color.thresh.textTertiary)
                                        .font(.system(size: 16))
                                        .padding(.top, 12)
                                        .padding(.leading, 16)
                                }
                                
                                TextEditor(text: $bakhtinianText)
                                    .foregroundColor(Color.thresh.textPrimary)
                                    .font(.system(size: 16))
                                    .scrollContentBackground(.hidden)
                                    .focused($isTextEditorFocused)
                                    .frame(minHeight: isTextEditorFocused ? 250 : 200)
                                    .padding(12)
                            }
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.thresh.surface))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(isTextEditorFocused ? Color.thresh.reflect : Color.clear, lineWidth: 2)
                            )
                            .padding(.horizontal, 20)
                            .id("bakhtinianEditor")
                        }
                        
                        // Your Synthesis Preview - hide when keyboard up
                        if !isTextEditorFocused {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your Synthesis")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.thresh.textSecondary)
                                
                                Text(synthesisText)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.thresh.textTertiary)
                                    .lineLimit(4)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.thresh.surfaceSecondary))
                            .padding(.horizontal, 20)
                        }
                        
                        Color.clear.frame(height: isTextEditorFocused ? 20 : 100)
                    }
                    .padding(.top, 8)
                }
                .onChange(of: isTextEditorFocused) { _, focused in
                    if focused {
                        withAnimation {
                            proxy.scrollTo("bakhtinianEditor", anchor: .top)
                        }
                    }
                }
            }
            
            // Navigation Buttons
            HStack(spacing: 12) {
                Button(action: {
                    isTextEditorFocused = false
                    withAnimation { currentStep = 2 }
                }) {
                    Text("Back")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.thresh.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .strokeBorder(Color.thresh.textPrimary, lineWidth: 2)
                        )
                }
                
                SaveButton(
                    title: "Save Synthesis",
                    isEnabled: true,
                    action: {
                        isTextEditorFocused = false
                        saveWeeklySynthesis()
                    },
                    theme: .orange
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .padding(.top, 12)
            .background(Color.thresh.background)
        }
    }
    
    // MARK: - Helper Views
    
    private func toggleSelection(_ id: UUID) {
        if selectedReflections.contains(id) {
            selectedReflections.remove(id)
        } else {
            selectedReflections.insert(id)
        }
    }
    
    // MARK: - Save Function

    private func saveWeeklySynthesis() {
        let trimmedSynthesis = synthesisText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSynthesis.isEmpty else { return }

        // Get selected reflections
        let selected = recentReflections.filter { selectedReflections.contains($0.id) }

        // Combine captures for context
        let combinedCaptures = selected
            .map { $0.captureContent }
            .joined(separator: "\n\n---\n\n")

        // Add Bakhtinian content if present
        let finalSynthesis = if !bakhtinianText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            trimmedSynthesis + "\n\n[Alternative Perspective]\n" + bakhtinianText
        } else {
            trimmedSynthesis
        }

        // Create weekly synthesis
        let weeklySynthesis = Reflection(
            captureContent: combinedCaptures,
            synthesisContent: finalSynthesis,
            entryType: .synthesis,
            tier: .weekly,
            modeBalance: .synthesisOnly,
            linkedReflections: selected
        )

        modelContext.insert(weeklySynthesis)

        do {
            try modelContext.save()

            // Save to ContinuityCore for cross-app visibility
            weeklySynthesis.saveToContinuityStore()

            // Trigger connection regeneration in background
            let reflectionData = allReflections.map { ReflectionData(from: $0) }
            Task {
                _ = await ConnectionService.shared.regenerateConnections(for: reflectionData)
            }

            // Show habit prompt if user has only default habit or habit is expiring
            if let habit = habits.first, (habit.isDefault || habit.isExpired) {
                showHabitPrompt = true
            } else {
                dismiss()
            }
        } catch {
            // Handle save error silently
        }
    }

    private func createNewHabit(with intention: String) {
        // Delete old habits
        for habit in habits {
            modelContext.delete(habit)
        }

        // Create new habit
        let newHabit = ActiveHabit(
            intention: intention,
            isDefault: false,
            order: 0
        )
        modelContext.insert(newHabit)

        do {
            try modelContext.save()
        } catch {
            // Silently fail
        }
    }
}

// MARK: - Capture Row Component

struct CaptureRow: View {
    let reflection: Reflection
    let isSelected: Bool
    let onToggle: () -> Void
    
    private var timeSince: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour], from: reflection.createdAt, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else {
            return "Just now"
        }
    }
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                // Checkbox
                Circle()
                    .strokeBorder(isSelected ? Color.thresh.synthesis : Color.thresh.textTertiary, lineWidth: 2)
                    .background(Circle().fill(isSelected ? Color.thresh.synthesis : Color.clear))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(reflection.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.thresh.textPrimary)
                        
                        Text("·")
                            .foregroundColor(Color.thresh.textTertiary)
                        
                        Text(timeSince)
                            .font(.system(size: 14))
                            .foregroundColor(Color.thresh.textSecondary)
                    }
                    
                    Text(reflection.captureContent)
                        .font(.system(size: 14))
                        .foregroundColor(Color.thresh.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.thresh.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                isSelected ? Color.thresh.synthesis.opacity(0.4) : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WeeklyReflectionScreen()
        .modelContainer(for: [Reflection.self, ActiveHabit.self], inMemory: true)
}
