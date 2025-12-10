# Claude Code Context for Thresh

This file provides context for Claude Code when working on the Thresh iOS app.

---

## Project Overview

**Thresh** is a reflection journaling app that trains observation before interpretation. The core philosophy is that observation (staying with what happened) is harder than interpretation (deciding what it means), so the app enforces capture-first workflows.

---

## Key Files

### App Entry
- `Thresh/ThreshApp.swift` - Main app entry point
- `Thresh/ContentView.swift` - Root view with onboarding check
- `Thresh/Models/AppState.swift` - Observable app state

### Core Screens
- `Thresh/Views/Screens/HomeScreen.swift` - Main navigation hub
- `Thresh/Views/Screens/NewReflectionScreen.swift` - Capture-first entry flow
- `Thresh/Views/Screens/WeeklyReflectionScreen.swift` - Synthesis with AI patterns
- `Thresh/Views/Screens/PatternsScreen.swift` - Connection visualization
- `Thresh/Views/Screens/OnboardingScreen.swift` - First-launch flow
- `Thresh/Views/Screens/SettingsScreen.swift` - Settings and data management

### AI Service
- `Thresh/Services/AI/AIService.swift` - Claude API + NLP embeddings
  - `extractFromReflection()` - Claude-powered extraction
  - `detectConnections()` - Hybrid keyword + semantic detection
  - `computeEmbedding()` - On-device NLP vectors
  - `cosineSimilarity()` - Vector similarity calculation

### Data Models
- `Thresh/Models/Reflection.swift`
- `Thresh/Models/Story.swift` - Has `source: QuestionSource` property
- `Thresh/Models/Idea.swift` - Has `source: QuestionSource` property
- `Thresh/Models/Question.swift`
- `Thresh/Models/Connection.swift` - Computed, not persisted

### Components
- `Thresh/Views/Components/FeatureTooltip.swift` - Dismissible education
- `Thresh/Views/Components/ExtractionReviewModal.swift` - Accept/reject extracted items
- `Thresh/Views/Components/ReflectionRow.swift` - Row with marinating toggle

### Services
- `Thresh/Services/Export/ExportService.swift` - JSON export/import
- `Thresh/Services/Prompts/PromptLibrary.swift` - Prompt management
- `Thresh/Services/DesignNotes/DesignNotesService.swift` - Philosophy notes

---

## Completed Features

### Core
- [x] Reflection capture with optional synthesis
- [x] Weekly/Quarterly synthesis flows
- [x] Four content types: Reflections, Stories, Ideas, Questions
- [x] 11 focus types for categorization
- [x] Marinating system (flag to revisit)
- [x] Archive and Recently Deleted

### AI
- [x] Claude API extraction (stories, ideas, questions)
- [x] Extraction review modal
- [x] Connection detection (keyword + semantic)
- [x] On-device NLP embeddings (NaturalLanguage framework)
- [x] Weekly synthesis AI pattern suggestions

### UX
- [x] First-launch onboarding (5 pages)
- [x] Feature tooltips at discovery moments
- [x] Source tracking (user-created vs extracted)
- [x] JSON export/import
- [x] View Onboarding Again in Settings

---

## Code Patterns

### Color System
```swift
Color.thresh.capture      // Blue - for Capture Mode
Color.thresh.synthesis    // Purple/Orange - for Synthesis Mode
Color.thresh.textPrimary  // Main text
Color.thresh.textSecondary // Secondary text
```

### Environment
```swift
@Environment(\.modelContext) private var modelContext
@Environment(AppState.self) private var appState
```

### AI Service Usage
```swift
// Extraction
let result = try await AIService.shared.extractFromReflection(text)

// Connection detection
let connections = await AIService.shared.detectConnections(in: reflections)
```

### Feature Tooltips
```swift
@State private var showTooltip = true

.featureTooltip(
    title: "Feature Name",
    message: "Explanation text",
    featureKey: "unique_key",
    isPresented: $showTooltip
)
```

---

## Build Command

```bash
xcodebuild -scheme "Thresh Life" -destination 'platform=iOS Simulator,name=iPhone 17' build
```

---

## Important Principles

1. **Two Modes** - Capture (📷) before Synthesis (🔮) is non-negotiable
2. **AI Extracts, Never Writes** - AI surfaces patterns from user's words
3. **Observation First** - The harder skill gets trained first
4. **Source Tracking** - Always track where content originated
5. **Dismissible Education** - Tooltips can be permanently dismissed

---

## Common Tasks

### Add a new tooltip
1. Add `@State private var showTooltip = true` to view
2. Apply `.featureTooltip()` modifier with unique `featureKey`
3. Tooltip uses `@AppStorage("tooltip_dismissed_\(featureKey)")` for persistence

### Add source tracking to a model
1. Add `var source: QuestionSource` property
2. Update initializers with default `.userCreated`
3. Set `.extractedFromReflection` when saving from extraction modal

### Modify connection detection
1. Edit `AIService.detectConnections(in:)`
2. First pass: keyword matching
3. Second pass: NLP embeddings (90-day window)
4. Adjust `semanticThreshold` (currently 0.65)

---

## File Structure

```
Thresh/
├── ThreshApp.swift
├── ContentView.swift
├── Models/
│   ├── AppState.swift
│   ├── Reflection.swift
│   ├── Story.swift
│   ├── Idea.swift
│   ├── Question.swift
│   └── Connection.swift
├── Views/
│   ├── Screens/
│   │   ├── HomeScreen.swift
│   │   ├── NewReflectionScreen.swift
│   │   ├── WeeklyReflectionScreen.swift
│   │   ├── PatternsScreen.swift
│   │   ├── OnboardingScreen.swift
│   │   └── SettingsScreen.swift
│   └── Components/
│       ├── FeatureTooltip.swift
│       ├── ExtractionReviewModal.swift
│       └── ReflectionRow.swift
└── Services/
    ├── AI/
    │   └── AIService.swift
    ├── Export/
    │   └── ExportService.swift
    └── Prompts/
        └── PromptLibrary.swift
```
