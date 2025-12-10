# Thresh — Swift iOS App

**A reflection journaling app that trains observation before interpretation**

## Core Philosophy

**The Central Insight:** Observation is exponentially harder than interpretation.

Most apps treat interpretation as the "advanced" skill. This is backwards. Interpretation is easy—we do it automatically. Observation (staying with what happened without sliding into meaning) requires discipline.

**The Two Modes:**

| Mode | Symbol | Purpose |
|------|--------|---------|
| **Capture** | 📷 | Record what happened (sensory, specific, judgment-free) |
| **Synthesis** | 🔮 | Find what it means (interpretive, connective, questioning) |

These aren't levels—they're different cognitive activities. The app trains both, starting with the harder skill first.

## Current State

**v1.0 Feature Set: Complete**

The app is fully functional in Swift/SwiftUI with:

### Core Features
- Reflection capture system (daily → weekly → monthly → quarterly → yearly)
- 11 focus types for categorizing entries
- Prompt library with 150+ narrative-focused prompts
- Marinating system (flag reflections to revisit later)
- Four content lenses: Reflections, Stories, Ideas, Questions

### AI Features
- **AI Extraction** - Claude-powered extraction of stories, ideas, and questions from reflection text
- **Connection Detection** - Hybrid approach using keyword matching + on-device NLP embeddings (Apple NaturalLanguage framework)
- **Semantic Similarity** - Detects thematic connections even when entries share no keywords

### Patterns & Synthesis
- **Patterns Screen** - View AI-detected connections between reflections
- **Weekly Synthesis** - AI-powered pattern detection during synthesis flow
- **Quarterly Synthesis** - Long-term pattern aggregation

### User Experience
- **First-Launch Onboarding** - 5-page swipeable introduction to app philosophy
- **Feature Tooltips** - Dismissible education system for feature discovery
- **Source Tracking** - All content types (Story, Idea, Question) track origin (user-created vs extracted)

### Data Management
- **Export** - Full JSON backup of all data
- **Import** - Restore from backup with duplicate detection
- **Recently Deleted** - 30-day soft delete with recovery option

## Technical Stack

```
SwiftUI + SwiftData
├── State: @Observable / Observation framework
├── Persistence: SwiftData + CloudKit (future)
├── AI: Claude Sonnet 4 (extraction) + Apple NaturalLanguage (on-device NLP)
├── Concurrency: Swift async/await
└── UI: Native SwiftUI components
```

## Key Design Principles

### 1. Capture-First Flow
Daily entries **require** observation before offering interpretation:
1. Focus selection (optional)
2. Capture prompt + text input (REQUIRED)
3. Choice: "Save Capture Only" OR "Add Interpretation"
4. If interpreting: Synthesis prompt + text (OPTIONAL)
5. Save → AI question extraction

**Critical:** "Save Capture Only" is prominent, not a fallback. Pure captures are complete entries.

### 2. AI Philosophy
AI extracts and surfaces—it never writes:
- ✓ Extracts questions from user's words
- ✓ Surfaces connections between entries  
- ✓ Provides feedback on capture quality
- ✗ Never generates content for users
- ✗ Never rewrites or "improves" text

### 3. Neurodiverse-First
Designed for ADHD/variable attention:
- **Reduce initiation friction:** Prompt-first, never blank page
- **Compensate for time blindness:** "Time since" indicators, pattern surfacing
- **Accommodate inconsistency:** No punitive streaks, "welcome back" messaging
- **Support variable energy:** Quick Capture for low-energy days

### 4. Temporal Hierarchy

```
Daily (70% capture, 30% interpretation)
  ↓ aggregates to
Weekly (review + synthesis)
  ↓ aggregates to  
Monthly → Quarterly → Yearly
```

Each tier provides appropriate distance for pattern recognition.

## Data Models (SwiftData)

### Core Models
```swift
@Model class Reflection {
    var id: UUID
    var tier: ReflectionTier  // daily, weekly, monthly, quarterly, yearly
    var focusType: FocusType?  // event, person, place, etc.
    var captureContent: String  // What happened (observation)
    var synthesisContent: String?  // What it means (optional!)
    var entryType: EntryType  // pureCapture, groundedReflection, synthesis
    var modeBalance: ModeBalance
    @Relationship var revisionLayers: [RevisionLayer]
    @Relationship var extractedQuestions: [ExtractedQuestion]
}

@Model class Story { /* narrative stories */ }
@Model class Idea { /* quick ideas */ }
@Model class Question { /* user-saved questions */ }
```

## Prompt System

Prompts are mode-specific and stage-adaptive:

**Capture Prompts** (the hard skill):
- "Describe the scene like a camera would record it"
- "What did you see, hear, smell, or feel?"
- "What was actually said? Try to recall exact words"

**Synthesis Prompts** (offered after capture):
- "Why did this stick with you?"
- "What assumption might you be making?"
- "What thread connects these moments?"

