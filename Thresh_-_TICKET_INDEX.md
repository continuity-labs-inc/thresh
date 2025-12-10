# THRESH — TICKET INDEX

## Updated: December 2024

This document tracks implementation tickets for the Thresh iOS app.

---

## SUMMARY

| Category | Complete | In Progress | Pending | Total |
|----------|----------|-------------|---------|-------|
| Foundation (T1-T2) | 12 | 0 | 0 | 12 |
| Core Screens (T3-T5) | 18 | 0 | 0 | 18 |
| AI Integration (T6-T8) | 14 | 0 | 0 | 14 |
| Patterns & Synthesis (T9-T11) | 10 | 0 | 0 | 10 |
| UX Polish (T12-T14) | 16 | 0 | 0 | 16 |
| **TOTAL** | **70** | **0** | **0** | **70** |

**Completion Rate: 100%** (v1.0 Feature Complete)

---

## T1: DATA MODELS

### T1.1: Core Models
- [x] T1.1.1: Reflection model with capture/synthesis content — Complete
- [x] T1.1.2: Story model with source tracking — Complete
- [x] T1.1.3: Idea model with source tracking — Complete
- [x] T1.1.4: Question model with source tracking — Complete
- [x] T1.1.5: Connection model (computed, not persisted) — Complete

### T1.2: Enums & Types
- [x] T1.2.1: ReflectionTier enum (daily, weekly, monthly, quarterly, yearly) — Complete
- [x] T1.2.2: FocusType enum (11 focus types) — Complete
- [x] T1.2.3: QuestionSource enum (userCreated, extractedFromReflection) — Complete
- [x] T1.2.4: ConnectionType enum (thematic, questionAnswer, evolution) — Complete

---

## T2: NAVIGATION & STRUCTURE

### T2.1: App Structure
- [x] T2.1.1: ThreshApp entry point with ModelContainer — Complete
- [x] T2.1.2: ContentView with onboarding check — Complete
- [x] T2.1.3: AppState observable for app-wide state — Complete

---

## T3: CORE SCREENS

### T3.1: HomeScreen
- [x] T3.1.1: Tab-based navigation — Complete
- [x] T3.1.2: Quick action buttons (New Reflection, Story, Idea, Question) — Complete
- [x] T3.1.3: Content tabs for each type — Complete

### T3.2: NewReflectionScreen
- [x] T3.2.1: Focus type selection — Complete
- [x] T3.2.2: Capture-first flow — Complete
- [x] T3.2.3: Optional synthesis step — Complete
- [x] T3.2.4: Save with AI extraction trigger — Complete

### T3.3: Story/Idea/Question Screens
- [x] T3.3.1: NewStoryScreen — Complete
- [x] T3.3.2: NewIdeaScreen — Complete
- [x] T3.3.3: NewQuestionScreen — Complete

### T3.4: Detail Screens
- [x] T3.4.1: ReflectionDetailScreen — Complete
- [x] T3.4.2: StoryDetailScreen — Complete
- [x] T3.4.3: IdeaDetailScreen — Complete
- [x] T3.4.4: QuestionDetailScreen — Complete

### T3.5: Archive & Delete
- [x] T3.5.1: ArchiveScreen — Complete
- [x] T3.5.2: RecentlyDeletedScreen — Complete
- [x] T3.5.3: Soft delete with 30-day retention — Complete

### T3.6: AI Extraction Flow
- [x] T3.6.1: Auto-trigger extraction after save (50+ chars) — Complete
- [x] T3.6.2: Loading state during extraction — Complete
- [x] T3.6.3: ExtractionReviewModal component — Complete
- [x] T3.6.4: Save selected items with source tracking — Complete

---

## T4: SYNTHESIS SCREENS

### T4.1: Weekly Synthesis
- [x] T4.1.1: WeeklyReflectionScreen with step flow — Complete
- [x] T4.1.2: Entry selection (Step 1) — Complete
- [x] T4.1.3: Writing with AI patterns (Step 2) — Complete
- [x] T4.1.4: Review and save (Step 3) — Complete

### T4.2: Quarterly Synthesis
- [x] T4.2.1: QuarterlyReflectionScreen — Complete
- [x] T4.2.2: Long-term pattern aggregation — Complete

---

## T5: SETTINGS

### T5.1: Settings Screen
- [x] T5.1.1: SettingsScreen with data counts — Complete
- [x] T5.1.2: Export functionality — Complete
- [x] T5.1.3: Import functionality with duplicate detection — Complete
- [x] T5.1.4: Recently Deleted navigation — Complete
- [x] T5.1.5: View Onboarding Again button — Complete

---

## T6: AI SERVICE

### T6.1: Claude API Integration
- [x] T6.1.1: AIService actor with shared instance — Complete
- [x] T6.1.2: API key management (Secrets.swift) — Complete
- [x] T6.1.3: extractFromReflection() method — Complete
- [x] T6.1.4: JSON response parsing — Complete

### T6.2: Extraction Types
- [x] T6.2.1: ExtractionResult struct — Complete
- [x] T6.2.2: ExtractedStory, ExtractedIdea, ExtractedQuestion — Complete

---

## T7: CONNECTION DETECTION

