# THRESH — CURRENT PROJECT STATE

## Updated: December 2024

---

## PROJECT STATUS: Ready for Public Launch

Thresh v1.0 is feature-complete and in TestFlight. All core functionality is implemented and working.

---

## WHAT'S WORKING

### Core Capture
- Daily reflection flow with focus type selection
- Story, Idea, and Question direct capture
- Refinement prompts (Bakhtinian, ethnographic)
- Marinating toggle via context menu and detail screen
- Soft delete with recovery

### AI Integration
- Claude API extraction after reflection save (50+ char threshold)
- ExtractionReviewModal for reviewing/keeping extracted items
- On-device NLP using Apple NaturalLanguage framework
- Hybrid connection detection (keyword + semantic similarity)
- Source tracking on Stories, Ideas, and Questions

### Patterns & Synthesis
- PatternsScreen accessible via sparkles button
- Marinating section showing flagged reflections
- Connections section with AI-detected thematic links
- Questions section with extraction badges
- Weekly synthesis with entry selection and AI pattern suggestions
- Quarterly synthesis flow

### User Experience
- First-launch onboarding (5 pages explaining app philosophy)
- FeatureTooltip system with "Don't show again" persistence
- Tooltips integrated at: PatternsScreen, ExtractionReviewModal, WeeklyReflectionScreen, ReflectionRow (marinating)
- Context menus for edit/delete/marinate actions

### Data Management
- JSON export from Settings
- JSON import with duplicate detection
- Soft delete pattern across all content types

---

## KNOWN LIMITATIONS

These are acknowledged gaps, not bugs:

1. **No full-text search** — Users cannot search across entries by keyword
2. **No CloudKit sync** — Data lives on-device only, no cross-device sync
3. **English-only NLP** — Semantic similarity uses English word embeddings
4. **No yearly synthesis** — Quarterly is the longest aggregation tier currently

---

## BUILD INFORMATION

- **Bundle ID:** com.continuitylabs.thresh
- **Display Name:** Thresh Life (App Store) / Thresh (in-app)
- **Minimum iOS:** 17.0
- **Current Distribution:** TestFlight

Build command:
```bash
cd /Users/drewnat/Documents/ContinuityLabsGit/thresh && xcodebuild -scheme "Thresh Life" -destination 'platform=iOS Simulator,name=iPhone 17' build
```

---

## NEXT PRIORITIES (Post-Launch)

1. Full-text search across all content types
2. CloudKit sync for multi-device support
3. Yearly synthesis flow
4. Widget for quick capture
5. Apple Watch companion

---

*Last updated: December 2024*