**Stage Adaptation:** Prompts adjust from high scaffolding (emerging writers) to minimal (fluent writers).

## Key Screens

### NewReflectionScreen (Most Important)
Enforces capture-before-synthesis:
1. **Capture Mode** (📷) - Description required
2. **Choice Point** - Save capture OR add interpretation
3. **Synthesis Mode** (🔮) - Interpretation optional
4. **Question Extraction** - AI surfaces questions from text

### WeeklyReflectionScreen
Synthesis flow with distance:
1. Review daily captures (7-day lookback)
2. Add "revision layers" (what do you see now?)
3. Write synthesis (NOT summary)

### HomeScreen
Quick actions + content tabs:
- New Reflection / Story / Idea / Question buttons
- Tabs for viewing recent entries by type
- Archive access (reflections only)

## Implementation Priorities

### Phase 1: Foundation ✓
- [x] Two Modes framework
- [x] SwiftData models
- [x] Prompt library
- [x] Design notes system

### Phase 2: Core Screens ✓
- [x] Home screen
- [x] Daily capture-first flow
- [x] Weekly synthesis flow

### Phase 3: AI Integration ✓
- [x] Story/Idea/Question extraction (Claude API)
- [x] Connection detection (keyword + semantic)
- [x] On-device NLP embeddings (NaturalLanguage framework)
- [x] Extraction review modal with accept/reject

### Phase 4: Polish ✓
- [x] First-launch onboarding
- [x] Feature tooltips for discovery
- [x] Export/Import functionality
- [x] Source tracking on all content types
- [x] Marinating system for reflections

### Phase 5: Future Enhancements
- [ ] Quick Capture widget
- [ ] CloudKit sync
- [ ] Theme Navigator
- [ ] Writing Growth Portrait

## Critical Development Notes

### String Handling
```swift
// ❌ BAD - causes build errors
let text = 'How\'s it going?'

// ✓ GOOD - use double quotes
let text = "How's it going?"
```

### Color System
```swift
extension Color {
    static let vm = VMColors()
}

struct VMColors {
    let capture = Color("CaptureColor")      // Blue - for Capture Mode
    let synthesis = Color("SynthesisColor")  // Purple - for Synthesis Mode
    // ... story, idea, question colors
}
```

### State Management
Use individual selectors to avoid infinite loops:
```swift
// ❌ BAD
let { reflections, addReflection } = useStore()

// ✓ GOOD  
let reflections = useReflectionStore(\.reflections)
let addReflection = useReflectionStore(\.addReflection)
```

## Design Notes System

Progressive disclosure of philosophy at key moments:
- **Two Modes** - First daily entry
- **Capture Complete** - First pure capture saved
- **Why Weekly Synthesis** - First aggregation
- **AI Philosophy** - First question extraction

Notes are brief (2-4 sentences), expandable, dismissable, and collected in Settings.

## File Structure

```
Thresh/
├── App/
│   ├── ThreshApp.swift
│   └── AppState.swift
├── Models/
│   └── ReflectionModels.swift
├── Views/
│   ├── Screens/
│   │   ├── HomeScreen.swift
│   │   ├── NewReflectionScreen.swift
│   │   ├── WeeklyReflectionScreen.swift
│   │   └── ...
│   └── Components/
├── Services/
│   ├── AI/
│   │   └── AIService.swift
│   ├── Prompts/
│   │   └── PromptLibrary.swift
│   └── DesignNotes/
│       └── DesignNotesService.swift
└── Resources/
    ├── PromptLibrary.json
    └── Assets.xcassets
```

## Recent Updates (December 2024)

- **On-Device NLP** - Added Apple NaturalLanguage framework for semantic similarity detection
- **Hybrid Connection Detection** - Combines keyword matching with NLP embeddings for better thematic connections
- **JSON Import** - Restore from backups with automatic duplicate detection
- **Feature Tooltips** - Dismissible education system at key discovery moments
- **First-Launch Onboarding** - 5-page introduction explaining Two Modes philosophy
- **Source Tracking** - Stories, Ideas, Questions now track whether user-created or AI-extracted

## Known Limitations

1. **No search** - Can't find entries by keyword (future enhancement)
2. **No CloudKit sync** - Data lives on device only (planned for future)
3. **English-only NLP** - Semantic similarity requires English text

## Development Workflow

1. Open Xcode project in Claude Code
2. Reference this README for context
3. Maintain Two Modes framework in all changes
4. Build with: `xcodebuild -scheme "Thresh Life" -destination 'platform=iOS Simulator,name=iPhone 17' build`

## One-Sentence Summary

Thresh trains users to observe before interpreting—the harder skill first—building genuine self-understanding through captured moments that aggregate into meaning over time.

---

**Critical Reminder:** The Two Modes framework (Capture 📷 before Synthesis 🔮) is not a feature—it's the foundation. Every design decision reinforces this distinction.
