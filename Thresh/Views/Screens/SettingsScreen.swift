import SwiftUI
import SwiftData

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var reflections: [Reflection]
    @Query private var stories: [Story]
    @Query private var ideas: [Idea]
    @Query private var questions: [Question]

    @State private var showShareSheet = false
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var showExportError = false

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
            } header: {
                Text("Backup")
            } footer: {
                Text("Exports all reflections, stories, ideas, and questions as a JSON file.")
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
    .modelContainer(for: [Reflection.self, Story.self, Idea.self, Question.self], inMemory: true)
}
