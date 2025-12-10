# Thresh - Development Roadmap

**Last Updated:** December 2024

---

## Completed Milestones

### v0.1 Foundation ✓
- [x] Two Modes framework (Capture/Synthesis)
- [x] SwiftData models and persistence
- [x] Prompt library with 150+ prompts
- [x] Design notes system
- [x] Basic navigation structure

### v0.2 Core Screens ✓
- [x] HomeScreen with tabs
- [x] NewReflectionScreen (capture-first flow)
- [x] WeeklyReflectionScreen (synthesis)
- [x] QuarterlyReflectionScreen
- [x] Story/Idea/Question entry screens
- [x] Archive and Recently Deleted

### v0.3 Intelligence ✓
- [x] Claude API integration
- [x] Story/Idea/Question extraction
- [x] Extraction review modal (accept/reject)
- [x] Connection detection (keyword-based)
- [x] PatternsScreen with connections UI

### v0.4 Polish ✓
- [x] First-launch onboarding (5 pages)
- [x] Feature tooltips system
- [x] JSON export functionality
- [x] JSON import with duplicate detection
- [x] Source tracking on all content types
- [x] Marinating system for reflections
- [x] View Onboarding Again in Settings

### v0.5 NLP Enhancement ✓
- [x] Apple NaturalLanguage framework integration
- [x] On-device word embeddings
- [x] Semantic similarity for connection detection
- [x] Hybrid approach (keywords + NLP)
- [x] Performance optimization (90-day window)
- [x] Weekly synthesis AI pattern suggestions

---

## Current Version: v1.0

**Status:** Feature Complete — In TestFlight

All core features for initial release are implemented and working. The app successfully:
- Enforces capture-before-synthesis workflow
- Extracts content using Claude AI
- Detects connections using hybrid NLP approach
- Educates users through onboarding and tooltips
- Provides data backup/restore functionality

---

## IMMEDIATE NEXT STEPS

Priority is App Store submission:

1. **TestFlight Validation** — Verify all features work on physical devices
2. **App Store Screenshots** — Capture compelling screenshots for listing
3. **App Store Metadata** — Finalize description, keywords, categories
4. **Privacy Policy** — Publish privacy policy URL
5. **Submit for Review** — Submit v1.0 to App Store

---

## Future Roadmap

### v1.1 - Quality of Life
- [ ] Search functionality across all content types
- [ ] Quick Capture widget for iOS home screen
- [ ] Improved error handling and retry logic
- [ ] Performance profiling and optimization

### v1.2 - Sync & Sharing
- [ ] CloudKit integration for device sync
- [ ] iCloud backup
- [ ] Share individual reflections
- [ ] Export to other formats (PDF, Markdown)

### v1.3 - Advanced Intelligence
- [ ] Theme Navigator (visual theme exploration)
- [ ] Writing Growth Portrait (progress tracking)
- [ ] Capture quality assessment
- [ ] Personalized prompt recommendations

### v1.4 - Platform Expansion
- [ ] iPad optimization
- [ ] Mac Catalyst support
- [ ] Apple Watch quick capture
- [ ] Siri integration

---

## Guiding Principles

When planning future work, maintain these principles:

1. **Two Modes Framework** - Capture before Synthesis is foundational, not optional
2. **AI Extracts, Never Writes** - AI surfaces patterns; users create content
3. **Observation First** - The harder skill gets trained first
4. **Neurodiverse-First** - Reduce friction, accommodate inconsistency
5. **Privacy by Default** - On-device when possible, user controls data

---

## How to Contribute

1. Check this roadmap for planned features
2. Reference CURRENT_PROJECT_STATE.md for implementation details
3. Follow patterns in existing code
4. Maintain Two Modes philosophy in all changes
5. Test on device before submitting
