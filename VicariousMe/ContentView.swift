import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var designNotesService: DesignNotesService?
    
    var body: some View {
        Group {
            if let service = designNotesService {
                HomeScreen()
                    .environment(service)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if designNotesService == nil {
                designNotesService = DesignNotesService(modelContext: modelContext)
            }
        }
    }
}
