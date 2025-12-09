import SwiftUI
import SwiftData

struct QuarterlyReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Reflection.createdAt, order: .reverse)
    private var allReflections: [Reflection]

    private var allWeeklies: [Reflection] {
        allReflections.filter { $0.tier == .weekly }
    }
    
    @State private var currentStep = 1
    @State private var selectedWeeklies: Set<UUID> = []
    @State private var synthesisText = ""
    @State private var culturalFramingText = ""
    @State private var showCulturalPrompt = false
    
    // Get weekly syntheses from last 90 days
    private var recentWeeklies: [Reflection] {
        let ninetyDaysAgo = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()
        return allWeeklies.filter { $0.createdAt >= ninetyDaysAgo }
    }
    
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
                
                Text("Quarterly Reflection")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.thresh.textSecondary)
                
                Spacer()
                
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
            
            // Synthesis Mode Badge
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.thresh.idea)
                
                Text("SEASONAL SYNTHESIS")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.thresh.idea)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.thresh.idea.opacity(0.1)))
            .padding(.bottom, 24)
            
            // Step Indicators
            stepIndicator
            
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
    }
    
    // MARK: - Step Indicator
    
    private var stepIndicator: some View {
        HStack(spacing: 12) {
            stepDot(number: 1, label: "Review", isActive: currentStep >= 1)
            Spacer()
            stepDot(number: 2, label: "Synthesize", isActive: currentStep >= 2)
            Spacer()
            stepDot(number: 3, label: "Frame", isActive: currentStep >= 3)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 32)
    }
    
    private func stepDot(number: Int, label: String, isActive: Bool) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isActive ? Color.thresh.idea : Color.thresh.surfaceSecondary)
                .frame(width: 40, height: 40)
                .overlay(
                    Text("\(number)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isActive ? .white : Color.thresh.textTertiary)
                )
            
            if currentStep == number {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.thresh.idea)
            }
        }
    }
    
    // MARK: - Step 1: Review
    
    private var reviewStep: some View {
        VStack(spacing: 16) {
            if recentWeeklies.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select weekly syntheses to include")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.thresh.textPrimary)
                            
                            Text("A season has passed. Choose the weeks that feel significant or connected.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.thresh.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Weekly Synthesis List
                        ForEach(recentWeeklies) { weekly in
                            WeeklySynthesisRow(
                                reflection: weekly,
                                isSelected: selectedWeeklies.contains(weekly.id),
                                onToggle: { toggleSelection(weekly.id) }
                            )
                        }
                        
                        Color.clear.frame(height: 100)
                    }
                }
            }
            
            Spacer()
            
            // Next Button
            SaveButton(
                title: "Continue to Synthesize (\(selectedWeeklies.count))",
                isEnabled: !selectedWeeklies.isEmpty,
                action: { withAnimation { currentStep = 2 } },
                theme: .orange
            )
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundColor(Color.thresh.textTertiary)
                .padding(.vertical, 20)
            
            Text("No weekly syntheses yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.thresh.textPrimary)
            
            Text("Quarterly reflection builds on weekly syntheses. Create weekly reflections first to have material for deeper seasonal patterns.")
                .font(.system(size: 16))
                .foregroundColor(Color.thresh.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Back to Home")
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
    
    // MARK: - Step 2: Synthesize
    
    private var writeStep: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(spacing: 16) {
                    // Synthesis Prompt
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color.thresh.idea)
                            
                            Text("SEASONAL SYNTHESIS PROMPT")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.thresh.idea)
                        }
                        
                        Text("If this season were a chapter in your life, what would it be called? What question or tension does it contain?")
                            .font(.system(size: 16))
                            .foregroundColor(Color.thresh.textSecondary)
                            .italic()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.thresh.idea.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.thresh.idea.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Text Editor
                    ZStack(alignment: .topLeading) {
                        if synthesisText.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Write your quarterly synthesis...")
                                    .foregroundColor(Color.thresh.textTertiary)
                                    .font(.system(size: 16))
                                
                                Text("What's the arc of this season? What's shifting?")
                                    .foregroundColor(Color.thresh.textTertiary.opacity(0.7))
                                    .font(.system(size: 14))
                            }
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $synthesisText)
                            .foregroundColor(Color.thresh.textPrimary)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 300)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.thresh.surface))
                    .padding(.horizontal, 20)
                    
                    Color.clear.frame(height: 100)
                }
            }
            
            Spacer()
            
            // Navigation Buttons
            HStack(spacing: 12) {
                Button(action: { withAnimation { currentStep = 1 } }) {
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
                    title: "Continue to Frame",
                    isEnabled: !synthesisText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    action: { withAnimation { currentStep = 3 } },
                    theme: .orange
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Step 3: Cultural Framing (Autoethnographic)
    
    private var refineStep: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(spacing: 16) {
                    // Instructions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Optional: Cultural framing")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.thresh.textPrimary)
                        
                        Text("You can save now, or add an autoethnographic layer by exploring how larger cultural patterns shaped this season.")
                            .font(.system(size: 14))
                            .foregroundColor(Color.thresh.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Reveal Cultural Framing Button
                    if !showCulturalPrompt {
                        Button(action: { withAnimation { showCulturalPrompt = true } }) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text("Reveal Cultural Framing Prompt")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(RoundedRectangle(cornerRadius: 24).fill(Color.thresh.reflect))
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Cultural Framing Prompt (when revealed)
                    if showCulturalPrompt {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.thresh.reflect)
                                
                                Text("AUTOETHNOGRAPHIC PROMPT")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.thresh.reflect)
                            }
                            
                            Text("What larger patterns—cultural, professional, generational—does this quarter illuminate? How is your experience shaped by forces beyond yourself?")
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
                        
                        // Cultural Framing Text Editor
                        ZStack(alignment: .topLeading) {
                            if culturalFramingText.isEmpty {
                                Text("Explore the cultural context...")
                                    .foregroundColor(Color.thresh.textTertiary)
                                    .font(.system(size: 16))
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                            
                            TextEditor(text: $culturalFramingText)
                                .foregroundColor(Color.thresh.textPrimary)
                                .font(.system(size: 16))
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 200)
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.thresh.surface))
                        .padding(.horizontal, 20)
                    }
                    
                    Color.clear.frame(height: 100)
                }
            }
            
            Spacer()
            
            // Navigation Buttons
            HStack(spacing: 12) {
                Button(action: { withAnimation { currentStep = 2 } }) {
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
                    title: "Save Quarterly Synthesis",
                    isEnabled: true,
                    action: saveQuarterlySynthesis,
                    theme: .orange
                )
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Helper Functions
    
    private func toggleSelection(_ id: UUID) {
        if selectedWeeklies.contains(id) {
            selectedWeeklies.remove(id)
        } else {
            selectedWeeklies.insert(id)
        }
    }
    
    // MARK: - Save Function
    
    private func saveQuarterlySynthesis() {
        let trimmedSynthesis = synthesisText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSynthesis.isEmpty else { return }
        
        // Get selected weeklies
        let selected = recentWeeklies.filter { selectedWeeklies.contains($0.id) }
        
        // Combine weekly syntheses for context
        let combinedSyntheses = selected
            .map { $0.synthesisContent ?? $0.captureContent }
            .joined(separator: "\n\n---\n\n")
        
        // Add cultural framing if present
        let finalSynthesis = if !culturalFramingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            trimmedSynthesis + "\n\n[Cultural Context]\n" + culturalFramingText
        } else {
            trimmedSynthesis
        }
        
        // Create quarterly synthesis
        let quarterlySynthesis = Reflection(
            captureContent: combinedSyntheses,
            synthesisContent: finalSynthesis,
            entryType: .synthesis,
            tier: .yearly,  // Using .yearly for quarterly (or add .quarterly to enum)
            modeBalance: .synthesisOnly,
            linkedReflections: selected
        )
        
        modelContext.insert(quarterlySynthesis)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            // Handle save error silently
        }
    }
}

// MARK: - Weekly Synthesis Row Component

struct WeeklySynthesisRow: View {
    let reflection: Reflection
    let isSelected: Bool
    let onToggle: () -> Void
    
    private var weekRange: String {
        let calendar = Calendar.current
        let endDate = reflection.createdAt
        let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) ?? endDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                // Checkbox
                Circle()
                    .strokeBorder(isSelected ? Color.thresh.idea : Color.thresh.textTertiary, lineWidth: 2)
                    .background(Circle().fill(isSelected ? Color.thresh.idea : Color.clear))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(weekRange)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.thresh.textPrimary)
                        
                        Spacer()
                        
                        Text("WEEKLY")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color.thresh.synthesis)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(Color.thresh.synthesis.opacity(0.1))
                            )
                    }
                    
                    if let synthesis = reflection.synthesisContent {
                        Text(synthesis)
                            .font(.system(size: 14))
                            .foregroundColor(Color.thresh.textSecondary)
                            .lineLimit(2)
                    }
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
                                isSelected ? Color.thresh.idea.opacity(0.4) : Color.clear,
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
    QuarterlyReflectionScreen()
        .modelContainer(for: [Reflection.self], inMemory: true)
}
