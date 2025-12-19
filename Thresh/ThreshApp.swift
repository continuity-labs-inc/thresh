import SwiftUI
import SwiftData

@main
struct ThreshApp: App {
    private let promptLibrary = PromptLibrary()
    private let isUITesting = CommandLine.arguments.contains("-uitesting")

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reflection.self,
            Story.self,
            Idea.self,
            Question.self,
            ActiveHabit.self,
        ])

        // Use in-memory storage for UI testing to ensure clean state with demo data
        let isUITesting = CommandLine.arguments.contains("-uitesting")
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isUITesting
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        // Verify API key is configured on launch
        let apiKey = Secrets.anthropicAPIKey
        if apiKey.isEmpty {
            print("❌ CRITICAL: Anthropic API key is empty! AI features will not work.")
        } else if apiKey.hasPrefix("sk-ant-") {
            print("✅ Anthropic API key configured: \(String(apiKey.prefix(15)))...")
        } else {
            print("⚠️ WARNING: API key doesn't start with 'sk-ant-', may be invalid: \(String(apiKey.prefix(10)))...")
        }

        if isUITesting {
            print("🧪 UI Testing mode enabled - using demo data")
            // Skip onboarding for UI tests
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(promptLibrary)
                .onAppear {
                    if isUITesting {
                        seedDemoData()
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }

    /// Seeds the database with attractive demo data for App Store screenshots
    private func seedDemoData() {
        let context = sharedModelContainer.mainContext

        // Check if demo data already exists
        let existingReflections = try? context.fetch(FetchDescriptor<Reflection>())
        guard existingReflections?.isEmpty ?? true else { return }

        print("📸 Seeding demo data for screenshots...")

        // Create reflections with varied dates
        let now = Date()
        let calendar = Calendar.current

        // Reflection 1 - Today (marinating)
        let reflection1 = Reflection(
            captureContent: "Had a long conversation with Dad today about his childhood. He told me stories I'd never heard before—about growing up on the farm, the summers with his cousins, and why he became an engineer. I felt like I was meeting him for the first time.",
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly,
            reflectionNumber: 1
        )
        reflection1.createdAt = calendar.date(byAdding: .hour, value: -3, to: now) ?? now
        reflection1.marinating = true
        context.insert(reflection1)

        // Reflection 2 - Yesterday
        let reflection2 = Reflection(
            captureContent: "Morning run through the park. The fog was so thick I could barely see the path. Something about not knowing what was ahead felt strangely comforting. Just me and my footsteps.",
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly,
            reflectionNumber: 2
        )
        reflection2.createdAt = calendar.date(byAdding: .day, value: -1, to: now) ?? now
        context.insert(reflection2)

        // Reflection 3 - 2 days ago
        let reflection3 = Reflection(
            captureContent: "Realized I've been avoiding calling my sister. Not sure why. We used to talk every week. When did that change? Maybe I'm afraid of what she might tell me about herself. Or what I might have to tell her about me.",
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly,
            reflectionNumber: 3
        )
        reflection3.createdAt = calendar.date(byAdding: .day, value: -2, to: now) ?? now
        context.insert(reflection3)

        // Reflection 4 - 3 days ago
        let reflection4 = Reflection(
            captureContent: "Finished the book on Stoicism. The idea that stuck: you can't control what happens, only how you respond. Spent the rest of the day noticing all the tiny things I try to control.",
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly,
            reflectionNumber: 4
        )
        reflection4.createdAt = calendar.date(byAdding: .day, value: -3, to: now) ?? now
        context.insert(reflection4)

        // Reflection 5 - 5 days ago
        let reflection5 = Reflection(
            captureContent: "Watched the sunset from the balcony. The colors reminded me of the painting in Grandma's house—the one she said she bought on her honeymoon. I should ask Mom if we still have it.",
            entryType: .pureCapture,
            tier: .active,
            modeBalance: .captureOnly,
            reflectionNumber: 5
        )
        reflection5.createdAt = calendar.date(byAdding: .day, value: -5, to: now) ?? now
        context.insert(reflection5)

        // Story 1 - Extracted
        let story1 = Story(
            title: "Dad's Summer on the Farm",
            content: "When Dad was twelve, he spent an entire summer at his uncle's farm in Iowa. He learned to drive the tractor, helped with the harvest, and got his first glimpse of the night sky without city lights. He says that summer is when he fell in love with the stars—and why he later became an aerospace engineer.",
            linkedReflectionIds: [reflection1.id],
            source: .extractedFromReflection
        )
        story1.createdAt = calendar.date(byAdding: .hour, value: -2, to: now) ?? now
        context.insert(story1)

        // Story 2 - User created
        let story2 = Story(
            title: "The Morning I Decided to Run",
            content: "Three years ago, I couldn't run a mile. I remember standing at the edge of the park, watching joggers pass by, and feeling like they knew something I didn't. So I started walking. Then jogging. Then running. Now the park is where I do my best thinking."
        )
        story2.createdAt = calendar.date(byAdding: .day, value: -4, to: now) ?? now
        context.insert(story2)

        // Idea 1 - Extracted
        let idea1 = Idea(
            title: "Weekly Family Story Night",
            details: "Record conversations with family members about their memories. Start with Dad, then Mom, then grandparents while we still can. Create a family archive of stories before they're lost.",
            category: "Family",
            linkedReflectionIds: [reflection1.id],
            source: .extractedFromReflection
        )
        idea1.createdAt = calendar.date(byAdding: .hour, value: -1, to: now) ?? now
        context.insert(idea1)

        // Idea 2 - User created
        let idea2 = Idea(
            title: "Morning Pages Experiment",
            details: "Try writing three pages every morning before looking at my phone. Julia Cameron's technique from The Artist's Way. Commit to 30 days.",
            category: "Habits"
        )
        idea2.createdAt = calendar.date(byAdding: .day, value: -3, to: now) ?? now
        context.insert(idea2)

        // Question 1 - Extracted
        let question1 = Question(
            text: "When did my sister and I stop talking every week?",
            context: "Noticing a pattern of avoidance with family connections",
            source: .extractedFromReflection,
            linkedReflectionIds: [reflection3.id]
        )
        question1.createdAt = calendar.date(byAdding: .day, value: -2, to: now) ?? now
        context.insert(question1)

        // Question 2 - Extracted
        let question2 = Question(
            text: "What small things do I try to control that I should let go of?",
            context: "From the Stoicism reading",
            source: .extractedFromReflection,
            linkedReflectionIds: [reflection4.id]
        )
        question2.createdAt = calendar.date(byAdding: .day, value: -3, to: now) ?? now
        context.insert(question2)

        // Question 3 - User created
        let question3 = Question(
            text: "What would I do differently if I weren't afraid of failure?",
            context: nil
        )
        question3.createdAt = calendar.date(byAdding: .day, value: -6, to: now) ?? now
        context.insert(question3)

        // Default habit
        let habit = ActiveHabit(
            intention: "Capture 3 moments this week",
            isDefault: true,
            order: 0
        )
        context.insert(habit)

        do {
            try context.save()
            print("✅ Demo data seeded successfully")
        } catch {
            print("❌ Failed to seed demo data: \(error)")
        }
    }
}
