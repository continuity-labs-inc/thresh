import SwiftUI

struct HabitIntentionSheet: View {
    @Binding var isPresented: Bool
    @State private var intention: String = ""
    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Is there something you're working on?")
                    .font(.headline)
                    .foregroundStyle(Color.thresh.textPrimary)

                Text("This will show up each time you reflect, as a reminder of what you said matters.")
                    .font(.subheadline)
                    .foregroundColor(Color.thresh.textSecondary)

                TextField("e.g., Move my body 3x/week", text: $intention)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 8)

                Spacer()
            }
            .padding()
            .navigationTitle("Set Intention")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(intention)
                        isPresented = false
                    }
                    .disabled(intention.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    HabitIntentionSheet(
        isPresented: .constant(true),
        onSave: { _ in }
    )
}
