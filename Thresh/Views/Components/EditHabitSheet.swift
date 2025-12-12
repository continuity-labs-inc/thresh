import SwiftUI
import SwiftData

struct EditHabitSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @Bindable var habit: ActiveHabit

    @State private var editedIntention: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Intention", text: $editedIntention)
                } header: {
                    Text("Intention")
                }

                Section {
                    HStack {
                        Text("Started")
                        Spacer()
                        Text(habit.startedAt.formatted(date: .abbreviated, time: .omitted))
                            .foregroundColor(Color.thresh.textSecondary)
                    }

                    HStack {
                        Text("Expires")
                        Spacer()
                        Text(habit.expiresAt.formatted(date: .abbreviated, time: .omitted))
                            .foregroundColor(Color.thresh.textSecondary)
                    }

                    HStack {
                        Text("Days Remaining")
                        Spacer()
                        Text("\(habit.daysRemaining)")
                            .foregroundColor(Color.thresh.textSecondary)
                    }

                    HStack {
                        Text("Check-ins This Week")
                        Spacer()
                        Text("\(habit.checkInCountThisWeek)")
                            .foregroundColor(Color.thresh.textSecondary)
                    }
                } header: {
                    Text("Details")
                }

                Section {
                    Button("Renew (39 more days)") {
                        renewHabit()
                    }
                    .foregroundColor(Color.thresh.capture)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(editedIntention.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                editedIntention = habit.intention
            }
        }
    }

    private func saveChanges() {
        let trimmed = editedIntention.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        habit.intention = trimmed
        habit.isDefault = false
        do {
            try modelContext.save()
        } catch {}
        isPresented = false
    }

    private func renewHabit() {
        habit.startedAt = Date()
        habit.expiresAt = Calendar.current.date(byAdding: .day, value: 39, to: Date()) ?? Date()
        do {
            try modelContext.save()
        } catch {}
        isPresented = false
    }
}

#Preview {
    EditHabitSheet(
        isPresented: .constant(true),
        habit: ActiveHabit(intention: "Move my body 3x/week")
    )
    .modelContainer(for: ActiveHabit.self, inMemory: true)
}