### T7.1: Keyword-Based Detection
- [x] T7.1.1: detectConnections() method — Complete
- [x] T7.1.2: detectThematicConnection() — Complete
- [x] T7.1.3: detectQuestionAnswerConnection() — Complete
- [x] T7.1.4: detectEvolutionConnection() — Complete
- [x] T7.1.5: extractKeywords() with stop words — Complete

### T7.2: NLP-Based Detection
- [x] T7.2.1: NaturalLanguage framework import — Complete
- [x] T7.2.2: computeEmbedding() for sentence vectors — Complete
- [x] T7.2.3: cosineSimilarity() calculation — Complete
- [x] T7.2.4: Hybrid approach integration — Complete
- [x] T7.2.5: 90-day window optimization — Complete

---

## T8: EXTRACTION WIRING

### T8.1: Extraction UI
- [x] T8.1.1: ExtractionReviewModal view — Complete
- [x] T8.1.2: Accept/reject toggles for each item — Complete
- [x] T8.1.3: Keep Selected button — Complete

### T8.2: Integration
- [x] T8.2.1: Trigger extraction in NewReflectionScreen — Complete
- [x] T8.2.2: Wire extraction to save flow — Complete
- [x] T8.2.3: Save with source = .extractedFromReflection — Complete

---

## T9: PATTERNS SCREEN

### T9.1: PatternsScreen Structure
- [x] T9.1.1: PatternsScreen view — Complete
- [x] T9.1.2: Marinating section — Complete
- [x] T9.1.3: Connections section with AI detection — Complete
- [x] T9.1.4: Questions section with badges — Complete

### T9.2: Navigation
- [x] T9.2.1: Sparkles button on HomeScreen toolbar — Complete
- [x] T9.2.2: NavigationLink to PatternsScreen — Complete

---

## T10: CONTENT ROWS

### T10.1: Row Components
- [x] T10.1.1: ReflectionRow with marinating indicator — Complete
- [x] T10.1.2: StoryRow with extraction badge — Complete
- [x] T10.1.3: IdeaRow with extraction badge — Complete
- [x] T10.1.4: QuestionRow with extraction badge — Complete

---

## T11: WEEKLY SYNTHESIS AI

### T11.1: Pattern Suggestions
- [x] T11.1.1: suggestedConnections state in WeeklyReflectionScreen — Complete
- [x] T11.1.2: isAnalyzing loading state — Complete
- [x] T11.1.3: Trigger analysis on step transition — Complete
- [x] T11.1.4: "Patterns We Noticed" UI section — Complete

---

## T12: MARINATING SYSTEM

### T12.1: Marinating Feature
- [x] T12.1.1: marinating property on Reflection model — Complete
- [x] T12.1.2: Context menu toggle in ReflectionRow — Complete
- [x] T12.1.3: Visual indicator (flame icon) — Complete
- [x] T12.1.4: Marinating section in PatternsScreen — Complete

---

## T13: SOURCE TRACKING

### T13.1: Source Property
- [x] T13.1.1: source property on Story model — Complete
- [x] T13.1.2: source property on Idea model — Complete
- [x] T13.1.3: source property on Question model — Complete
- [x] T13.1.4: Extraction badge (↗) on rows — Complete

---

## T14: USER EDUCATION

### T14.1: Feature Tooltips
- [x] T14.1.1: FeatureTooltip component — Complete
- [x] T14.1.2: Tooltip integration at PatternsScreen — Complete
- [x] T14.1.3: Tooltip integration at ExtractionReviewModal — Complete
- [x] T14.1.4: Tooltip integration at WeeklyReflectionScreen — Complete
- [x] T14.1.5: Tooltip integration at ReflectionRow (marinating) — Complete
- [x] T14.1.6: "Don't show again" persistence — Complete

### T14.2: Onboarding
- [x] T14.2.1: OnboardingScreen with 5 pages — Complete
- [x] T14.2.2: hasCompletedOnboarding in AppState — Complete
- [x] T14.2.3: ContentView conditional rendering — Complete
- [x] T14.2.4: View Onboarding Again in Settings — Complete

### T14.3: Data Import
- [x] T14.3.1: ImportResult struct — Complete
- [x] T14.3.2: importData() method in ExportService — Complete
- [x] T14.3.3: File picker UI in SettingsScreen — Complete
- [x] T14.3.4: Duplicate detection logic — Complete

### T14.4: NLP Enhancement
- [x] T14.4.1: Apple NaturalLanguage import — Complete
- [x] T14.4.2: Word embedding computation — Complete
- [x] T14.4.3: Hybrid connection detection — Complete
- [x] T14.4.4: Semantic threshold tuning (0.65) — Complete

---

## FUTURE TICKETS (Post-v1.0)

### T15: Search
- [ ] T15.1.1: Full-text search across all content types
- [ ] T15.1.2: Search UI with filters
- [ ] T15.1.3: Recent searches

### T16: CloudKit Sync
- [ ] T16.1.1: CloudKit container setup
- [ ] T16.1.2: Sync logic for all models
- [ ] T16.1.3: Conflict resolution

### T17: Widgets
- [ ] T17.1.1: Quick Capture widget
- [ ] T17.1.2: Recent reflections widget

---

*Last updated: December 2024*
