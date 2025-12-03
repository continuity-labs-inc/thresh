# Vicarious Me — Swift iOS App

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

The app is ~95% functionally complete in Swift/SwiftUI with:
- Core reflection capture system (daily → weekly → monthly → quarterly → yearly)
- 11 focus types for categorizing entries
- Prompt library with 150+ narrative-focused prompts
- AI question extraction (extracts, never writes)
- Stacked aggregation flows

**Critical Issues:**
- Date serialization bug (Date → String after persistence)
- Inconsistent error handling for AI features
- Code duplication in aggregation components

## Technical Stack

```
SwiftUI + SwiftData
├── State: @Observable / Observation framework
├── Persistence: SwiftData + CloudKit (future)
├── AI: OpenAI GPT-4o (question extraction only)
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

### Phase 3: AI Integration (In Progress)
- [ ] Question extraction service
- [ ] Connection detection
- [ ] Capture quality assessment

### Phase 4: Enhancements
- [ ] Quick Capture mode
- [ ] Context Panel
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
VicariousMe/
├── App/
│   ├── VicariousMeApp.swift
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

## Additional Documentation

For complete details, see project knowledge files:
- **`VicariousMe_-_TECHNICAL___STRATEGIC_SPECIFICATION.md`** - Full product spec
- **`VicariousMe_Enhancement_Specification.md`** - Research-based enhancements
- **`VicariousMe_-_TICKET_INDEX.md`** - Implementation tickets
- **`Reflection_as_Cognitive_Architecture.md`** - Research foundation

## Known Gaps

1. **No editing/deleting** - Entries can't be modified after creation
2. **No search** - Can't find entries by keyword  
3. **Limited aggregation access** - Weekly/Monthly not reachable from Home
4. **AI error handling** - Inconsistent error states

## Development Workflow

1. Open Xcode project in Claude Code
2. Reference this README for context
3. Check TICKET_INDEX for specific tasks
4. Use Enhancement Spec for research-based features
5. Maintain Two Modes framework in all changes

## One-Sentence Summary

Vicarious Me trains users to observe before interpreting—the harder skill first—building genuine self-understanding through captured moments that aggregate into meaning over time.

---

**Critical Reminder:** The Two Modes framework (Capture 📷 before Synthesis 🔮) is not a feature—it's the foundation. Every design decision reinforces this distinction.
