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

    @State private var showShareSheet = false
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var showExportError = false

    // Import state
    @State private var showingImportPicker = false
    @State private var showingImportResult = false
    @State private var importResult: ImportResult?
    @State private var importError: String?

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

    var body: some View {
        List {
            Section {
                Button {
                    exportData()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Color.thresh.capture)
                        Text("Export All Data")
                            .foregroundStyle(Color.thresh.textPrimary)
                        Spacer()
                        if isExporting {
                            ProgressView()
                        }
                    }
                }
                .disabled(isExporting)

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

    private func exportData() {
        isExporting = true

        // Capture data on main thread before async work
        let reflectionsToExport = reflections
        let storiesToExport = stories
        let ideasToExport = ideas
        let questionsToExport = questions

        Task.detached {
            guard let data = ExportService.shared.exportAllData(
                reflections: reflectionsToExport,
                stories: storiesToExport,
                ideas: ideasToExport,
                questions: questionsToExport
            ) else {
                await MainActor.run {
                    isExporting = false
                    showExportError = true
                }
                return
            }

            let filename = ExportService.shared.generateFilename()
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

            do {
                try data.write(to: tempURL)
                await MainActor.run {
                    isExporting = false
                    exportURL = tempURL
                    showShareSheet = true
                }
            } catch {
                await MainActor.run {
                    isExporting = false
                    showExportError = true
                }
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
    .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
}
