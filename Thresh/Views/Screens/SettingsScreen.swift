import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var reflections: [Reflection]
    @Query private var stories: [Story]
    @Query private var ideas: [Idea]
    @Query private var questions: [Question]
    @Query(sort: \ActiveHabit.order) private var habits: [ActiveHabit]

    @State private var showShareSheet = false
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var showExportError = false
    @State private var showAddHabitSheet = false
    @State private var showEditHabitSheet = false
    @State private var habitToEdit: ActiveHabit?

    // Import state
    @State private var showingImportPicker = false
    @State private var showingImportResult = false
    @State private var importResult: ImportResult?
    @State private var importError: String?

    // Subscription state
    @State private var subscriptionService = SubscriptionService.shared
    @State private var showPaywall = false

    // Notification settings
    @AppStorage("notifications_dailyPrompt") private var dailyPromptEnabled = true
    @AppStorage("notifications_dailyPromptHour") private var dailyPromptHour = 20
    @AppStorage("notifications_dailyPromptMinute") private var dailyPromptMinute = 0
    @AppStorage("notifications_weeklySynthesis") private var weeklySynthesisEnabled = true
    @AppStorage("notifications_inactivity") private var inactivityEnabled = true
    @AppStorage("notifications_marinating") private var marinatingEnabled = true
    @State private var showTimePicker = false
    @State private var selectedTime = Date()

    private var activeReflectionsCount: Int {
        reflections.filter { $0.deletedAt == nil }.count
    }

    private var activeStoriesCount: Int {
        stories.filter { $0.deletedAt == nil }.count
    }

    private var activeIdeasCount: Int {
        ideas.filter { $0.deletedAt == nil }.count
    }

    private var activeQuestionsCount: Int {
        questions.filter { $0.deletedAt == nil }.count
    }

    private var isPlusOrAbove: Bool {
        subscriptionService.currentTier == .plus || subscriptionService.currentTier == .pro
    }

    var body: some View {
        List {
            // MARK: - Subscription Section
            Section {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Thresh \(subscriptionService.currentTier.displayName)")
                                    .font(.headline)
                                    .foregroundStyle(Color.thresh.textPrimary)

                                if subscriptionService.currentTier == .pro {
                                    ProFeatureBadge()
                                } else if subscriptionService.currentTier == .plus {
                                    PlusFeatureBadge()
                                }
                            }

                            if subscriptionService.currentTier == .free {
                                if let remaining = subscriptionService.remainingExtractions {
                                    Text("\(remaining) AI extractions remaining this month")
                                        .font(.caption)
                                        .foregroundStyle(Color.thresh.textSecondary)
                                }
                            } else {
                                Text("Unlimited AI extractions")
                                    .font(.caption)
                                    .foregroundStyle(Color.thresh.textSecondary)
                            }
                        }

                        Spacer()

                        if subscriptionService.currentTier == .free {
                            Text("Upgrade")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.thresh.synthesis)
                        } else {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textTertiary)
                        }
                    }
                }

                if subscriptionService.currentTier == .free {
                    Button {
                        Task {
                            await subscriptionService.restorePurchases()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundStyle(Color.thresh.textSecondary)
                            Text("Restore Purchases")
                                .foregroundStyle(Color.thresh.textPrimary)

                            Spacer()

                            if subscriptionService.isLoading {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(subscriptionService.isLoading)
                }
            } header: {
                Text("Subscription")
            }

            // MARK: - Notifications Section
            Section {
                Toggle(isOn: $dailyPromptEnabled) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundStyle(Color.thresh.capture)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Daily Prompt")
                                .foregroundStyle(Color.thresh.textPrimary)
                            Text(formatTime(hour: dailyPromptHour, minute: dailyPromptMinute))
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textSecondary)
                        }
                    }
                }
                .onChange(of: dailyPromptEnabled) { _, newValue in
                    updateDailyPromptNotification(enabled: newValue)
                }

                if dailyPromptEnabled {
                    Button {
                        selectedTime = timeFromComponents(hour: dailyPromptHour, minute: dailyPromptMinute)
                        showTimePicker = true
                    } label: {
                        HStack {
                            Text("Notification Time")
                                .foregroundStyle(Color.thresh.textPrimary)
                            Spacer()
                            Text(formatTime(hour: dailyPromptHour, minute: dailyPromptMinute))
                                .foregroundStyle(Color.thresh.textSecondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textTertiary)
                        }
                    }
                }

                Toggle(isOn: $weeklySynthesisEnabled) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color.thresh.synthesis)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Weekly Synthesis")
                                .foregroundStyle(Color.thresh.textPrimary)
                            Text("Sundays at 10am")
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textSecondary)
                        }
                    }
                }
                .onChange(of: weeklySynthesisEnabled) { _, newValue in
                    updateWeeklySynthesisNotification(enabled: newValue)
                }

                Toggle(isOn: $inactivityEnabled) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(Color.thresh.textSecondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Inactivity Reminder")
                                .foregroundStyle(Color.thresh.textPrimary)
                            Text("After 7 days of no captures")
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textSecondary)
                        }
                    }
                }
                .onChange(of: inactivityEnabled) { _, newValue in
                    updateInactivityNotification(enabled: newValue)
                }

                Toggle(isOn: $marinatingEnabled) {
                    HStack {
                        Image(systemName: "flame")
                            .foregroundStyle(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Marinating Reminders")
                                .foregroundStyle(Color.thresh.textPrimary)
                            Text("14 days after holding")
                                .font(.caption)
                                .foregroundStyle(Color.thresh.textSecondary)
                        }
                    }
                }
            } header: {
                Text("Notifications")
            } footer: {
                Text("Gentle reminders to support your reflection practice.")
            }

            Section {
                if isPlusOrAbove {
                    Button {
                        exportData()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(Color.thresh.capture)
                            Text("Export All Data (JSON)")
                                .foregroundStyle(Color.thresh.textPrimary)
                            Spacer()
                            if isExporting {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isExporting)
                } else {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(Color.thresh.textSecondary)
                            Text("Export All Data (JSON)")
                                .foregroundStyle(Color.thresh.textSecondary)
                            Spacer()
                            PlusFeatureBadge()
                        }
                    }
                }

                Button {
                    showingImportPicker = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(Color.thresh.synthesis)
                        Text("Import Data")
                            .foregroundStyle(Color.thresh.textPrimary)
                    }
                }
            } header: {
                Text("Backup")
            } footer: {
                Text("Export saves all your data as JSON. Import restores from a backup file, skipping duplicates.")
            }

            Section {
                dataRow(label: "Reflections", count: activeReflectionsCount)
                dataRow(label: "Stories", count: activeStoriesCount)
                dataRow(label: "Ideas", count: activeIdeasCount)
                dataRow(label: "Questions", count: activeQuestionsCount)
            } header: {
                Text("Your Data")
            }

            Section {
                ForEach(habits) { habit in
                    HStack {
                        Image(systemName: "flame")
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(habit.intention)
                                .foregroundStyle(Color.thresh.textPrimary)
                            if habit.isDefault {
                                Text("Default")
                                    .font(.caption)
                                    .foregroundColor(Color.thresh.textTertiary)
                            }
                        }
                        Spacer()
                        Text("\(habit.daysRemaining) days left")
                            .font(.caption)
                            .foregroundColor(Color.thresh.textSecondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        habitToEdit = habit
                        showEditHabitSheet = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteHabit(habit)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

                if habits.count < 2 {
                    Button {
                        showAddHabitSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(Color.thresh.capture)
                            Text("Add Habit")
                                .foregroundStyle(Color.thresh.textPrimary)
                        }
                    }
                }
            } header: {
                Text("Habits")
            } footer: {
                Text("Your active intention shows at the top of each reflection to remind you what matters.")
            }

            Section {
                NavigationLink(destination: RecentlyDeletedScreen()) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.thresh.textSecondary)
                        Text("Recently Deleted")
                    }
                }
            }

            Section {
                Button {
                    appState.hasCompletedOnboarding = false
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color.thresh.textSecondary)
                        Text("View Onboarding Again")
                            .foregroundStyle(Color.thresh.textPrimary)
                    }
                }
            }

            #if DEBUG
            Section {
                Picker("Debug Tier Override", selection: Binding(
                    get: { subscriptionService.debugTierOverride ?? .free },
                    set: { newTier in
                        if newTier == .free {
                            subscriptionService.debugTierOverride = nil
                        } else {
                            subscriptionService.debugTierOverride = newTier
                        }
                    }
                )) {
                    Text("None (Use Real)").tag(SubscriptionTier.free)
                    Text("Plus").tag(SubscriptionTier.plus)
                    Text("Pro").tag(SubscriptionTier.pro)
                }
                .pickerStyle(.menu)

                if subscriptionService.debugTierOverride != nil {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Debug override active: \(subscriptionService.currentTier.displayName)")
                            .font(.caption)
                            .foregroundStyle(Color.thresh.textSecondary)
                    }
                }
            } header: {
                Text("Debug Options")
            } footer: {
                Text("Override subscription tier for testing. Only visible in DEBUG builds.")
            }
            #endif
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            if let url = exportURL {
                ShareSheet(items: [url])
            }
        }
        .alert("Export Failed", isPresented: $showExportError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Unable to export data. Please try again.")
        }
        .fileImporter(
            isPresented: $showingImportPicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }

                guard url.startAccessingSecurityScopedResource() else {
                    importError = "Unable to access the selected file"
                    showingImportResult = true
                    return
                }
                defer { url.stopAccessingSecurityScopedResource() }

                do {
                    let data = try Data(contentsOf: url)
                    importResult = try ExportService.shared.importData(from: data, into: modelContext)
                    importError = nil
                    showingImportResult = true
                } catch {
                    importError = error.localizedDescription
                    importResult = nil
                    showingImportResult = true
                }

            case .failure(let error):
                importError = error.localizedDescription
                showingImportResult = true
            }
        }
        .alert("Import Complete", isPresented: $showingImportResult) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = importError {
                Text("Import failed: \(error)")
            } else if let result = importResult {
                Text("Imported \(result.reflectionsImported) reflections, \(result.storiesImported) stories, \(result.ideasImported) ideas, \(result.questionsImported) questions. Skipped \(result.skipped) duplicates.")
            }
        }
        .sheet(isPresented: $showAddHabitSheet) {
            HabitIntentionSheet(
                isPresented: $showAddHabitSheet,
                onSave: { intention in
                    addHabit(intention: intention)
                }
            )
        }
        .sheet(isPresented: $showEditHabitSheet) {
            if let habit = habitToEdit {
                EditHabitSheet(
                    isPresented: $showEditHabitSheet,
                    habit: habit
                )
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallScreen()
        }
        .sheet(isPresented: $showTimePicker) {
            NavigationStack {
                DatePicker(
                    "Select Time",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .navigationTitle("Daily Prompt Time")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showTimePicker = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
                            dailyPromptHour = components.hour ?? 20
                            dailyPromptMinute = components.minute ?? 0
                            updateDailyPromptNotification(enabled: dailyPromptEnabled)
                            showTimePicker = false
                        }
                    }
                }
            }
            .presentationDetents([.height(300)])
        }
    }

    private func addHabit(intention: String) {
        let newHabit = ActiveHabit(
            intention: intention,
            isDefault: false,
            order: habits.count
        )
        modelContext.insert(newHabit)
        do {
            try modelContext.save()
        } catch {}
    }

    private func deleteHabit(_ habit: ActiveHabit) {
        modelContext.delete(habit)
        // If no habits remain, create default
        if habits.count <= 1 {
            let defaultHabit = ActiveHabit(
                intention: "Reflect 3 times this week",
                isDefault: true,
                order: 0
            )
            modelContext.insert(defaultHabit)
        }
        do {
            try modelContext.save()
        } catch {}
    }

    private func dataRow(label: String, count: Int) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.thresh.textPrimary)
            Spacer()
            Text("\(count)")
                .foregroundStyle(Color.thresh.textSecondary)
        }
    }

    // MARK: - Notification Helpers

    private func formatTime(hour: Int, minute: Int) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let date = Calendar.current.date(from: components) ?? Date()
        return formatter.string(from: date)
    }

    private func timeFromComponents(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }

    private func updateDailyPromptNotification(enabled: Bool) {
        Task { @MainActor in
            if enabled {
                NotificationService.shared.scheduleDailyPrompt(at: dailyPromptHour, minute: dailyPromptMinute)
            } else {
                NotificationService.shared.cancelDailyPrompt()
            }
        }
    }

    private func updateWeeklySynthesisNotification(enabled: Bool) {
        Task { @MainActor in
            if enabled {
                let thisWeekReflections = reflections.filter { reflection in
                    guard reflection.deletedAt == nil else { return false }
                    let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
                    return reflection.createdAt > weekAgo
                }
                NotificationService.shared.scheduleWeeklySynthesisReminder(captureCount: thisWeekReflections.count)
            } else {
                NotificationService.shared.cancelWeeklySynthesis()
            }
        }
    }

    private func updateInactivityNotification(enabled: Bool) {
        Task { @MainActor in
            if enabled {
                NotificationService.shared.scheduleInactivityReminder(afterDays: 7)
            } else {
                NotificationService.shared.cancelInactivityReminder()
            }
        }
    }

    private func exportData() {
        isExporting = true

        // Capture data on main thread before async work
        let reflectionsToExport = reflections
        let storiesToExport = stories
        let ideasToExport = ideas
        let questionsToExport = questions

        Task {
            let result = await Task.detached { () -> Result<URL, Error> in
                guard let data = ExportService.shared.exportAllData(
                    reflections: reflectionsToExport,
                    stories: storiesToExport,
                    ideas: ideasToExport,
                    questions: questionsToExport
                ) else {
                    return .failure(NSError(domain: "ExportService", code: 1))
                }

                let filename = ExportService.shared.generateFilename()
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

                do {
                    try data.write(to: tempURL)
                    return .success(tempURL)
                } catch {
                    return .failure(error)
                }
            }.value

            isExporting = false
            switch result {
            case .success(let url):
                exportURL = url
                showShareSheet = true
            case .failure:
                showExportError = true
            }
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        SettingsScreen()
    }
    .environment(AppState())
    .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self, ActiveHabit.self], inMemory: true)
}
