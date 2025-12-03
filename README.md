# vicarious-me-swift
# VICARIOUS ME — DESIGN PRINCIPLES

*The essential truths. If you read nothing else, read this.*

---

## The Core Insight

**Observation is exponentially harder than interpretation.**

Most apps treat interpretation as the "advanced" skill and observation as the easy starting point. This is backwards.

- **Interpretation is easy.** We do it automatically, constantly, often without noticing. The moment something happens, we're already deciding what it means.

- **Observation is hard.** Staying with what happened—the sensory details, the exact words, the sequence of events—without sliding into meaning requires real discipline.

Vicarious Me trains observation first. Without it, interpretation is ungrounded—users "get lost" in meaning-making. With it, interpretation becomes powerful because it's earned.

---

## The Two Modes

Reflection has two distinct cognitive activities. We keep them separate.

| Mode | Symbol | Activity | When |
|------|--------|----------|------|
| **Capture** | 📷 | Recording what happened | Daily entries (required first) |
| **Synthesis** | 🔮 | Finding what it means | After capture, and at weekly+ aggregation |

**Capture Mode** is like taking a photograph—sensory, specific, judgment-free.

**Synthesis Mode** is like developing the photograph—interpretive, connective, questioning.

**Critical rule:** You cannot synthesize what you haven't captured. Interpretation must be earned through observation.

---

## The Temporal Structure

```
Daily Captures (70% observation, 30% interpretation max)
       ↓
Weekly Synthesis (reviews captures, finds threads)
       ↓
Monthly Synthesis (reviews weeks, finds patterns)
       ↓
Quarterly / Yearly (the long arc)
```

**Daily:** Emphasize capture. Synthesis is optional.

**Weekly+:** Emphasize synthesis. But always grounded in captures.

---

## AI Philosophy

**AI extracts. It never writes.**

| AI Does | AI Never Does |
|---------|---------------|
| Extract questions from user's words | Generate content for users |
| Surface connections between entries | Interpret meaning |
| Provide feedback on capture quality | Rewrite or "improve" text |

The cognitive work of reflection—the struggle to find words, the act of noticing—is where the benefit lives. If AI does that work, users lose the benefit.

---

## Neurodiverse-First Design

Designed for variable attention, time blindness, and initiation difficulty.

1. **Reduce initiation friction**
   - Prompt-first (never blank page)
   - One-tap Quick Capture mode
   - Micro-entries are valid

2. **Compensate for time blindness**
   - "Time since" indicators on focus types
   - Visual pattern surfacing
   - AI remembers what users forget

3. **Accommodate inconsistency**
   - No punitive streaks
   - Celebrate return, not chains
   - "Welcome back" not "you broke your streak"

4. **Support variable energy**
   - Quick Capture for low-energy days
   - Full flow for high-energy days
   - Both count equally

---

## What Makes a Good Capture

Elements of thick description:

- **Specificity:** "The corner booth" not "a restaurant"
- **Sensory detail:** What you saw, heard, smelled, felt
- **Verbatim fragments:** Actual words when possible
- **Behavioral observation:** What people *did*, not what they *felt*
- **Temporal anchoring:** The sequence of events

A good capture can be interpreted and reinterpreted over time. A premature interpretation locks in one meaning and loses the raw material.

---

## What Makes Good Synthesis

Synthesis generates new understanding. Summary restates.

| Summary ❌ | Synthesis ✓ |
|-----------|-------------|
| "This week I wrote about work, family, and mornings." | "The thread connecting this week is control—I'm clinging to mornings because the rest feels uncontrollable." |
| Lists topics | Finds connections |
| Restates | Generates insight |

**Test:** Does writing this create understanding I didn't have before? If yes, it's synthesis.

---

## The Design Notes System

Philosophy is revealed progressively, not dumped upfront.

- Brief explanations appear at key moments
- Triggered by user actions (first capture, first synthesis, etc.)
- Dismissable but always accessible
- Explains *why*, not just *what*

Users learn by doing, then the app names what they just experienced.

---

## One Sentence Summary

**Vicarious Me trains users to observe before interpreting—the harder skill first—building genuine self-understanding through captured moments that aggregate into meaning over time.**

---

*This document: ~600 words*
*For details: See Enhancement Specification*
*For implementation: See iOS Blueprints*
*For in-app content: See Design Notes System*

# VICARIOUS ME — DESIGN NOTES SYSTEM
## Progressive Disclosure of App Philosophy

*Helping users understand WHY the app works the way it does, revealed at the right moments*

---

## OVERVIEW

### The Problem with Upfront Explanation

Dumping theory on users at onboarding:
- Overwhelms before they have context
- Feels academic and intimidating
- Doesn't stick without experiential grounding
- Creates barrier to starting

### The Progressive Disclosure Approach

Instead, reveal design rationale:
- **Contextually**: When a feature is first encountered
- **Briefly**: 2-4 sentences max, expandable
- **Optionally**: User can dismiss or explore
- **Repeatedly**: Available for re-reading in a collected view

### The "Design Notes" Concept

Small, dismissable cards that appear at key moments, framed as the app being transparent about its intentions:

```
┌──────────────────────────────────────────────────────────────┐
│  📓 Design Note                                    [×]       │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  [Brief explanation - 2-4 sentences]                         │
│                                                              │
│  [Read more ↓]  (expands to full mini-article)              │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## AI PHILOSOPHY NOTE

**Trigger**: First time user sees AI-generated content (extracted questions, surfaced connections)

**Title**: "How AI Works Here"

**Brief**:
AI in Vicarious Me extracts and surfaces—it never writes for you. When you see AI-generated questions or connections, these are drawn from your words, not invented. The reflection is yours; AI just helps you see what's already there.

**Expanded**:
Many apps use AI to generate content for users. We take a different approach.

AI here does three things:
1. **Extracts** questions that seem embedded in what you wrote
2. **Surfaces** connections between entries you might not remember
3. **Provides feedback** on your writing patterns (like capture quality)

What AI never does:
- Write or rewrite your reflections
- Generate interpretations of your experience
- Tell you what your entries "mean"

Why? Because the cognitive work of reflection—the struggle to find words, the act of noticing, the process of making meaning—is where the benefit lives. If AI does that work, you lose the benefit.

Your reflections are yours. AI is a mirror, not an author.

---

## TWO MODES NOTE

**Trigger**: First daily entry (during onboarding or first use)

**Title**: "Why Two Modes?"

**Brief**:
Reflection has two distinct activities: capturing what happened, and interpreting what it means. Most journaling apps blur these together. We separate them because they're different skills, and developing both makes your reflection more powerful.

**Expanded**:
Think of a photographer. They do two things:
1. **Take the photo**: Capture the scene as it is
2. **Develop the photo**: Bring out meaning, crop, adjust, interpret

If you only interpret without capturing, you lose the raw material. Your interpretations become untethered—you "get lost" in meaning-making without grounding.

If you only capture without interpreting, you accumulate observations but never find patterns.

Vicarious Me trains both:
- **Capture Mode** (📷): Recording what happened—sensory, specific, judgment-free
- **Synthesis Mode** (🔮): Finding what it means—interpretive, connective, questioning

Daily entries emphasize capture. Weekly and monthly reviews emphasize synthesis. Over time, you'll move between modes deliberately, knowing which tool you're using and why.

This isn't just app design—it's based on how ethnographers, qualitative researchers, and skilled observers have worked for decades. Description and interpretation are both essential. The skill is knowing which you're doing.

---

## CAPTURE-FIRST NOTE

**Trigger**: First time user sees "Save Capture Only" option

**Title**: "Why Capture First?"

**Brief**:
We ask you to describe before you interpret because meaning can change. The details you capture today might reveal different patterns next month. If you interpret too quickly, you lock in one meaning and lose others.

**Expanded**:
Here's a common experience: You write about something that happened, immediately decide what it "means," and move on. Three weeks later, you realize your interpretation was wrong—but you can't remember the actual details anymore. You only remember your interpretation.

This is why we ask you to capture first.

A good capture preserves the raw material:
- What you actually saw and heard
- What people actually said (verbatim if possible)
- The physical details of the scene
- The sequence of events

This raw material can be interpreted and reinterpreted over time. Your weekly synthesis might see one pattern. Your monthly review might see another. A year from now, you might see something entirely different.

If you skip straight to interpretation, you lose this flexibility. The capture is gone, replaced by your first (possibly wrong) meaning.

Some entries will be pure captures—just observations, no interpretation. That's not "incomplete." That's raw material, preserved for later insight.

---

## AGGREGATION NOTE

**Trigger**: First weekly reflection

**Title**: "Why Weekly Synthesis?"

**Brief**:
Daily entries are close to experience—you're still inside the moment. Weekly synthesis gives you distance. With distance comes pattern recognition: you can see what a single day can't show you.

**Expanded**:
There's a reason we don't ask you to find deep meaning in every daily entry. You're too close. The event just happened. Your emotions are still active. Your interpretation is likely to be reactive rather than reflective.

A week later, things look different:
- The intensity has faded
- You've had other experiences that provide contrast
- Patterns have had time to emerge
- You can see what persisted vs. what was momentary

Weekly synthesis isn't about summarizing what you wrote. It's about looking at your captures together and asking: "What do I see now that I couldn't see in any single entry?"

This is why we show you your captures and ask you to add "interpretation layers" before synthesizing. You're revisiting with fresh eyes. The capture stays the same; your understanding of it evolves.

The same principle applies at every level:
- Weekly: What patterns emerge across days?
- Monthly: What themes persist across weeks?
- Quarterly: What's shifting across months?
- Yearly: What story is your year telling?

Each level requires more distance and reveals larger patterns.

---

## TIME BLINDNESS NOTE

**Trigger**: First time user sees "time since" indicators on focus types

**Title**: "Why We Show Time"

**Brief**:
It's easy to lose track of what you've reflected on and when. These indicators help you notice gaps and patterns in your attention—not to judge, but to see clearly where your focus has been.

**Expanded**:
Human memory for time is unreliable. "Last week" and "three weeks ago" often feel the same. This is especially true for people with ADHD, but it affects everyone.

Without external markers, you might:
- Think you reflected on a relationship recently when it's been a month
- Not notice you've written about work stress five times in two weeks
- Miss patterns in what you're paying attention to (and avoiding)

The "time since" indicators on focus types aren't meant to create pressure or guilt. They're information—helping you see where your attention has been.

Some things to notice:
- A topic you haven't touched in weeks might be worth revisiting
- A topic you keep returning to might be asking for deeper attention
- Gaps might be avoidance, or might just be that nothing happened there

This is part of a larger principle: the app tries to externalize information you'd otherwise need to hold in your head. We remember so you don't have to.

---

## INTERPRETATION DRIFT NOTE

**Trigger**: When AI detects interpretation drift pattern

**Title**: "A Note on Grounding"

**Brief**:
Your recent entries move quickly to interpretation. That's valuable—but meaning without grounding can become untethered. Spending more time on "what happened" before "what it means" gives your interpretations stronger foundations.

**Expanded**:
There's a pattern in reflective writing where people skip description and jump straight to meaning:

❌ "I realized I was anxious about the meeting because of my relationship with authority."

This might be true. But where's the evidence? What actually happened in the meeting? What did you observe? Without the capture, this interpretation is floating—it could be accurate or it could be a story you're telling yourself.

✓ "In the meeting, I noticed I kept looking at the door. When my manager asked for my opinion, my voice came out quieter than usual. She frowned—or I think she frowned. Afterward I couldn't remember what I'd said."

Now there's something to interpret. The capture gives the interpretation grounding.

This isn't about doubting your insights. It's about building them on solid foundations. The most powerful reflections move from specific observation to interpretation—and can point back to the observation as evidence.

When we suggest "try a pure capture today," we're not saying your interpretations are wrong. We're saying: give them something to stand on.

---

## THICK DESCRIPTION NOTE

**Trigger**: First time user gets capture quality feedback

**Title**: "What Makes a Good Capture?"

**Brief**:
Good captures are specific, sensory, and concrete. They describe what a camera might record—what was seen, heard, and done—before adding what was felt or meant. The richer the capture, the more it can reveal over time.

**Expanded**:
Anthropologists use a term called "thick description"—capturing behavior with enough context that it becomes meaningful to an outsider.

The opposite is thin description: "We had dinner and it was awkward."

Thick description: "We sat at the corner table, the one by the window. She kept rearranging her silverware. When I mentioned the trip, she looked out the window and said 'That sounds nice' without looking at me. The silence lasted maybe ten seconds. I could hear the kitchen noise."

Both describe the same event. But the thick description preserves material the thin description loses. A year from now, you can return to that thick description and see things you didn't notice at the time. The thin description gives you nothing to work with.

Elements of a good capture:
- **Sensory detail**: What you saw, heard, smelled, felt
- **Specificity**: "The corner booth" not "a restaurant"
- **Verbatim fragments**: Actual words when possible
- **Behavioral observation**: What people did, not what they felt
- **Spatial/temporal anchoring**: Where and when, in what sequence

You don't need all of these in every entry. But the more you include, the richer your raw material for later synthesis.

---

## PURE CAPTURE NOTE

**Trigger**: First time user saves a pure capture (no interpretation)

**Title**: "Captures Are Complete"

**Brief**:
You just saved a capture without interpretation. That's not incomplete—it's a deliberate choice. Some moments need to sit before meaning emerges. You can always add interpretation later, but you can't recover details you didn't capture.

**Expanded**:
There's a cultural bias toward "processing" experiences immediately. Something happens, and we feel pressure to understand it, learn from it, extract the lesson.

But premature interpretation can be a trap:
- You lock in one meaning before others can emerge
- You lose the details in favor of the conclusion
- You miss what the moment might reveal later in a different context

Pure captures honor the reality that meaning takes time. Some things need to marinate. Some patterns only become visible when you have more data points. Some interpretations are only possible with distance.

When you save a capture without interpretation, you're saying: "I noticed this. I don't know what it means yet. I'm preserving it for future understanding."

That's not laziness or incompleteness. That's wisdom about how insight actually works.

The capture is the seed. The interpretation can grow later.

---

## REVISION LAYER NOTE

**Trigger**: First weekly reflection when "Add layer" option appears

**Title**: "Why Revisit Captures?"

**Brief**:
You wrote these entries days ago. Now you have distance. The "Add layer" option lets you annotate your past self—adding what you see now that you didn't see then. This is where some of the deepest insight happens.

**Expanded**:
Knowledge-transforming writing—the kind that actually changes how you understand things—requires revision. Not just fixing typos, but returning to your own words with new eyes.

When you wrote Monday's capture, you were inside the experience. Now it's Sunday. Things have happened since then. You've had other experiences, other thoughts. The capture is the same, but you've changed.

The "revision layer" lets you annotate without altering:
- The original capture stays intact
- You add what you see now
- The contrast between "then" and "now" becomes visible

This is powerful because:
1. It shows you how your understanding evolves
2. It catches things you weren't ready to see at the time
3. It connects past captures to present understanding
4. It makes your growth visible

Some prompts for revision layers:
- "What do you see now that you didn't see then?"
- "What were you not ready to acknowledge?"
- "What does this connect to that happened later?"

You're not rewriting the past. You're reading yourself with new eyes.

---

## SYNTHESIS VS SUMMARY NOTE

**Trigger**: First time AI detects summary-like content in a synthesis entry

**Title**: "Synthesis, Not Summary"

**Brief**:
A summary restates what you wrote. A synthesis generates new understanding. We're asking you to find what connects your captures—not list them, but discover what they reveal together that no single entry revealed alone.

**Expanded**:
Here's the difference:

**Summary**: "This week I wrote about work on Monday, my morning routine on Wednesday, and a conversation with my sister on Friday."

**Synthesis**: "The thread connecting this week is control. Monday's meeting was about feeling out of control at work. My morning routine entry was about clinging to the one part of my day I can control. And the conversation with my sister? She was offering help, and I felt controlled by her concern. It's all the same thing."

Summary is easy. You're just restating. No new understanding is generated.

Synthesis is harder. You're looking at disparate captures and asking: "What pattern emerges? What question is this week asking me? What do I understand now that I didn't understand in any single entry?"

Signs you're summarizing:
- You're listing topics: "I wrote about X, Y, and Z"
- You're restating conclusions you already made
- Nothing new emerges from the writing

Signs you're synthesizing:
- You're finding unexpected connections
- You're using language like "I realize" or "the thread is"
- The act of writing generates insight you didn't have before

This is the difference between reflection as documentation and reflection as understanding.

---

## VOICE SPECTRUM NOTE

**Trigger**: First Bakhtinian prompt or when AI surfaces perspective-taking opportunity

**Title**: "Why Other Voices?"

**Brief**:
Your reflections naturally center your perspective. Including other voices—how others might have experienced the same moment—deepens understanding. You're not abandoning your view; you're making it three-dimensional.

**Expanded**:
Every moment you reflect on involved other people—or at least, a world beyond your perspective. Your experience is real, but it's also partial.

When you include other voices:
- "From her perspective, she might have seen..."
- "What a stranger would have observed..."
- "The cultural script we were both following..."

You're not invalidating your experience. You're enriching it. Understanding multiplies when you hold multiple perspectives simultaneously.

This comes from a literary theorist named Mikhail Bakhtin, who argued that meaning emerges through dialogue—through the interaction of different voices and perspectives.

In practice:
- **Solo voice**: Just your perspective (valid, but limited)
- **Duet**: You + one other perspective
- **Ensemble**: Multiple perspectives in dialogue
- **Chorus**: Personal + cultural/systemic perspectives

You don't need multiple voices in every entry. But when you're stuck, or when an interpretation feels flat, try asking: "Who else was in this moment? How might they tell it?"

---

## QUESTION EXTRACTION NOTE

**Trigger**: First time AI extracts questions from a reflection

**Title**: "Questions in Your Writing"

**Brief**:
These questions weren't invented by AI—they were drawn from what you wrote. Your reflections often contain questions you didn't explicitly ask. Surfacing them helps you notice what you're wondering about.

**Expanded**:
When you reflect, you often circle around questions without directly asking them:

"I keep thinking about why she said that. It didn't make sense at the time. Maybe she was trying to tell me something I missed."

Embedded in this reflection are several questions:
- Why did she say that?
- What was she trying to tell me?
- What did I miss?

The AI extracts questions like these—not generating new ones, but surfacing what's already implied in your words.

Why does this matter?

1. **Questions you don't notice still shape your thinking**. Making them explicit gives you choice.

2. **Some questions are more generative than others**. Practical questions ("What should I do?") seek answers. Generative questions ("What does this pattern reveal?") open inquiry.

3. **Questions can be held over time**. You don't need to answer them immediately. Some questions are worth sitting with for weeks or months.

When you see extracted questions, you're seeing your own wondering reflected back. The AI isn't telling you what to think—it's showing you what you're already thinking about.

---

## PATTERN SURFACING NOTE

**Trigger**: First time AI surfaces a cross-entry connection or theme

**Title**: "Patterns You Might Miss"

**Brief**:
You've written many entries over time. Patterns emerge across them that are hard to see when you're close to each one. AI surfaces potential connections—not interpretations, but observations: "These entries might be related."

**Expanded**:
Human memory is designed to forget. This is usually useful—you don't need to remember every detail of every day. But it means patterns across time become invisible.

You wrote about feeling rushed on November 3rd. You wrote about needing solitude on November 10th. You wrote about resenting a request from your partner on November 15th.

Each entry made sense on its own. But together, they might reveal a pattern: maybe you're running on empty and haven't noticed.

AI pattern surfacing works by:
- Tracking themes across entries
- Noticing recurring people, places, and concerns
- Identifying entries that seem to be "in conversation" with each other

What AI surfaces is not interpretation—it's connection. "These entries seem related" is different from "This is what it means."

You decide whether the connection is meaningful. Sometimes the AI will surface something that isn't actually a pattern—just coincidence. Other times, it will show you something that makes sudden sense.

The value isn't that AI understands you. It's that AI remembers what you've written and can show you juxtapositions you'd otherwise miss.

---

## STREAKS AND CONSISTENCY NOTE

**Trigger**: First return after a gap, or when viewing entry counts

**Title**: "Why We Don't Do Streaks"

**Brief**:
We track reflections, not consecutive days. Gaps aren't failures—they're normal. What matters is that you return. We celebrate totals and patterns, not chains that punish interruption.

**Expanded**:
Most apps use streaks: "You've written for 12 days in a row! Don't break the chain!"

This works for some people. For others—especially people with ADHD or variable energy—streaks become punishment. You miss one day and the chain breaks. The app that was supposed to help now makes you feel like a failure.

We take a different approach:
- "This month: 7 reflections" (not "streak: 0")
- "All time: 47 reflections" (celebrating accumulation)
- "Welcome back! It's been 8 days. What stands out?" (not "you broke your streak")

Reflection isn't a daily habit that requires unbroken consistency. It's a practice that ebbs and flows with your life.

Some weeks you'll write every day. Some weeks you won't write at all. What matters is that you return—that the practice continues over months and years, not that it never stops.

Gaps can even be informative. What were you avoiding? What was happening that made reflection feel impossible? The gap itself can become material.

So when you return after time away, you're not "starting over." You're continuing.

---

## MARINATION NOTE

**Trigger**: When "Let it marinate" option is presented

**Title**: "Why Let It Sit?"

**Brief**:
Not everything needs immediate interpretation. Some experiences need to marinate—to sit without meaning until meaning emerges on its own. You can always add interpretation later; you can't undo premature closure.

**Expanded**:
There's pressure to process experiences immediately. Something happens; you should understand it; you should learn the lesson.

But some experiences resist immediate understanding:
- The meaning isn't clear yet
- You're too close to see the pattern
- The full picture requires more information
- Your emotional state is distorting your interpretation

In these cases, the wisest move is to capture and wait.

"Marinating" means:
- Recording what happened without deciding what it means
- Flagging it for future attention
- Trusting that understanding will come with time

Some of the deepest insights come not from immediate reflection but from returning to a capture weeks or months later and suddenly seeing what you couldn't see before.

The option to "let it marinate" is permission to not know yet. It's an acknowledgment that understanding has its own timeline.

---

## COLLECTION: ALL DESIGN NOTES

These notes are also collected in a viewable "Design Notes" section accessible from Settings, organized by theme:

### Foundation
- How AI Works Here
- Why Two Modes?
- Why Capture First?

### Daily Practice
- What Makes a Good Capture?
- Captures Are Complete
- A Note on Grounding

### Synthesis
- Why Weekly Synthesis?
- Why Revisit Captures?
- Synthesis, Not Summary

### Patterns & Connection
- Why We Show Time
- Patterns You Might Miss
- Questions in Your Writing

### Perspective
- Why Other Voices?

### Practice
- Why We Don't Do Streaks
- Why Let It Sit?

---

## IMPLEMENTATION NOTES

### Trigger Logic

Each note appears:
- **Once** at first trigger (dismissable)
- **Never again automatically** after dismissal
- **Always available** in collected view
- **Optionally re-surfaced** if user seems to need reminder (e.g., interpretation drift warning includes link to "A Note on Grounding")

### UI Pattern

```
┌──────────────────────────────────────────────────────────────┐
│  📓 Design Note                                    [×]       │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WHY TWO MODES?                                              │
│                                                              │
│  Reflection has two distinct activities: capturing what      │
│  happened, and interpreting what it means. We separate       │
│  them because they're different skills, and developing       │
│  both makes your reflection more powerful.                   │
│                                                              │
│  [Read more ↓]                                               │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Expanded View

```
┌──────────────────────────────────────────────────────────────┐
│  📓 Design Note                                    [×]       │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  WHY TWO MODES?                                              │
│                                                              │
│  Reflection has two distinct activities: capturing what      │
│  happened, and interpreting what it means. We separate       │
│  them because they're different skills, and developing       │
│  both makes your reflection more powerful.                   │
│                                                              │
│  ─────────────────────────────────────────────────────────── │
│                                                              │
│  Think of a photographer. They do two things:                │
│  1. Take the photo: Capture the scene as it is               │
│  2. Develop the photo: Bring out meaning, adjust, interpret  │
│                                                              │
│  If you only interpret without capturing, you lose the raw   │
│  material. Your interpretations become untethered—you "get   │
│  lost" in meaning-making without grounding.                  │
│                                                              │
│  If you only capture without interpreting, you accumulate    │
│  observations but never find patterns.                       │
│                                                              │
│  [... continues ...]                                         │
│                                                              │
│  [Collapse ↑]                                                │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Settings View

```
┌──────────────────────────────────────────────────────────────┐
│  Settings > Design Notes                                     │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Why Vicarious Me works the way it does.                     │
│                                                              │
│  FOUNDATION                                                  │
│  ├─ How AI Works Here                                        │
│  ├─ Why Two Modes?                                           │
│  └─ Why Capture First?                                       │
│                                                              │
│  DAILY PRACTICE                                              │
│  ├─ What Makes a Good Capture?                               │
│  ├─ Captures Are Complete                                    │
│  └─ A Note on Grounding                                      │
│                                                              │
│  SYNTHESIS                                                   │
│  ├─ Why Weekly Synthesis?                                    │
│  ├─ Why Revisit Captures?                                    │
│  └─ Synthesis, Not Summary                                   │
│                                                              │
│  [... etc ...]                                               │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## SUMMARY

The Design Notes system:

1. **Reveals philosophy progressively** at moments when context exists
2. **Keeps it brief** (2-4 sentences) with optional expansion
3. **Explains the why** behind features, not just the what
4. **Is dismissable** but always accessible
5. **Frames the app as transparent** about its intentions
6. **Reinforces key principles** (two modes, grounding, AI as extractor) throughout the user journey

Users learn why Vicarious Me works the way it does by using it—not by reading a manual.

---

*Document Version: 1.0*
*Purpose: Progressive disclosure of design philosophy*
*Principle: Understanding emerges from experience, then is named*

# Vicarious Me — iOS Development Blueprints

## Product Vision

**Vicarious Me** is a reflection journaling app that helps users capture daily moments and build narratives from their experiences over time. Unlike typical journaling apps, Vicarious Me trains users in the discipline of *observation*—the harder skill—before interpretation, enabling thick description and genuine self-understanding.

### Core Philosophy

- **Observation Before Interpretation:** Recording what happened is exponentially harder than deciding what it means. We train the harder skill first.
- **Two Modes:** Capture (📷) and Synthesis (🔮) are distinct cognitive activities. Users learn to move between them deliberately.
- **AI Extracts, Never Writes:** AI surfaces questions, connections, and patterns from user's words—it never generates content for them.
- **Stacked Aggregation:** Daily captures aggregate into weekly synthesis, monthly themes, quarterly reviews, yearly narratives.
- **Neurodiverse-First:** Designed for variable attention, time blindness, and initiation difficulty.
- **iOS-First:** Deep integration with Apple ecosystem.

### The Observation Insight

Most apps assume interpretation is the "advanced" skill. This is backwards.

**Interpretation is easy.** We do it automatically, constantly, often without noticing. The moment something happens, we're already deciding what it means.

**Observation is hard.** Staying with what happened—the sensory details, the exact words, the sequence of events—without sliding into meaning requires real discipline. It's why "just describe" is a harder prompt than "what did you learn?"

Vicarious Me trains observation as the foundational skill. Without it, interpretation is ungrounded—users "get lost" in meaning-making. With it, interpretation becomes powerful because it's earned.

### Technology Stack

| Component | Technology | Rationale |
|-----------|------------|-----------|
| UI Framework | SwiftUI | Declarative, animations, modern |
| Data Persistence | SwiftData | Native Swift, CloudKit-ready |
| State Management | @Observable / Observation | Modern Swift concurrency |
| Text Input | Native TextEditor | Keyboard handling, dictation |
| On-Device Analysis | Core ML / Apple Intelligence | Privacy, speed, mode detection |
| Cloud AI | OpenAI API (GPT-4o) | Question extraction, pattern surfacing |
| Async/Concurrency | Swift Concurrency (async/await) | Modern, safe |
| Networking | URLSession | Native, efficient |
| Local Notifications | UserNotifications | Gentle prompts, weekly reminders |

---

## How to Use These Blueprints

Each blueprint is designed to be copy-pasted directly into Claude Code (or a similar AI coding assistant). They're structured to:

1. Provide full context on what to build
2. Define clear success criteria
3. Allow iterative refinement through conversation
4. Build progressively on previous blueprints

**Workflow:**
1. Open your Xcode project in Claude Code
2. Paste a blueprint
3. Let Claude Code implement
4. Build and test
5. Refine through conversation
6. Commit and move to the next blueprint

**Key Principle:** The Two Modes framework (Capture vs. Synthesis) must be present from the earliest blueprints. It's not a feature—it's the foundation.

---

## Phase 1: Foundation

### BLUEPRINT 1.1: Project Setup

```
I'm building Vicarious Me, an iOS reflection journaling app in Swift/SwiftUI.

Create a new Xcode project with this structure:

1. Project Configuration:
   - Name: VicariousMe
   - iOS 17.0+ deployment target
   - SwiftUI lifecycle
   - Swift 5.9+
   - Enable Swift strict concurrency checking

2. Create this folder/group structure in Xcode:
   VicariousMe/
   ├── App/
   │   ├── VicariousMeApp.swift
   │   └── AppState.swift
   ├── Models/
   │   └── (SwiftData models)
   ├── Views/
   │   ├── Screens/
   │   ├── Components/
   │   ├── DesignNotes/
   │   └── Styles/
   ├── ViewModels/
   ├── Services/
   │   ├── AI/
   │   ├── Prompts/
   │   └── Storage/
   ├── Utilities/
   └── Resources/
       ├── Assets.xcassets
       └── PromptLibrary.json

3. Define the color palette in Assets.xcassets:
   - CaptureColor: Blue (#3B82F6) — for Capture Mode
   - SynthesisColor: Purple (#8B5CF6) — for Synthesis Mode
   - StoryColor: Indigo (#6366F1) — for stories
   - IdeaColor: Emerald (#22C55E) — for ideas
   - QuestionColor: Amber (#F59E0B) — for questions
   - SurfaceColor: adaptive white/gray-900
   - BackgroundColor: adaptive gray-50/black

4. Create Color extension for easy access:
   extension Color {
       static let vm = VMColors()
   }
   
   struct VMColors {
       let capture = Color("CaptureColor")
       let synthesis = Color("SynthesisColor")
       let story = Color("StoryColor")
       let idea = Color("IdeaColor")
       let question = Color("QuestionColor")
       let surface = Color("SurfaceColor")
       let background = Color("BackgroundColor")
   }

5. Add required capabilities in Signing & Capabilities:
   - Background Modes: Background fetch (for notifications)
   
6. Info.plist privacy descriptions:
   - NSUserNotificationUsageDescription: "Vicarious Me sends gentle reminders for reflection."

7. Create a basic AppState class using @Observable:
   @Observable
   class AppState {
       var hasCompletedOnboarding = false
       var currentMode: ReflectionMode = .capture
       var userDevelopmentStage: DevelopmentStage = .emerging
   }
   
   enum ReflectionMode: String, Codable {
       case capture, synthesis
   }
   
   enum DevelopmentStage: String, Codable {
       case emerging, developing, established, fluent
   }

8. Set up VicariousMeApp.swift with:
   - SwiftData modelContainer
   - AppState as environment object
   - Basic navigation structure

Verify the app builds and runs on simulator.
```

---

### BLUEPRINT 1.2: SwiftData Models

```
Create the SwiftData models for Vicarious Me.

These model a reflection app where we:
- Capture daily observations (Capture Mode)
- Synthesize patterns over time (Synthesis Mode)
- Track stories, ideas, and questions separately
- Aggregate entries into weekly/monthly/quarterly/yearly reflections
- AI extracts questions and surfaces connections

IMPORTANT DESIGN CONTEXT:
- Observation (Capture) is the harder skill; interpretation (Synthesis) is easy
- Entries can be pure captures (no interpretation) and this is VALID
- The Two Modes are distinct cognitive activities, not levels

Create Models/ReflectionModels.swift:

1. Reflection (main entity)
   @Model
   class Reflection {
       @Attribute(.unique) var id: UUID
       var createdAt: Date
       var updatedAt: Date
       var tier: ReflectionTier
       var focusType: FocusType?
       
       // Two Modes content - kept separate!
       var captureContent: String  // What happened (observation)
       var synthesisContent: String?  // What it means (interpretation, optional!)
       
       var entryType: EntryType
       var modeBalance: ModeBalance
       
       @Relationship(deleteRule: .cascade) var revisionLayers: [RevisionLayer]
       @Relationship(deleteRule: .cascade) var extractedQuestions: [ExtractedQuestion]
       @Relationship var linkedReflections: [Reflection]
       
       var themes: [String]
       var captureQuality: CaptureQuality?
       var marinating: Bool  // User chose to let it sit without interpreting
   }
   
   enum ReflectionTier: String, Codable, CaseIterable {
       case daily, weekly, monthly, quarterly, yearly
   }
   
   enum FocusType: String, Codable, CaseIterable {
       case event, person, relationship, place, object
       case routine, conversation, question, day, theme, other
   }
   
   enum EntryType: String, Codable {
       case pureCapture      // 📷 Only observation, no interpretation
       case groundedReflection  // 📷→🔮 Both, balanced
       case synthesis        // 🔮 Aggregation-level (weekly+)
   }
   
   enum ModeBalance: String, Codable {
       case captureOnly, captureHeavy, balanced, synthesisHeavy, synthesisOnly
   }

2. RevisionLayer (added interpretation over time)
   @Model
   class RevisionLayer {
       @Attribute(.unique) var id: UUID
       var addedAt: Date
       var content: String
       var revisionType: RevisionType
       
       var reflection: Reflection?
   }
   
   enum RevisionType: String, Codable {
       case reframing       // Changed interpretation
       case expansion       // Added detail
       case connection      // Linked to other entries
       case newQuestion     // Question that emerged later
   }

3. ExtractedQuestion (AI-surfaced from user's words)
   @Model
   class ExtractedQuestion {
       @Attribute(.unique) var id: UUID
       var content: String
       var extractedAt: Date
       var questionType: QuestionType
       var saved: Bool  // User chose to keep this question
       var sourceText: String  // The user's text it came from
       
       var reflection: Reflection?
   }
   
   enum QuestionType: String, Codable {
       case practical    // Seeks answer
       case interpretive // Seeks meaning
       case connective   // Seeks patterns
       case generative   // Opens new inquiry
   }

4. CaptureQuality (AI assessment of observation quality)
   struct CaptureQuality: Codable {
       var specificity: QualityLevel
       var sensoryDetail: QualityLevel
       var verbatimPresence: Bool
       var behavioralVsEmotional: Double  // 0-1, higher = more behavioral
       var suggestions: [String]
   }
   
   enum QualityLevel: String, Codable {
       case emerging, developing, strong
   }

5. Story
   @Model
   class Story {
       @Attribute(.unique) var id: UUID
       var createdAt: Date
       var title: String?
       var content: String
       var tags: [String]
   }

6. Idea
   @Model
   class Idea {
       @Attribute(.unique) var id: UUID
       var createdAt: Date
       var content: String
   }

7. Question (user-saved questions)
   @Model
   class Question {
       @Attribute(.unique) var id: UUID
       var createdAt: Date
       var content: String
       var sourceReflectionId: UUID?
       var answered: Bool
   }

8. DesignNoteStatus (tracking which notes user has seen)
   @Model
   class DesignNoteStatus {
       @Attribute(.unique) var noteId: String
       var seen: Bool
       var seenAt: Date?
       var expanded: Bool
   }

9. UserProfile (development tracking)
   @Model
   class UserProfile {
       @Attribute(.unique) var id: UUID
       var createdAt: Date
       var developmentStage: DevelopmentStage
       var totalReflections: Int
       var pureCaptureCount: Int
       var synthesisCount: Int
       var lastReflectionDate: Date?
       
       // Mode balance tracking
       var captureQualityTrend: [Double]  // Rolling average
       var interpretationGrounding: Double  // How well synthesis links to captures
       var modeAwareness: Double  // Does user distinguish modes?
   }

Verify models compile and create test data.
```

---

### BLUEPRINT 1.3: Prompt Library Service

```
Create the prompt library service for Vicarious Me.

This manages all prompts used throughout the app. Prompts are categorized by:
- Mode (capture vs. synthesis)
- Tier (daily, weekly, monthly, etc.)
- Focus type (event, person, etc.)
- Development stage (emerging → fluent)

CRITICAL DESIGN CONTEXT:
Capture prompts are HARDER to respond to than synthesis prompts.
"What happened?" requires discipline.
"What did you learn?" is easy—we do it automatically.

The prompt library respects this by:
1. Never skipping capture prompts in daily entries
2. Making capture prompts specific and sensory-focused
3. Making synthesis prompts explicitly optional at daily tier

Create Services/Prompts/PromptLibrary.swift:

1. Prompt model:
   struct Prompt: Codable, Identifiable {
       let id: String
       let mode: PromptMode
       let type: PromptType
       let tier: ReflectionTier?
       let focusType: FocusType?
       let stage: DevelopmentStage?
       let text: String
       let followUp: String?
       let isHumor: Bool
   }
   
   enum PromptMode: String, Codable {
       case capture      // Observation prompts
       case synthesis    // Interpretation prompts
       case either       // Works for both
   }
   
   enum PromptType: String, Codable {
       case orientation    // Lens selection
       case primary        // Main prompt
       case captureQuality // Improving observation
       case lensProgression // Moving deeper (synthesis only)
       case voiceExpansion // Adding perspectives
       case refinement     // Post-writing enhancement
       case aggregation    // Weekly+ synthesis
   }

2. PromptLibrary class:
   @Observable
   class PromptLibrary {
       private var prompts: [Prompt] = []
       
       init() {
           loadPrompts()
       }
       
       private func loadPrompts() {
           // Load from PromptLibrary.json in bundle
       }
       
       // CAPTURE PROMPTS (the hard skill)
       func getCapturePrompt(focusType: FocusType?, stage: DevelopmentStage) -> Prompt {
           // Returns observation-focused prompt
           // More scaffolding for emerging users
           // Examples: "What did you see/hear?", "What actually happened?"
       }
       
       func getCaptureQualityPrompt(for quality: CaptureQuality) -> Prompt? {
           // Suggests improvement based on what's missing
           // e.g., "Can you add what was actually said?"
       }
       
       // SYNTHESIS PROMPTS (offered after capture)
       func getSynthesisPrompt(tier: ReflectionTier, stage: DevelopmentStage) -> Prompt {
           // Returns meaning-focused prompt
           // Only offered after capture is complete
       }
       
       func getAggregationPrompt(tier: ReflectionTier) -> Prompt {
           // For weekly+ synthesis
           // Emphasizes finding threads, not summarizing
       }
       
       // ADAPTIVE PROMPTS
       func getPromptForStage(_ stage: DevelopmentStage, mode: PromptMode) -> Prompt {
           // Adjusts scaffolding based on user development
           // Stage 1: High scaffolding, examples
           // Stage 4: Minimal prompt or blank space
       }
       
       // HUMOR INJECTION
       func shouldInjectHumor() -> Bool {
           return Double.random(in: 0...1) < 0.15  // 15% chance
       }
   }

3. Create Resources/PromptLibrary.json with prompts:

   CAPTURE PROMPTS (examples):
   - "Describe the scene like a camera would record it. No meanings—just what happened."
   - "What did you see, hear, smell, or feel? One specific detail."
   - "What was actually said? Try to recall exact words."
   - "What did people do—not what they felt, but what they did?"
   - "Walk through the sequence. What happened first? Then what?"
   
   SYNTHESIS PROMPTS (examples):
   - "Now that you've captured it: why did this stick with you?"
   - "What assumption might you be making here?"
   - "What question is this experience asking you?"
   
   AGGREGATION PROMPTS (examples):
   - "What thread connects these captures? Not a summary—what do you understand now?"
   - "If this week were a chapter, what would it be called?"
   - "Looking at these moments together: what pattern emerges?"
   
   CAPTURE QUALITY PROMPTS (examples):
   - "You wrote 'she was upset.' What did she actually do or say that showed this?"
   - "A stranger couldn't picture this yet. Where exactly were you?"
   - "Can you recall any exact words? They often reveal more than summaries."

4. Create a PromptView component:
   struct PromptView: View {
       let prompt: Prompt
       let mode: ReflectionMode
       
       var body: some View {
           VStack(alignment: .leading, spacing: 8) {
               // Mode indicator
               HStack {
                   Image(systemName: mode == .capture ? "camera.fill" : "sparkles")
                   Text(mode == .capture ? "CAPTURE" : "SYNTHESIS")
                       .font(.caption)
                       .fontWeight(.semibold)
               }
               .foregroundStyle(mode == .capture ? Color.vm.capture : Color.vm.synthesis)
               
               // Prompt text
               Text(prompt.text)
                   .font(.body)
                   .italic()
           }
           .padding()
           .background(
               RoundedRectangle(cornerRadius: 12)
                   .fill(mode == .capture ? Color.vm.capture.opacity(0.1) : Color.vm.synthesis.opacity(0.1))
           )
       }
   }

Verify prompts load correctly and can be filtered by criteria.
```

---

### BLUEPRINT 1.4: Design Notes Service

```
Create the Design Notes system for Vicarious Me.

Design Notes are brief, contextual explanations of WHY features work the way they do.
They appear at key moments, are dismissable, and collected in Settings.

CRITICAL: The most important Design Note is about observation being harder than interpretation.
This note should appear early and prominently.

Create Services/DesignNotes/DesignNotesService.swift:

1. DesignNote model:
   struct DesignNote: Identifiable {
       let id: String
       let title: String
       let brief: String  // 2-4 sentences, always visible
       let expanded: String  // Full explanation
       let category: NoteCategory
       let trigger: NoteTrigger
   }
   
   enum NoteCategory: String, CaseIterable {
       case foundation, dailyPractice, synthesis, patterns, perspective, practice
   }
   
   enum NoteTrigger: String {
       case onboarding
       case firstDailyEntry
       case firstPureCapture
       case firstSynthesisOffer
       case firstWeeklyReflection
       case firstTimeSinceIndicator
       case firstQuestionExtraction
       case firstConnectionSurface
       case returnAfterGap
       case interpretationDriftDetected
       case captureQualityFeedback
   }

2. DesignNotesService:
   @Observable
   class DesignNotesService {
       private let modelContext: ModelContext
       private var noteStatuses: [String: DesignNoteStatus] = [:]
       
       static let allNotes: [DesignNote] = [
           // FOUNDATION - Most Important First
           DesignNote(
               id: "two_modes",
               title: "Why Two Modes?",
               brief: "Reflection has two distinct activities: capturing what happened, and interpreting what it means. Most apps blur these together. We separate them because they're different skills—and observation is actually the harder one.",
               expanded: """
               Think of a photographer. They do two things:
               1. Take the photo: Capture the scene as it is
               2. Develop the photo: Bring out meaning, adjust, interpret
               
               Here's the surprising thing: taking a good photo is harder than developing it. Anyone can add a filter. Seeing clearly in the first place? That takes discipline.
               
               The same is true for reflection. Interpretation is easy—we do it automatically, constantly, often without noticing. The moment something happens, we're already deciding what it means.
               
               Observation is hard. Staying with what happened—the sensory details, the exact words, the sequence of events—without sliding into meaning requires real work.
               
               Vicarious Me trains both:
               • Capture Mode (📷): Recording what happened—sensory, specific, judgment-free
               • Synthesis Mode (🔮): Finding what it means—interpretive, connective, questioning
               
               Daily entries emphasize capture—the harder skill. Weekly and monthly reviews emphasize synthesis. Over time, you'll move between modes deliberately.
               """,
               category: .foundation,
               trigger: .onboarding
           ),
           
           DesignNote(
               id: "ai_philosophy",
               title: "How AI Works Here",
               brief: "AI in Vicarious Me extracts and surfaces—it never writes for you. When you see AI-generated questions or connections, these are drawn from your words, not invented. The reflection is yours; AI just helps you see what's already there.",
               expanded: """
               Many apps use AI to generate content for users. We take a different approach.
               
               AI here does three things:
               1. Extracts questions that seem embedded in what you wrote
               2. Surfaces connections between entries you might not remember
               3. Provides feedback on your capture quality (not judgment—observation)
               
               What AI never does:
               • Write or rewrite your reflections
               • Generate interpretations of your experience
               • Tell you what your entries "mean"
               
               Why? Because the cognitive work of reflection—the struggle to find words, the act of noticing, the process of making meaning—is where the benefit lives. If AI does that work, you lose the benefit.
               
               Your reflections are yours. AI is a mirror, not an author.
               """,
               category: .foundation,
               trigger: .firstQuestionExtraction
           ),
           
           DesignNote(
               id: "capture_first",
               title: "Why Capture First?",
               brief: "We ask you to describe before you interpret because meaning can change. The details you capture today might reveal different patterns next month. If you interpret too quickly, you lock in one meaning and lose others.",
               expanded: """
               Here's a common experience: You write about something that happened, immediately decide what it "means," and move on. Three weeks later, you realize your interpretation was wrong—but you can't remember the actual details anymore. You only remember your interpretation.
               
               This is why we ask you to capture first.
               
               A good capture preserves the raw material:
               • What you actually saw and heard
               • What people actually said (verbatim if possible)
               • The physical details of the scene
               • The sequence of events
               
               This raw material can be interpreted and reinterpreted over time. Your weekly synthesis might see one pattern. Your monthly review might see another. A year from now, you might see something entirely different.
               
               If you skip straight to interpretation, you lose this flexibility. The capture is gone, replaced by your first (possibly wrong) meaning.
               """,
               category: .foundation,
               trigger: .firstDailyEntry
           ),
           
           DesignNote(
               id: "captures_complete",
               title: "Captures Are Complete",
               brief: "You saved a capture without interpretation. That's not incomplete—it's a deliberate choice. Some moments need to sit before meaning emerges. You can always add interpretation later, but you can't recover details you didn't capture.",
               expanded: """
               There's a cultural bias toward "processing" experiences immediately. Something happens; you should understand it; you should learn the lesson.
               
               But premature interpretation can be a trap:
               • You lock in one meaning before others can emerge
               • You lose the details in favor of the conclusion
               • You miss what the moment might reveal later
               
               Pure captures honor the reality that meaning takes time. Some things need to marinate. Some patterns only become visible when you have more data points.
               
               When you save a capture without interpretation, you're saying: "I noticed this. I don't know what it means yet. I'm preserving it for future understanding."
               
               That's not laziness or incompleteness. That's wisdom about how insight actually works.
               
               The capture is the seed. The interpretation can grow later.
               """,
               category: .dailyPractice,
               trigger: .firstPureCapture
           ),
           
           // ... (additional notes for each trigger)
       ]
       
       func shouldShow(noteId: String) -> Bool {
           guard let status = noteStatuses[noteId] else { return true }
           return !status.seen
       }
       
       func markSeen(noteId: String) {
           // Update SwiftData
       }
       
       func getNoteFor(trigger: NoteTrigger) -> DesignNote? {
           return Self.allNotes.first { $0.trigger == trigger }
       }
       
       func getAllNotes(category: NoteCategory? = nil) -> [DesignNote] {
           if let category {
               return Self.allNotes.filter { $0.category == category }
           }
           return Self.allNotes
       }
   }

3. Create DesignNoteView component:
   struct DesignNoteView: View {
       let note: DesignNote
       @State private var isExpanded = false
       let onDismiss: () -> Void
       
       var body: some View {
           VStack(alignment: .leading, spacing: 12) {
               // Header
               HStack {
                   Image(systemName: "book.closed.fill")
                   Text("Design Note")
                       .font(.caption)
                       .fontWeight(.semibold)
                   Spacer()
                   Button(action: onDismiss) {
                       Image(systemName: "xmark")
                           .font(.caption)
                   }
               }
               .foregroundStyle(.secondary)
               
               // Title
               Text(note.title)
                   .font(.headline)
               
               // Brief (always visible)
               Text(note.brief)
                   .font(.subheadline)
               
               // Expanded content
               if isExpanded {
                   Divider()
                   Text(note.expanded)
                       .font(.subheadline)
                       .foregroundStyle(.secondary)
               }
               
               // Toggle
               Button(action: { withAnimation { isExpanded.toggle() }}) {
                   HStack {
                       Text(isExpanded ? "Show less" : "Read more")
                       Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                   }
                   .font(.caption)
               }
           }
           .padding()
           .background(
               RoundedRectangle(cornerRadius: 12)
                   .fill(Color.vm.surface)
                   .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
           )
           .padding()
       }
   }

4. Create DesignNotesListView for Settings:
   struct DesignNotesListView: View {
       @State private var selectedCategory: NoteCategory?
       
       var body: some View {
           List {
               ForEach(NoteCategory.allCases, id: \.self) { category in
                   Section(header: Text(category.rawValue.capitalized)) {
                       ForEach(DesignNotesService.allNotes.filter { $0.category == category }) { note in
                           NavigationLink(destination: DesignNoteDetailView(note: note)) {
                               Text(note.title)
                           }
                       }
                   }
               }
           }
           .navigationTitle("Design Notes")
       }
   }

Verify Design Notes display correctly and persistence works.
```

---

## Phase 2: Core Screens

### BLUEPRINT 2.1: Home Screen

```
Create the Home Screen for Vicarious Me.

The home screen provides:
1. Quick action buttons for new entries (Reflection, Story, Idea, Question)
2. Tabs showing recent entries by type
3. Archive access (reflections only)
4. Current mode indicator

DESIGN CONTEXT:
- The default action is "New Reflection" which goes to Capture Mode first
- Mode is visible but not overwhelming
- Time-since indicators appear on focus types (Phase 3)

Create Views/Screens/HomeScreen.swift:

1. HomeScreen view:
   struct HomeScreen: View {
       @Environment(\.modelContext) private var modelContext
       @Query(sort: \Reflection.createdAt, order: .reverse) private var reflections: [Reflection]
       @Query(sort: \Story.createdAt, order: .reverse) private var stories: [Story]
       @Query(sort: \Idea.createdAt, order: .reverse) private var ideas: [Idea]
       @Query(sort: \Question.createdAt, order: .reverse) private var questions: [Question]
       
       @State private var selectedTab: ContentTab = .reflections
       
       enum ContentTab: String, CaseIterable {
           case reflections, stories, ideas, questions
       }
       
       var body: some View {
           NavigationStack {
               ScrollView {
                   VStack(spacing: 24) {
                       // Header
                       header
                       
                       // Quick Actions
                       quickActionButtons
                       
                       // Content Tabs
                       contentTabs
                       
                       // Entry List
                       entryList
                   }
                   .padding()
               }
               .background(Color.vm.background)
               .navigationBarTitleDisplayMode(.inline)
               .toolbar {
                   ToolbarItem(placement: .topBarTrailing) {
                       if selectedTab == .reflections {
                           NavigationLink(destination: ArchiveScreen()) {
                               Image(systemName: "archivebox")
                           }
                       }
                   }
               }
           }
       }
       
       private var header: some View {
           VStack(alignment: .leading, spacing: 4) {
               Text("Vicarious Me")
                   .font(.largeTitle)
                   .fontWeight(.bold)
               Text("Capture moments, find patterns")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
           }
           .frame(maxWidth: .infinity, alignment: .leading)
       }
       
       private var quickActionButtons: some View {
           LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
               QuickActionButton(
                   title: "New Reflection",
                   icon: "camera.fill",  // Camera = Capture first
                   color: Color.vm.capture,
                   destination: NewReflectionScreen()
               )
               QuickActionButton(
                   title: "New Story",
                   icon: "book.fill",
                   color: Color.vm.story,
                   destination: NewStoryScreen()
               )
               QuickActionButton(
                   title: "New Idea",
                   icon: "lightbulb.fill",
                   color: Color.vm.idea,
                   destination: NewIdeaScreen()
               )
               QuickActionButton(
                   title: "New Question",
                   icon: "questionmark.circle.fill",
                   color: Color.vm.question,
                   destination: NewQuestionScreen()
               )
           }
       }
       
       private var contentTabs: some View {
           ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 8) {
                   ForEach(ContentTab.allCases, id: \.self) { tab in
                       TabButton(
                           title: tab.rawValue.capitalized,
                           count: countFor(tab),
                           isSelected: selectedTab == tab,
                           action: { selectedTab = tab }
                       )
                   }
               }
           }
       }
       
       private var entryList: some View {
           LazyVStack(spacing: 12) {
               switch selectedTab {
               case .reflections:
                   ForEach(reflections.prefix(10)) { reflection in
                       ReflectionRow(reflection: reflection)
                   }
               case .stories:
                   ForEach(stories.prefix(10)) { story in
                       StoryRow(story: story)
                   }
               case .ideas:
                   ForEach(ideas.prefix(10)) { idea in
                       IdeaRow(idea: idea)
                   }
               case .questions:
                   ForEach(questions.prefix(10)) { question in
                       QuestionRow(question: question)
                   }
               }
               
               if isEmpty(selectedTab) {
                   EmptyStateView(tab: selectedTab)
               }
           }
       }
       
       private func countFor(_ tab: ContentTab) -> Int {
           switch tab {
           case .reflections: return reflections.count
           case .stories: return stories.count
           case .ideas: return ideas.count
           case .questions: return questions.count
           }
       }
       
       private func isEmpty(_ tab: ContentTab) -> Bool {
           return countFor(tab) == 0
       }
   }

2. QuickActionButton component:
   struct QuickActionButton<Destination: View>: View {
       let title: String
       let icon: String
       let color: Color
       let destination: Destination
       
       var body: some View {
           NavigationLink(destination: destination) {
               VStack(spacing: 8) {
                   Image(systemName: icon)
                       .font(.title2)
                   Text(title)
                       .font(.caption)
                       .fontWeight(.medium)
               }
               .frame(maxWidth: .infinity)
               .padding(.vertical, 16)
               .background(color.opacity(0.15))
               .foregroundStyle(color)
               .clipShape(RoundedRectangle(cornerRadius: 12))
           }
       }
   }

3. ReflectionRow component:
   struct ReflectionRow: View {
       let reflection: Reflection
       
       var body: some View {
           NavigationLink(destination: ReflectionDetailScreen(reflection: reflection)) {
               VStack(alignment: .leading, spacing: 8) {
                   // Entry type badge + time
                   HStack {
                       EntryTypeBadge(type: reflection.entryType)
                       Text(reflection.tier.rawValue.uppercased())
                           .font(.caption2)
                           .foregroundStyle(.secondary)
                       Spacer()
                       Text(reflection.createdAt.relativeFormatted)
                           .font(.caption)
                           .foregroundStyle(.secondary)
                   }
                   
                   // Capture content preview
                   Text(reflection.captureContent.prefix(80) + (reflection.captureContent.count > 80 ? "..." : ""))
                       .font(.subheadline)
                       .lineLimit(2)
               }
               .padding()
               .background(Color.vm.surface)
               .clipShape(RoundedRectangle(cornerRadius: 12))
           }
           .buttonStyle(.plain)
       }
   }

4. EntryTypeBadge component:
   struct EntryTypeBadge: View {
       let type: EntryType
       
       var body: some View {
           HStack(spacing: 4) {
               Image(systemName: icon)
               Text(label)
           }
           .font(.caption2)
           .fontWeight(.semibold)
           .foregroundStyle(color)
       }
       
       private var icon: String {
           switch type {
           case .pureCapture: return "camera.fill"
           case .groundedReflection: return "arrow.right"
           case .synthesis: return "sparkles"
           }
       }
       
       private var label: String {
           switch type {
           case .pureCapture: return "CAPTURE"
           case .groundedReflection: return "GROUNDED"
           case .synthesis: return "SYNTHESIS"
           }
       }
       
       private var color: Color {
           switch type {
           case .pureCapture: return Color.vm.capture
           case .groundedReflection: return .primary
           case .synthesis: return Color.vm.synthesis
           }
       }
   }

5. Date extension for relative formatting:
   extension Date {
       var relativeFormatted: String {
           let formatter = RelativeDateTimeFormatter()
           formatter.unitsStyle = .abbreviated
           return formatter.localizedString(for: self, relativeTo: Date())
       }
   }

Verify Home Screen displays correctly with mock data.
```

---

### BLUEPRINT 2.2: New Reflection Screen (Capture-First Flow)

```
Create the New Reflection Screen implementing the Capture-First flow.

THIS IS THE MOST IMPORTANT SCREEN IN THE APP.

The flow enforces observation before interpretation:
1. Mode indicator shows 📷 CAPTURE MODE
2. Focus type selection (optional)
3. Capture prompt + text input (REQUIRED)
4. "Save Capture Only" OR "Add Interpretation" choice
5. If adding interpretation: Synthesis prompt + text input (OPTIONAL)
6. Save → Question extraction (if daily)

CRITICAL DESIGN DECISIONS:
- Capture section must have content before proceeding
- "Save Capture Only" is prominent—not a fallback option
- Synthesis is explicitly OPTIONAL with language like "if you want"
- Mode indicator changes from 📷 to 🔮 when adding interpretation

Create Views/Screens/NewReflectionScreen.swift:

1. NewReflectionScreen view:
   struct NewReflectionScreen: View {
       @Environment(\.modelContext) private var modelContext
       @Environment(\.dismiss) private var dismiss
       @Environment(DesignNotesService.self) private var designNotes
       @Environment(PromptLibrary.self) private var promptLibrary
       
       // State
       @State private var currentStep: FlowStep = .focusSelection
       @State private var selectedFocus: FocusType?
       @State private var captureText = ""
       @State private var synthesisText = ""
       @State private var currentMode: ReflectionMode = .capture
       @State private var showDesignNote = false
       @State private var currentDesignNote: DesignNote?
       
       // AI
       @State private var extractedQuestions: [String] = []
       @State private var isExtractingQuestions = false
       @State private var showQuestionModal = false
       
       enum FlowStep {
           case focusSelection
           case capture
           case captureComplete  // Choice point
           case synthesis
           case questionExtraction
       }
       
       var body: some View {
           ZStack {
               ScrollView {
                   VStack(spacing: 24) {
                       // Mode indicator
                       ModeIndicator(mode: currentMode)
                       
                       // Flow content
                       switch currentStep {
                       case .focusSelection:
                           focusSelectionView
                       case .capture:
                           captureView
                       case .captureComplete:
                           captureCompleteView
                       case .synthesis:
                           synthesisView
                       case .questionExtraction:
                           EmptyView()  // Handled by modal
                       }
                   }
                   .padding()
               }
               
               // Design Note overlay
               if showDesignNote, let note = currentDesignNote {
                   DesignNoteView(note: note) {
                       designNotes.markSeen(noteId: note.id)
                       showDesignNote = false
                   }
               }
           }
           .navigationTitle("New Reflection")
           .navigationBarTitleDisplayMode(.inline)
           .sheet(isPresented: $showQuestionModal) {
               QuestionExtractionModal(
                   questions: extractedQuestions,
                   onSave: saveSelectedQuestions,
                   onSkip: { finishAndDismiss() }
               )
           }
           .onAppear {
               checkForDesignNote(.firstDailyEntry)
           }
       }
       
       // MARK: - Focus Selection
       
       private var focusSelectionView: some View {
           VStack(spacing: 20) {
               // Orientation prompt
               PromptView(
                   prompt: promptLibrary.getPrompt(type: .orientation)!,
                   mode: .capture
               )
               
               Text("Choose your lens (optional)")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
               
               // Focus type grid
               LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                   ForEach(FocusType.allCases, id: \.self) { focus in
                       FocusTypeButton(
                           focus: focus,
                           isSelected: selectedFocus == focus,
                           action: { selectedFocus = focus }
                       )
                   }
               }
               
               // Continue button
               Button(action: { currentStep = .capture }) {
                   Text(selectedFocus != nil ? "Continue" : "Skip to Capture")
                       .font(.headline)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.vm.capture)
                       .foregroundStyle(.white)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
               }
           }
       }
       
       // MARK: - Capture View (The Hard Part)
       
       private var captureView: some View {
           VStack(spacing: 20) {
               // Mode indicator emphasized
               HStack {
                   Image(systemName: "camera.fill")
                   Text("CAPTURE MODE")
                       .fontWeight(.semibold)
                   Text("— the hard part")
                       .foregroundStyle(.secondary)
               }
               .font(.caption)
               .foregroundStyle(Color.vm.capture)
               
               // Capture prompt
               PromptView(
                   prompt: promptLibrary.getCapturePrompt(
                       focusType: selectedFocus,
                       stage: .emerging  // TODO: Get from user profile
                   ),
                   mode: .capture
               )
               
               // Capture text input
               VStack(alignment: .leading, spacing: 8) {
                   Text("What happened?")
                       .font(.subheadline)
                       .fontWeight(.medium)
                   
                   TextEditor(text: $captureText)
                       .frame(minHeight: 200)
                       .padding(8)
                       .background(Color.vm.surface)
                       .clipShape(RoundedRectangle(cornerRadius: 8))
                       .overlay(
                           RoundedRectangle(cornerRadius: 8)
                               .stroke(Color.vm.capture.opacity(0.3), lineWidth: 1)
                       )
                   
                   Text("Describe what you observed—sights, sounds, words, actions.")
                       .font(.caption)
                       .foregroundStyle(.secondary)
               }
               
               // Continue button (requires content)
               Button(action: { currentStep = .captureComplete }) {
                   Text("Continue")
                       .font(.headline)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(captureText.isEmpty ? Color.gray : Color.vm.capture)
                       .foregroundStyle(.white)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
               }
               .disabled(captureText.isEmpty)
           }
       }
       
       // MARK: - Capture Complete (Choice Point)
       
       private var captureCompleteView: some View {
           VStack(spacing: 24) {
               // Success message
               VStack(spacing: 8) {
                   Image(systemName: "checkmark.circle.fill")
                       .font(.largeTitle)
                       .foregroundStyle(Color.vm.capture)
                   
                   Text("Capture complete")
                       .font(.title3)
                       .fontWeight(.semibold)
                   
                   Text("You've recorded the moment. That's enough—or you can explore what it means.")
                       .font(.subheadline)
                       .foregroundStyle(.secondary)
                       .multilineTextAlignment(.center)
               }
               
               // Preview of capture
               VStack(alignment: .leading, spacing: 8) {
                   Text("Your capture:")
                       .font(.caption)
                       .foregroundStyle(.secondary)
                   Text(captureText)
                       .font(.subheadline)
                       .padding()
                       .background(Color.vm.capture.opacity(0.1))
                       .clipShape(RoundedRectangle(cornerRadius: 8))
               }
               
               // Choice buttons
               VStack(spacing: 12) {
                   // Save Capture Only - PROMINENT
                   Button(action: { saveAsPureCapture() }) {
                       VStack(spacing: 4) {
                           HStack {
                               Image(systemName: "camera.fill")
                               Text("Save Capture Only")
                           }
                           .font(.headline)
                           Text("Let meaning emerge later")
                               .font(.caption)
                               .foregroundStyle(.white.opacity(0.8))
                       }
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.vm.capture)
                       .foregroundStyle(.white)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
                   }
                   
                   // Add Interpretation - Secondary
                   Button(action: { 
                       currentMode = .synthesis
                       currentStep = .synthesis 
                   }) {
                       HStack {
                           Image(systemName: "sparkles")
                           Text("Add Interpretation")
                           Image(systemName: "arrow.right")
                       }
                       .font(.headline)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.vm.synthesis.opacity(0.15))
                       .foregroundStyle(Color.vm.synthesis)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
                   }
               }
               
               // Marinate option
               Button(action: { saveAsMarinating() }) {
                   Text("Save and let it marinate")
                       .font(.subheadline)
                       .foregroundStyle(.secondary)
               }
           }
       }
       
       // MARK: - Synthesis View (Optional)
       
       private var synthesisView: some View {
           VStack(spacing: 20) {
               // Mode change indicator
               HStack {
                   Image(systemName: "sparkles")
                   Text("SYNTHESIS MODE")
                       .fontWeight(.semibold)
                   Text("— finding meaning")
                       .foregroundStyle(.secondary)
               }
               .font(.caption)
               .foregroundStyle(Color.vm.synthesis)
               
               // Synthesis prompt
               PromptView(
                   prompt: promptLibrary.getSynthesisPrompt(
                       tier: .daily,
                       stage: .emerging
                   ),
                   mode: .synthesis
               )
               
               // Show capture for reference
               VStack(alignment: .leading, spacing: 4) {
                   Text("Your capture:")
                       .font(.caption)
                       .foregroundStyle(.secondary)
                   Text(captureText)
                       .font(.caption)
                       .padding(8)
                       .background(Color.vm.capture.opacity(0.1))
                       .clipShape(RoundedRectangle(cornerRadius: 6))
               }
               
               // Synthesis text input
               VStack(alignment: .leading, spacing: 8) {
                   Text("What does it mean? (optional)")
                       .font(.subheadline)
                       .fontWeight(.medium)
                   
                   TextEditor(text: $synthesisText)
                       .frame(minHeight: 150)
                       .padding(8)
                       .background(Color.vm.surface)
                       .clipShape(RoundedRectangle(cornerRadius: 8))
                       .overlay(
                           RoundedRectangle(cornerRadius: 8)
                               .stroke(Color.vm.synthesis.opacity(0.3), lineWidth: 1)
                       )
               }
               
               // Save buttons
               VStack(spacing: 12) {
                   Button(action: { saveAsGroundedReflection() }) {
                       Text("Save Reflection")
                           .font(.headline)
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(synthesisText.isEmpty ? Color.vm.capture : Color.vm.synthesis)
                           .foregroundStyle(.white)
                           .clipShape(RoundedRectangle(cornerRadius: 12))
                   }
                   
                   if !synthesisText.isEmpty {
                       Button(action: { 
                           synthesisText = ""
                           saveAsPureCapture()
                       }) {
                           Text("Actually, just save the capture")
                               .font(.subheadline)
                               .foregroundStyle(.secondary)
                       }
                   }
               }
           }
       }
       
       // MARK: - Actions
       
       private func saveAsPureCapture() {
           let reflection = createReflection(entryType: .pureCapture)
           modelContext.insert(reflection)
           checkForDesignNote(.firstPureCapture)
           triggerQuestionExtraction(for: reflection)
       }
       
       private func saveAsMarinating() {
           let reflection = createReflection(entryType: .pureCapture)
           reflection.marinating = true
           modelContext.insert(reflection)
           finishAndDismiss()
       }
       
       private func saveAsGroundedReflection() {
           let reflection = createReflection(
               entryType: synthesisText.isEmpty ? .pureCapture : .groundedReflection
           )
           modelContext.insert(reflection)
           triggerQuestionExtraction(for: reflection)
       }
       
       private func createReflection(entryType: EntryType) -> Reflection {
           Reflection(
               id: UUID(),
               createdAt: Date(),
               updatedAt: Date(),
               tier: .daily,
               focusType: selectedFocus,
               captureContent: captureText,
               synthesisContent: synthesisText.isEmpty ? nil : synthesisText,
               entryType: entryType,
               modeBalance: calculateModeBalance(),
               themes: [],
               marinating: false
           )
       }
       
       private func calculateModeBalance() -> ModeBalance {
           if synthesisText.isEmpty { return .captureOnly }
           let captureLength = captureText.count
           let synthesisLength = synthesisText.count
           let ratio = Double(captureLength) / Double(captureLength + synthesisLength)
           if ratio > 0.7 { return .captureHeavy }
           if ratio < 0.3 { return .synthesisHeavy }
           return .balanced
       }
       
       private func triggerQuestionExtraction(for reflection: Reflection) {
           isExtractingQuestions = true
           // Call AI service
           Task {
               extractedQuestions = await AIService.shared.extractQuestions(from: reflection.captureContent)
               isExtractingQuestions = false
               if !extractedQuestions.isEmpty {
                   showQuestionModal = true
               } else {
                   finishAndDismiss()
               }
           }
       }
       
       private func saveSelectedQuestions(_ selected: [String]) {
           // Save to Question model
           for questionText in selected {
               let question = Question(
                   id: UUID(),
                   createdAt: Date(),
                   content: questionText,
                   answered: false
               )
               modelContext.insert(question)
           }
           finishAndDismiss()
       }
       
       private func finishAndDismiss() {
           dismiss()
       }
       
       private func checkForDesignNote(_ trigger: NoteTrigger) {
           if let note = designNotes.getNoteFor(trigger: trigger),
              designNotes.shouldShow(noteId: note.id) {
               currentDesignNote = note
               showDesignNote = true
           }
       }
   }

2. ModeIndicator component:
   struct ModeIndicator: View {
       let mode: ReflectionMode
       
       var body: some View {
           HStack {
               Image(systemName: mode == .capture ? "camera.fill" : "sparkles")
               Text(mode == .capture ? "CAPTURE MODE" : "SYNTHESIS MODE")
                   .fontWeight(.semibold)
           }
           .font(.caption)
           .foregroundStyle(mode == .capture ? Color.vm.capture : Color.vm.synthesis)
           .padding(.horizontal, 12)
           .padding(.vertical, 6)
           .background(
               Capsule()
                   .fill(mode == .capture ? Color.vm.capture.opacity(0.15) : Color.vm.synthesis.opacity(0.15))
           )
       }
   }

3. FocusTypeButton component:
   struct FocusTypeButton: View {
       let focus: FocusType
       let isSelected: Bool
       let action: () -> Void
       
       var body: some View {
           Button(action: action) {
               Text(focus.rawValue.capitalized)
                   .font(.subheadline)
                   .padding(.horizontal, 12)
                   .padding(.vertical, 8)
                   .background(isSelected ? Color.vm.capture : Color.vm.surface)
                   .foregroundStyle(isSelected ? .white : .primary)
                   .clipShape(RoundedRectangle(cornerRadius: 8))
           }
       }
   }

Verify the Capture-First flow works correctly with proper mode transitions.
```

---

### BLUEPRINT 2.3: Weekly Reflection Screen (Synthesis Flow)

```
Create the Weekly Reflection Screen implementing the aggregation/synthesis flow.

Weekly reflections:
1. Show all daily captures from the past 7 days
2. Offer "revision layer" option for each capture
3. Surface AI-detected connections
4. Prompt for synthesis (NOT summary)
5. Mode is 🔮 SYNTHESIS throughout

CRITICAL DESIGN CONTEXT:
- This is where interpretation is appropriate—with distance
- Grounding check: Can user point to captures supporting their synthesis?
- Summary vs. Synthesis distinction must be clear

Create Views/Screens/WeeklyReflectionScreen.swift:

1. WeeklyReflectionScreen view:
   struct WeeklyReflectionScreen: View {
       @Environment(\.modelContext) private var modelContext
       @Environment(\.dismiss) private var dismiss
       @Environment(PromptLibrary.self) private var promptLibrary
       
       @Query private var reflections: [Reflection]
       
       @State private var selectedReflections: Set<UUID> = []
       @State private var revisionLayers: [UUID: String] = [:]
       @State private var synthesisText = ""
       @State private var showConnectionSurfacer = false
       @State private var detectedConnections: [Connection] = []
       @State private var currentStep: SynthesisStep = .review
       
       enum SynthesisStep {
           case review      // View and select captures
           case revise      // Add revision layers
           case synthesize  // Write synthesis
       }
       
       var dailyReflections: [Reflection] {
           let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
           return reflections.filter { 
               $0.tier == .daily && $0.createdAt >= weekAgo 
           }.sorted { $0.createdAt < $1.createdAt }
       }
       
       var body: some View {
           ScrollView {
               VStack(spacing: 24) {
                   // Mode indicator
                   ModeIndicator(mode: .synthesis)
                   
                   // Progress indicator
                   StepIndicator(currentStep: currentStep)
                   
                   switch currentStep {
                   case .review:
                       reviewView
                   case .revise:
                       reviseView
                   case .synthesize:
                       synthesizeView
                   }
               }
               .padding()
           }
           .navigationTitle("Weekly Reflection")
           .sheet(isPresented: $showConnectionSurfacer) {
               ConnectionSurfacerView(connections: detectedConnections)
           }
           .onAppear {
               loadConnections()
           }
       }
       
       // MARK: - Review Step
       
       private var reviewView: some View {
           VStack(spacing: 20) {
               Text("Your captures from this week")
                   .font(.headline)
               
               if dailyReflections.isEmpty {
                   emptyWeekView
               } else {
                   // List of captures with selection
                   ForEach(dailyReflections) { reflection in
                       CaptureSelectionRow(
                           reflection: reflection,
                           isSelected: selectedReflections.contains(reflection.id),
                           onToggle: { toggleSelection(reflection.id) }
                       )
                   }
                   
                   // Connection surfacer button
                   if !detectedConnections.isEmpty {
                       Button(action: { showConnectionSurfacer = true }) {
                           HStack {
                               Image(systemName: "link")
                               Text("See \(detectedConnections.count) detected connections")
                           }
                           .font(.subheadline)
                           .foregroundStyle(Color.vm.synthesis)
                       }
                   }
                   
                   // Continue button
                   Button(action: { currentStep = .revise }) {
                       Text("Continue to Revision")
                           .font(.headline)
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.vm.synthesis)
                           .foregroundStyle(.white)
                           .clipShape(RoundedRectangle(cornerRadius: 12))
                   }
               }
           }
       }
       
       // MARK: - Revise Step
       
       private var reviseView: some View {
           VStack(spacing: 20) {
               VStack(spacing: 8) {
                   Text("Add revision layers")
                       .font(.headline)
                   Text("What do you see now that you didn't see then?")
                       .font(.subheadline)
                       .foregroundStyle(.secondary)
               }
               
               ForEach(dailyReflections.filter { selectedReflections.contains($0.id) }) { reflection in
                   RevisionLayerCard(
                       reflection: reflection,
                       revisionText: Binding(
                           get: { revisionLayers[reflection.id] ?? "" },
                           set: { revisionLayers[reflection.id] = $0 }
                       )
                   )
               }
               
               // Continue button
               Button(action: { currentStep = .synthesize }) {
                   Text("Continue to Synthesis")
                       .font(.headline)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.vm.synthesis)
                       .foregroundStyle(.white)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
               }
           }
       }
       
       // MARK: - Synthesize Step
       
       private var synthesizeView: some View {
           VStack(spacing: 20) {
               // Synthesis prompt
               PromptView(
                   prompt: promptLibrary.getAggregationPrompt(tier: .weekly),
                   mode: .synthesis
               )
               
               // Synthesis guidance
               VStack(alignment: .leading, spacing: 12) {
                   Text("Before you write, consider:")
                       .font(.subheadline)
                       .fontWeight(.medium)
                   
                   SynthesisGuideItem(
                       icon: "link",
                       text: "What thread runs through these moments?"
                   )
                   SynthesisGuideItem(
                       icon: "questionmark.circle",
                       text: "What question is this week asking you?"
                   )
                   SynthesisGuideItem(
                       icon: "sparkles",
                       text: "What do you understand now that you didn't before?"
                   )
               }
               .padding()
               .background(Color.vm.synthesis.opacity(0.1))
               .clipShape(RoundedRectangle(cornerRadius: 12))
               
               // Synthesis input
               VStack(alignment: .leading, spacing: 8) {
                   HStack {
                       Text("Your synthesis")
                           .font(.subheadline)
                           .fontWeight(.medium)
                       Spacer()
                       Text("Don't summarize—generate")
                           .font(.caption)
                           .foregroundStyle(.secondary)
                   }
                   
                   TextEditor(text: $synthesisText)
                       .frame(minHeight: 200)
                       .padding(8)
                       .background(Color.vm.surface)
                       .clipShape(RoundedRectangle(cornerRadius: 8))
                       .overlay(
                           RoundedRectangle(cornerRadius: 8)
                               .stroke(Color.vm.synthesis.opacity(0.3), lineWidth: 1)
                       )
               }
               
               // Save button
               Button(action: saveWeeklySynthesis) {
                   Text("Save Weekly Reflection")
                       .font(.headline)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(synthesisText.isEmpty ? Color.gray : Color.vm.synthesis)
                       .foregroundStyle(.white)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
               }
               .disabled(synthesisText.isEmpty)
           }
       }
       
       // MARK: - Supporting Views
       
       private var emptyWeekView: some View {
           VStack(spacing: 16) {
               Image(systemName: "camera")
                   .font(.largeTitle)
                   .foregroundStyle(.secondary)
               Text("No captures this week")
                   .font(.headline)
               Text("Weekly synthesis works best with daily captures to draw from.")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
                   .multilineTextAlignment(.center)
               
               NavigationLink(destination: NewReflectionScreen()) {
                   Text("Create a Capture")
                       .font(.headline)
                       .foregroundStyle(Color.vm.capture)
               }
           }
           .padding()
       }
       
       // MARK: - Actions
       
       private func toggleSelection(_ id: UUID) {
           if selectedReflections.contains(id) {
               selectedReflections.remove(id)
           } else {
               selectedReflections.insert(id)
           }
       }
       
       private func loadConnections() {
           Task {
               detectedConnections = await AIService.shared.detectConnections(in: dailyReflections)
           }
       }
       
       private func saveWeeklySynthesis() {
           // Save revision layers first
           for (reflectionId, layerText) in revisionLayers where !layerText.isEmpty {
               if let reflection = dailyReflections.first(where: { $0.id == reflectionId }) {
                   let layer = RevisionLayer(
                       id: UUID(),
                       addedAt: Date(),
                       content: layerText,
                       revisionType: .reframing
                   )
                   reflection.revisionLayers.append(layer)
               }
           }
           
           // Create weekly synthesis
           let synthesis = Reflection(
               id: UUID(),
               createdAt: Date(),
               updatedAt: Date(),
               tier: .weekly,
               focusType: nil,
               captureContent: "",  // No capture for synthesis entries
               synthesisContent: synthesisText,
               entryType: .synthesis,
               modeBalance: .synthesisOnly,
               themes: [],
               marinating: false
           )
           
           // Link to source reflections
           synthesis.linkedReflections = dailyReflections.filter { selectedReflections.contains($0.id) }
           
           modelContext.insert(synthesis)
           dismiss()
       }
   }

2. CaptureSelectionRow component:
   struct CaptureSelectionRow: View {
       let reflection: Reflection
       let isSelected: Bool
       let onToggle: () -> Void
       
       var body: some View {
           Button(action: onToggle) {
               HStack(alignment: .top, spacing: 12) {
                   Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                       .foregroundStyle(isSelected ? Color.vm.synthesis : .secondary)
                   
                   VStack(alignment: .leading, spacing: 4) {
                       Text(reflection.createdAt.formatted(date: .abbreviated, time: .omitted))
                           .font(.caption)
                           .foregroundStyle(.secondary)
                       Text(reflection.captureContent)
                           .font(.subheadline)
                           .lineLimit(3)
                           .multilineTextAlignment(.leading)
                   }
               }
               .padding()
               .background(isSelected ? Color.vm.synthesis.opacity(0.1) : Color.vm.surface)
               .clipShape(RoundedRectangle(cornerRadius: 12))
           }
           .buttonStyle(.plain)
       }
   }

3. RevisionLayerCard component:
   struct RevisionLayerCard: View {
       let reflection: Reflection
       @Binding var revisionText: String
       @State private var isExpanded = false
       
       var body: some View {
           VStack(alignment: .leading, spacing: 12) {
               // Original capture
               VStack(alignment: .leading, spacing: 4) {
                   Text(reflection.createdAt.formatted(date: .abbreviated, time: .omitted))
                       .font(.caption)
                       .foregroundStyle(.secondary)
                   Text(reflection.captureContent)
                       .font(.subheadline)
               }
               
               // Revision input
               if isExpanded {
                   VStack(alignment: .leading, spacing: 4) {
                       Text("What do you see now?")
                           .font(.caption)
                           .foregroundStyle(Color.vm.synthesis)
                       TextField("Add revision layer...", text: $revisionText, axis: .vertical)
                           .lineLimit(3...6)
                           .padding(8)
                           .background(Color.vm.synthesis.opacity(0.1))
                           .clipShape(RoundedRectangle(cornerRadius: 8))
                   }
               }
               
               // Toggle button
               Button(action: { isExpanded.toggle() }) {
                   HStack {
                       Image(systemName: "plus.circle")
                       Text(isExpanded ? "Collapse" : "Add revision layer")
                   }
                   .font(.caption)
                   .foregroundStyle(Color.vm.synthesis)
               }
           }
           .padding()
           .background(Color.vm.surface)
           .clipShape(RoundedRectangle(cornerRadius: 12))
       }
   }

Verify Weekly Reflection flow with revision layers and synthesis guidance.
```

---

## Phase 3: AI Integration

### BLUEPRINT 3.1: AI Service (Question Extraction & Connections)

```
Create the AI Service for Vicarious Me.

AI PHILOSOPHY (Critical):
- AI EXTRACTS from user's words—it never generates content
- AI SURFACES patterns—it doesn't interpret meaning
- AI PROVIDES FEEDBACK on capture quality—not judgment

Three AI capabilities:
1. Question extraction (from daily captures)
2. Connection detection (across entries)
3. Capture quality assessment (observation feedback)

Create Services/AI/AIService.swift:

1. AIService singleton:
   @Observable
   class AIService {
       static let shared = AIService()
       
       private let apiKey: String
       private let baseURL = "https://api.openai.com/v1/chat/completions"
       
       private init() {
           // Load from Keychain
           apiKey = KeychainService.shared.get("openai_api_key") ?? ""
       }
       
       // MARK: - Question Extraction
       
       func extractQuestions(from text: String) async -> [String] {
           let systemPrompt = """
           You are a narrative researcher. Extract 1-3 questions that seem to be 
           implied or embedded in the text below.
           
           CRITICAL RULES:
           - Extract questions the USER is asking (perhaps unconsciously), not questions YOU have
           - DO NOT interpret emotions or provide therapy
           - DO NOT give self-help or advice-seeking questions
           - Only extract questions grounded in narrative, observation, or curiosity
           - Return only the questions, one per line
           - If no questions are found, return empty
           
           The questions should be what the text seems to be wondering about, 
           not what you think the person should be asking.
           """
           
           let response = await callGPT(
               system: systemPrompt,
               user: text,
               temperature: 0.3,
               maxTokens: 300
           )
           
           guard let content = response else { return [] }
           
           return content
               .components(separatedBy: "\n")
               .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
               .filter { !$0.isEmpty && !$0.hasPrefix("-") }
               .map { $0.hasPrefix("•") ? String($0.dropFirst()).trimmingCharacters(in: .whitespaces) : $0 }
       }
       
       // MARK: - Connection Detection
       
       func detectConnections(in reflections: [Reflection]) async -> [Connection] {
           guard reflections.count >= 2 else { return [] }
           
           let entrySummaries = reflections.map { reflection in
               "[\(reflection.id.uuidString.prefix(8))]: \(reflection.captureContent.prefix(200))"
           }.joined(separator: "\n\n")
           
           let systemPrompt = """
           You are analyzing a set of journal entries for potential connections.
           
           CRITICAL: You are surfacing POSSIBLE connections, not interpreting meaning.
           The user decides if connections are meaningful.
           
           Look for:
           - Recurring themes or concerns
           - Same people, places, or situations
           - Contrasts or tensions between entries
           - Patterns the user might not notice
           
           Return JSON array of connections:
           [
             {
               "entry_ids": ["id1", "id2"],
               "connection_type": "theme|person|place|contrast|pattern",
               "description": "Brief description of the possible connection"
             }
           ]
           
           Return empty array [] if no meaningful connections found.
           Do not force connections that aren't there.
           """
           
           let response = await callGPT(
               system: systemPrompt,
               user: entrySummaries,
               temperature: 0.3,
               maxTokens: 500
           )
           
           guard let content = response,
                 let data = content.data(using: .utf8),
                 let connections = try? JSONDecoder().decode([ConnectionDTO].self, from: data)
           else { return [] }
           
           return connections.compactMap { dto -> Connection? in
               guard dto.entry_ids.count >= 2 else { return nil }
               return Connection(
                   entryIds: dto.entry_ids,
                   type: ConnectionType(rawValue: dto.connection_type) ?? .theme,
                   description: dto.description
               )
           }
       }
       
       // MARK: - Capture Quality Assessment
       
       func assessCaptureQuality(_ text: String) async -> CaptureQuality {
           let systemPrompt = """
           Assess this journal entry for OBSERVATIONAL quality (not interpretation quality).
           
           We value:
           - Specificity: Concrete details vs. generalizations
           - Sensory detail: What was seen, heard, smelled, felt
           - Verbatim quotes: Actual words people said
           - Behavioral observation: What people DID (not what they felt)
           
           Return JSON:
           {
             "specificity": "emerging|developing|strong",
             "sensory_detail": "emerging|developing|strong",
             "verbatim_presence": true|false,
             "behavioral_vs_emotional": 0.0-1.0,
             "suggestions": ["suggestion1", "suggestion2"]
           }
           
           Suggestions should be gentle prompts like:
           - "What did you actually see?"
           - "Can you recall any exact words?"
           - "Where exactly were you?"
           
           NOT judgments like "Your writing lacks detail."
           """
           
           let response = await callGPT(
               system: systemPrompt,
               user: text,
               temperature: 0.2,
               maxTokens: 300
           )
           
           guard let content = response,
                 let data = content.data(using: .utf8),
                 let dto = try? JSONDecoder().decode(CaptureQualityDTO.self, from: data)
           else {
               return CaptureQuality(
                   specificity: .emerging,
                   sensoryDetail: .emerging,
                   verbatimPresence: false,
                   behavioralVsEmotional: 0.5,
                   suggestions: []
               )
           }
           
           return CaptureQuality(
               specificity: QualityLevel(rawValue: dto.specificity) ?? .emerging,
               sensoryDetail: QualityLevel(rawValue: dto.sensory_detail) ?? .emerging,
               verbatimPresence: dto.verbatim_presence,
               behavioralVsEmotional: dto.behavioral_vs_emotional,
               suggestions: dto.suggestions
           )
       }
       
       // MARK: - Interpretation Drift Detection
       
       func detectInterpretationDrift(in reflections: [Reflection]) -> Bool {
           // Check if user consistently skips to interpretation without capture
           let recentReflections = reflections.suffix(5)
           
           let pureInterpretationCount = recentReflections.filter { reflection in
               // Heuristic: High synthesis, low capture quality
               let hasInterpretationMarkers = reflection.captureContent.contains("I realized") ||
                   reflection.captureContent.contains("I think") ||
                   reflection.captureContent.contains("this means") ||
                   reflection.captureContent.contains("I learned")
               
               let lowSensoryDetail = !reflection.captureContent.contains(where: { 
                   ["saw", "heard", "felt", "said", "looked", "sounded"].contains(String($0)) 
               })
               
               return hasInterpretationMarkers && lowSensoryDetail
           }.count
           
           return pureInterpretationCount >= 3
       }
       
       // MARK: - API Call
       
       private func callGPT(system: String, user: String, temperature: Double, maxTokens: Int) async -> String? {
           guard !apiKey.isEmpty else { return nil }
           
           var request = URLRequest(url: URL(string: baseURL)!)
           request.httpMethod = "POST"
           request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let body: [String: Any] = [
               "model": "gpt-4o",
               "messages": [
                   ["role": "system", "content": system],
                   ["role": "user", "content": user]
               ],
               "temperature": temperature,
               "max_tokens": maxTokens
           ]
           
           request.httpBody = try? JSONSerialization.data(withJSONObject: body)
           
           do {
               let (data, _) = try await URLSession.shared.data(for: request)
               let response = try JSONDecoder().decode(GPTResponse.self, from: data)
               return response.choices.first?.message.content
           } catch {
               print("AI Service Error: \(error)")
               return nil
           }
       }
   }

2. Supporting types:
   struct Connection: Identifiable {
       let id = UUID()
       let entryIds: [String]
       let type: ConnectionType
       let description: String
   }
   
   enum ConnectionType: String, Codable {
       case theme, person, place, contrast, pattern
   }
   
   struct ConnectionDTO: Codable {
       let entry_ids: [String]
       let connection_type: String
       let description: String
   }
   
   struct CaptureQualityDTO: Codable {
       let specificity: String
       let sensory_detail: String
       let verbatim_presence: Bool
       let behavioral_vs_emotional: Double
       let suggestions: [String]
   }
   
   struct GPTResponse: Codable {
       let choices: [Choice]
       struct Choice: Codable {
           let message: Message
       }
       struct Message: Codable {
           let content: String
       }
   }

3. KeychainService for API key storage:
   class KeychainService {
       static let shared = KeychainService()
       
       func set(_ value: String, for key: String) {
           // Implement Keychain storage
       }
       
       func get(_ key: String) -> String? {
           // Implement Keychain retrieval
       }
   }

Verify AI service with test prompts. Check that outputs match philosophy (extract, don't generate).
```

---

## Phase 4: Supporting Screens

### BLUEPRINT 4.1: Quick Capture Mode

```
Create Quick Capture mode for minimal friction entry.

Quick Capture is for users who need to capture something NOW without the full flow.
- One prompt: "What's on your mind? Just capture it."
- One text field
- One save button
- No focus type, no interpretation, no question extraction
- Entry saved as pure capture

This is ADHD-friendly: minimal decisions, maximum speed.

Create Views/Screens/QuickCaptureScreen.swift:

struct QuickCaptureScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var captureText = ""
    @FocusState private var isTextFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Mode indicator
            HStack {
                Image(systemName: "bolt.fill")
                Text("QUICK CAPTURE")
                    .fontWeight(.semibold)
            }
            .font(.caption)
            .foregroundStyle(Color.vm.capture)
            
            // Prompt
            Text("What's on your mind? Just capture it.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Text input
            TextEditor(text: $captureText)
                .focused($isTextFocused)
                .frame(minHeight: 150)
                .padding(8)
                .background(Color.vm.surface)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.vm.capture.opacity(0.3), lineWidth: 1)
                )
            
            Spacer()
            
            // Save button
            Button(action: saveAndDismiss) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Save")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(captureText.isEmpty ? Color.gray : Color.vm.capture)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(captureText.isEmpty)
        }
        .padding()
        .navigationTitle("Quick Capture")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isTextFocused = true
        }
    }
    
    private func saveAndDismiss() {
        let reflection = Reflection(
            id: UUID(),
            createdAt: Date(),
            updatedAt: Date(),
            tier: .daily,
            focusType: nil,
            captureContent: captureText,
            synthesisContent: nil,
            entryType: .pureCapture,
            modeBalance: .captureOnly,
            themes: [],
            marinating: false
        )
        modelContext.insert(reflection)
        dismiss()
    }
}

Add Quick Capture as an option on Home Screen and as a widget action.
```

---

### BLUEPRINT 4.2: Onboarding Flow

```
Create the Onboarding flow for Vicarious Me.

Onboarding teaches the Two Modes framework FIRST—before any other features.
The key message: Observation is the harder skill. We train it.

Pages:
1. Welcome
2. Two Modes (most important)
3. Observation Is Hard (the insight)
4. AI Philosophy
5. Get Started

Create Views/Screens/OnboardingScreen.swift:

1. OnboardingScreen container:
   struct OnboardingScreen: View {
       @Environment(AppState.self) private var appState
       @State private var currentPage = 0
       
       var body: some View {
           TabView(selection: $currentPage) {
               WelcomePage()
                   .tag(0)
               TwoModesPage()
                   .tag(1)
               ObservationIsHardPage()
                   .tag(2)
               AIPhilosophyPage()
                   .tag(3)
               GetStartedPage(onComplete: completeOnboarding)
                   .tag(4)
           }
           .tabViewStyle(.page)
           .indexViewStyle(.page(backgroundDisplayMode: .always))
       }
       
       private func completeOnboarding() {
           appState.hasCompletedOnboarding = true
       }
   }

2. WelcomePage:
   struct WelcomePage: View {
       var body: some View {
           VStack(spacing: 24) {
               Spacer()
               
               Image(systemName: "eyes")
                   .font(.system(size: 60))
                   .foregroundStyle(Color.vm.capture)
               
               Text("Vicarious Me")
                   .font(.largeTitle)
                   .fontWeight(.bold)
               
               Text("See your life clearly.\nUnderstand it deeply.")
                   .font(.title3)
                   .foregroundStyle(.secondary)
                   .multilineTextAlignment(.center)
               
               Spacer()
               Spacer()
           }
       }
   }

3. TwoModesPage (CRITICAL):
   struct TwoModesPage: View {
       var body: some View {
           VStack(spacing: 24) {
               Spacer()
               
               Text("Two Modes")
                   .font(.title)
                   .fontWeight(.bold)
               
               VStack(spacing: 16) {
                   // Capture Mode
                   HStack(spacing: 16) {
                       Image(systemName: "camera.fill")
                           .font(.title)
                           .foregroundStyle(Color.vm.capture)
                           .frame(width: 50)
                       
                       VStack(alignment: .leading, spacing: 4) {
                           Text("Capture")
                               .font(.headline)
                               .foregroundStyle(Color.vm.capture)
                           Text("Record what happened")
                               .font(.subheadline)
                               .foregroundStyle(.secondary)
                       }
                       Spacer()
                   }
                   .padding()
                   .background(Color.vm.capture.opacity(0.1))
                   .clipShape(RoundedRectangle(cornerRadius: 12))
                   
                   // Arrow
                   Image(systemName: "arrow.down")
                       .font(.title2)
                       .foregroundStyle(.secondary)
                   
                   // Synthesis Mode
                   HStack(spacing: 16) {
                       Image(systemName: "sparkles")
                           .font(.title)
                           .foregroundStyle(Color.vm.synthesis)
                           .frame(width: 50)
                       
                       VStack(alignment: .leading, spacing: 4) {
                           Text("Synthesis")
                               .font(.headline)
                               .foregroundStyle(Color.vm.synthesis)
                           Text("Find what it means")
                               .font(.subheadline)
                               .foregroundStyle(.secondary)
                       }
                       Spacer()
                   }
                   .padding()
                   .background(Color.vm.synthesis.opacity(0.1))
                   .clipShape(RoundedRectangle(cornerRadius: 12))
               }
               .padding(.horizontal, 32)
               
               Text("Most apps blur these together.\nWe keep them separate.")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
                   .multilineTextAlignment(.center)
               
               Spacer()
               Spacer()
           }
       }
   }

4. ObservationIsHardPage (THE INSIGHT):
   struct ObservationIsHardPage: View {
       var body: some View {
           VStack(spacing: 24) {
               Spacer()
               
               Text("Here's the surprising thing")
                   .font(.title2)
                   .fontWeight(.bold)
               
               VStack(spacing: 20) {
                   // Interpretation is easy
                   VStack(spacing: 8) {
                       HStack {
                           Image(systemName: "sparkles")
                               .foregroundStyle(Color.vm.synthesis)
                           Text("Interpretation is easy")
                               .fontWeight(.semibold)
                       }
                       Text("We do it automatically. The moment something happens, we're already deciding what it means.")
                           .font(.subheadline)
                           .foregroundStyle(.secondary)
                           .multilineTextAlignment(.center)
                   }
                   
                   // Divider
                   Rectangle()
                       .fill(Color.secondary.opacity(0.3))
                       .frame(height: 1)
                       .padding(.horizontal, 40)
                   
                   // Observation is hard
                   VStack(spacing: 8) {
                       HStack {
                           Image(systemName: "camera.fill")
                               .foregroundStyle(Color.vm.capture)
                           Text("Observation is hard")
                               .fontWeight(.semibold)
                       }
                       Text("Staying with what happened—the details, the words, the sequence—without sliding into meaning? That takes discipline.")
                           .font(.subheadline)
                           .foregroundStyle(.secondary)
                           .multilineTextAlignment(.center)
                   }
               }
               .padding(.horizontal, 24)
               
               // The point
               Text("Vicarious Me trains observation first.\nIt's the harder skill—and the foundation.")
                   .font(.subheadline)
                   .fontWeight(.medium)
                   .foregroundStyle(Color.vm.capture)
                   .multilineTextAlignment(.center)
                   .padding()
                   .background(Color.vm.capture.opacity(0.1))
                   .clipShape(RoundedRectangle(cornerRadius: 12))
                   .padding(.horizontal, 24)
               
               Spacer()
               Spacer()
           }
       }
   }

5. AIPhilosophyPage:
   struct AIPhilosophyPage: View {
       var body: some View {
           VStack(spacing: 24) {
               Spacer()
               
               Image(systemName: "brain.head.profile")
                   .font(.system(size: 50))
                   .foregroundStyle(.secondary)
               
               Text("AI extracts.\nIt never writes.")
                   .font(.title2)
                   .fontWeight(.bold)
                   .multilineTextAlignment(.center)
               
               VStack(alignment: .leading, spacing: 12) {
                   AIFeatureRow(icon: "text.magnifyingglass", text: "Surfaces questions from your words")
                   AIFeatureRow(icon: "link", text: "Finds connections you might miss")
                   AIFeatureRow(icon: "eye", text: "Gives feedback on observation quality")
               }
               .padding(.horizontal, 32)
               
               Text("The reflection is yours.\nAI is a mirror, not an author.")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
                   .multilineTextAlignment(.center)
               
               Spacer()
               Spacer()
           }
       }
   }
   
   struct AIFeatureRow: View {
       let icon: String
       let text: String
       
       var body: some View {
           HStack(spacing: 12) {
               Image(systemName: icon)
                   .frame(width: 24)
                   .foregroundStyle(Color.vm.synthesis)
               Text(text)
                   .font(.subheadline)
           }
       }
   }

6. GetStartedPage:
   struct GetStartedPage: View {
       let onComplete: () -> Void
       
       var body: some View {
           VStack(spacing: 32) {
               Spacer()
               
               Image(systemName: "checkmark.circle.fill")
                   .font(.system(size: 60))
                   .foregroundStyle(Color.vm.capture)
               
               Text("Ready to begin")
                   .font(.title)
                   .fontWeight(.bold)
               
               Text("Start with a capture.\nMeaning can come later.")
                   .font(.subheadline)
                   .foregroundStyle(.secondary)
                   .multilineTextAlignment(.center)
               
               Spacer()
               
               Button(action: onComplete) {
                   Text("Start Capturing")
                       .font(.headline)
                       .foregroundStyle(.white)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Color.vm.capture)
                       .clipShape(RoundedRectangle(cornerRadius: 12))
               }
               .padding(.horizontal, 32)
               
               Spacer()
           }
       }
   }

Update VicariousMeApp to show OnboardingScreen when hasCompletedOnboarding is false.
```

---

## Summary

### Blueprint Order (Recommended)

**Foundation (Phase 1):** 1.1 → 1.2 → 1.3 → 1.4
*Establishes Two Modes framework, models, prompts, design notes*

**Core Screens (Phase 2):** 2.1 → 2.2 → 2.3
*Home, Daily Capture-First flow, Weekly Synthesis flow*

**AI Integration (Phase 3):** 3.1
*Question extraction, connection detection, capture quality*

**Supporting Screens (Phase 4):** 4.1 → 4.2
*Quick Capture, Onboarding*

**Additional Phases (Future):**
- Phase 5: Archive & Detail screens
- Phase 6: Monthly/Quarterly/Yearly aggregation
- Phase 7: Settings, Theme Navigator, Writing Growth Portrait
- Phase 8: Polish & Animations

### Key Principles Embedded Throughout

1. **Observation is harder than interpretation** — This is stated explicitly in onboarding and reinforced by UI design
2. **Capture Mode (📷) before Synthesis Mode (🔮)** — Enforced in daily flow
3. **Pure captures are complete** — "Save Capture Only" is prominent, not a fallback
4. **AI extracts, never writes** — Question extraction and connections come from user's words
5. **Progressive disclosure** — Design Notes appear contextually

### API Keys Required

- **OpenAI API Key** (GPT-4o for extraction/analysis) — Phase 3

Store securely in Keychain. Never hardcode.

### Key iOS Frameworks

- **SwiftUI** — All UI
- **SwiftData** — Persistence  
- **Observation** — State management
- **URLSession** — API calls

### Future Enhancements

- Apple Intelligence integration for on-device analysis
- CloudKit sync
- Widgets for Quick Capture
- watchOS companion for micro-captures
- Siri Shortcuts ("Hey Siri, capture this")

---

*End of Vicarious Me iOS Development Blueprints*

# VICARIOUS ME — ENHANCEMENT SPECIFICATION
## From Reflection Tool to Cognitive Development Platform

*Based on: "Reflection as Cognitive Architecture: Evidence for Structured Writing in Neurodivergent Minds"*

---

## EXECUTIVE SUMMARY

### The Core Insight

**Observation is exponentially harder than interpretation.**

Most apps—and most people—assume interpretation is the "advanced" skill. This is backwards.

- **Interpretation is easy.** We do it automatically, constantly, often without noticing. The moment something happens, we're already deciding what it means. "I felt anxious." "She was being dismissive." "It was a good day." These interpretations arrive unbidden.

- **Observation is hard.** Staying with what actually happened—the sensory details, the exact words, the sequence of events—without sliding into meaning requires real discipline. "What did you actually see?" is a harder question than "What did you learn?"

This insight inverts the typical design. We don't train users to "go deeper" from description to interpretation. We train them to develop the **harder skill first**—observation—so that when they do interpret, their interpretations are grounded in something real.

### What This Means for Design

**Capture before synthesis.** Daily entries require observation before offering interpretation. Users can save pure captures. "Save Capture Only" is prominent, not a fallback.

**Separation, not hierarchy.** Capture Mode (📷) and Synthesis Mode (🔮) are different cognitive activities, not levels where "deeper is better." A vivid capture is as valuable as a deep interpretation—and more rare.

**Earned interpretation.** Weekly and monthly synthesis are the appropriate place for meaning-making. By then, users have distance and accumulated raw material. Interpretation is powerful when grounded.

### Product Vision

Transform Vicarious Me from a reflection capture tool into a **cognitive development platform** that:

1. **Trains observation** as the foundational (harder) skill
2. **Develops interpretation** as the synthesis (easier) skill, grounded in captures
3. **Provides scaffolding** for neurodivergent minds (initiation friction, time blindness, variable energy)
4. **Uses AI to extract and surface**—never to write or interpret for users

**The goal**: Users achieve "thick description"—the ethnographic practice of capturing behavior and context with enough specificity that meaning can emerge and re-emerge over time.

### One Sentence

**Vicarious Me trains observers who can interpret, not interpreters who skip observation.**

---

## PART 1: THE TWO MODES FRAMEWORK

Before any other framework, users must understand the fundamental distinction between capturing experience and interpreting it. This is the bedrock of the entire system.

### 1.1 The Core Distinction

| Mode | Symbol | Purpose | Cognitive Activity |
|------|--------|---------|-------------------|
| **Capture Mode** | 📷 | Record what happened | Descriptive, sensory, specific, judgment-free |
| **Synthesis Mode** | 🔮 | Find what it means | Interpretive, connective, questioning, meaning-seeking |

**Critical insight**: These are not levels on a ladder where "deeper is better." They are different cognitive activities with different purposes. A master reflector moves *between* them deliberately.

**The ethnographic wisdom**: Geertz's "thick description" requires *thin description first*. You cannot add cultural meaning to behavior you haven't clearly observed. Field notes precede analytical memos.

### 1.2 The Grounding Principle

```
┌──────────────────────────────────────────────────────────────┐
│                    THE GROUNDING PRINCIPLE                   │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Interpretation must be earned through description.          │
│                                                              │
│  Before asking "What does this mean?", ask:                  │
│  "Have I captured what actually happened?"                   │
│                                                              │
│  The ratio shifts by temporal distance:                      │
│  • Daily entries: 70% capture, 30% interpretation            │
│  • Weekly synthesis: 30% capture, 70% interpretation         │
│  • Monthly+: Primarily interpretation, grounded by review    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 1.3 Why This Matters

Without this discipline:

1. **Loss of raw data**: If users always interpret, they lose the unprocessed observations that might yield different meanings later
2. **Premature closure**: Early interpretation locks in meaning before patterns can emerge across time
3. **Ungrounded abstraction**: Interpretation without sufficient descriptive foundation becomes untethered—users "get lost" in meaning-making
4. **Cognitive overwhelm**: Constantly interpreting is exhausting; sometimes capture is enough
5. **Skill conflation**: Description and interpretation are different skills; conflating them develops neither well

### 1.4 Mode by Tier

The hierarchical aggregation system creates a natural mode progression:

| Tier | Primary Mode | Rationale |
|------|--------------|-----------|
| **Daily** | Capture (70%) + Light Interpretation (30%) | Close to experience; preserve raw data |
| **Weekly** | Review Captures + Synthesis (70%) | Distance allows pattern recognition |
| **Monthly** | Pure Synthesis | Enough data accumulated; themes visible |
| **Quarterly** | Meta-Synthesis | Synthesizing syntheses; life-arc level |
| **Yearly** | Narrative Construction | Story emerges from accumulated meaning |

### 1.5 Entry Type Classification

Entries are tagged by their mode composition:

| Entry Type | Symbol | Description |
|------------|--------|-------------|
| **Pure Capture** | 📷 | Description only, no interpretation |
| **Grounded Reflection** | 📷→🔮 | Description + interpretation in balance |
| **Interpretation Layer** | +🔮 | Added later to an existing capture |
| **Synthesis** | 🔮 | Aggregation-level meaning-making |

**Key design decision**: Pure captures are complete entries. They are not "incomplete reflections waiting for interpretation."

---

## PART 2: REFRAMED EVALUATIVE FRAMEWORKS

Academic assessment frameworks must be repackaged for users in ways that feel empowering rather than evaluative.

### 2.1 The "Lens Depth" Framework

*Replaces: Moon's Levels of Reflective Writing (Levels 1-4)*

**Important**: Lens Depth applies primarily to *interpretation*, not capture. A vivid capture at "Surface" level is not inferior to an abstract interpretation at "Bedrock" level—they serve different purposes.

| Lens Depth | Internal Name | User-Facing Description | When It Applies |
|------------|---------------|------------------------|-----------------|
| **Surface** | Descriptive | "Capturing the moment" | Capture Mode—this is the goal |
| **Ground** | Reflective | "Finding the meaning" | Light interpretation in daily entries |
| **Root** | Analytical | "Questioning the pattern" | Weekly synthesis and beyond |
| **Bedrock** | Critical/Cultural | "Seeing the larger story" | Monthly+ synthesis |

**Implementation**: The AI provides Lens Depth feedback only on interpretive content, and celebrates Surface-level captures as valuable in themselves: "This entry captures vivid detail—the raw material for later insight."

---

### 2.2 The "Capture Quality" Framework

*New: Assessing description, not just interpretation*

Good captures have specific elements:

| Element | Description | Example Markers |
|---------|-------------|-----------------|
| **Specificity** | Concrete details, not generalizations | "She set down her coffee cup" vs. "She was upset" |
| **Sensory Grounding** | What was seen, heard, felt | "The fluorescent lights buzzed" |
| **Temporal Anchoring** | When, in what sequence | "After the meeting, but before lunch" |
| **Spatial Anchoring** | Where, physical arrangement | "We were in the corner booth" |
| **Behavioral Observation** | What people did, not what they felt | "He looked at his phone three times" |
| **Verbatim Fragments** | Actual words used | "She said 'I'm fine' but didn't look up" |

**Implementation**: AI assesses captures for these elements and offers targeted prompts: "Your capture has strong sensory detail. Want to add what was actually said? Verbatim fragments often reveal more than summaries."

---

### 2.3 The "Voice Spectrum" Framework

*Replaces: Bakhtinian Dialogism / Polyphony Assessment*

Tracks how many perspectives appear in a user's writing.

| Voice Count | Name | Description |
|-------------|------|-------------|
| **Solo** | Single Voice | Your perspective only |
| **Duet** | Two Voices | You + one other perspective |
| **Ensemble** | Multiple Voices | Several perspectives in dialogue |
| **Chorus** | Cultural Voices | Personal + cultural/systemic perspectives |

**Note**: Voice expansion is primarily a Synthesis Mode activity. In Capture Mode, focus on *observing* what others did and said, not interpreting their perspectives.

---

### 2.4 The "Connective Tissue" Framework

*Replaces: Cross-Entry Pattern Recognition / Thematic Analysis*

| Connection Type | Description | Example |
|-----------------|-------------|---------|
| **Isolated** | Entry stands alone | "Today I went to the coffee shop" |
| **Linked** | References another entry | "Like last Tuesday at the coffee shop..." |
| **Threaded** | Part of ongoing pattern | "This is the third time I've noticed this" |
| **Woven** | Connects multiple themes | "My coffee shop ritual connects to solitude, which connects to..." |

**Implementation**: Connection-making is a Synthesis Mode activity. AI surfaces connections during weekly+ aggregation, not during daily capture.

---

### 2.5 The "Question Evolution" Framework

*Replaces: Cognitive Complexity Assessment*

| Question Type | Characteristics | Example |
|---------------|-----------------|---------|
| **Practical** | Seeks answer, action-oriented | "What should I do about my commute?" |
| **Interpretive** | Seeks meaning | "Why does my commute feel so draining?" |
| **Connective** | Seeks patterns | "What does my commute reveal about my relationship with time?" |
| **Generative** | Opens new inquiry | "How does the way I experience transitions reflect how I handle life transitions?" |

**Implementation**: Track question types over time. Note that Practical questions may emerge from captures; Generative questions typically emerge from synthesis.

---

## PART 3: THE CAPTURE-FIRST FLOW

### 3.1 Daily Entry Flow (Restructured)

The daily reflection flow enforces description before interpretation:

```
┌──────────────────────────────────────────────────────────────┐
│  Daily Reflection                         [📷 CAPTURE MODE]  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: CAPTURE (Required)                                  │
│  ───────────────────────────────────────────────────────────│
│  "What happened? Describe the scene."                        │
│                                                              │
│  Prompts:                                                    │
│  • Where were you?                                           │
│  • Who was there?                                            │
│  • What was said or done?                                    │
│  • What did you notice with your senses?                     │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                                                        │  │
│  │  [Writing area - capture content]                      │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  [This section must have content to proceed]                 │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│  STEP 2: INTERPRETATION (Optional)                           │
│  ───────────────────────────────────────────────────────────│
│  "Now that you've captured it, do you want to explore        │
│  what it means? Or save the capture and let meaning          │
│  emerge later?"                                              │
│                                                              │
│  [Save Capture Only] [Add Interpretation →]                  │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 3.2 Mode Indicators in UI

Make the current mode explicit:

```
Daily Entry:    [📷 CAPTURE MODE]
Interpretation: [🔮 INTERPRETATION]  
Weekly Review:  [🔮 SYNTHESIS MODE]
```

### 3.3 Celebrating Pure Captures

When users save without interpretation:

```
┌──────────────────────────────────────────────────────────────┐
│  ✓ Capture Saved                                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  You've recorded this moment. That's enough for now.         │
│                                                              │
│  Meanings can emerge later—at your weekly synthesis, or      │
│  months from now when patterns become visible.               │
│                                                              │
│  Sometimes the best thing you can do is just notice.         │
│                                                              │
│  [Done] [Add interpretation now]                             │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 3.4 The "Marination" Principle

Some captures shouldn't be interpreted immediately:

```
┌──────────────────────────────────────────────────────────────┐
│  💭 Let it marinate?                                         │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  You've captured something. Sometimes meaning takes time.    │
│                                                              │
│  Options:                                                    │
│  • Save and interpret now                                    │
│  • Save and let it marinate (return at weekly synthesis)     │
│  • Save and flag for future attention                        │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## PART 4: PROGRESSIVE SCAFFOLDING SYSTEM

### 4.1 User Development Stages

| Stage | Name | Characteristics | Prompt Strategy |
|-------|------|-----------------|-----------------|
| **1** | Emerging | New to reflective writing; primarily descriptive | High scaffolding with examples; capture-focused prompts |
| **2** | Developing | Beginning to add meaning; occasional perspective-taking | Moderate scaffolding; capture + optional interpretation |
| **3** | Established | Regular analytical elements; asks interpretive questions | Light scaffolding; user chooses mode balance |
| **4** | Fluent | Moves between modes deliberately; generates insight | Self-directed; AI surfaces connections only |

### 4.2 Stage Detection Signals

The AI tracks:

**Capture Quality Signals**:
- Sensory detail density
- Specificity vs. generalization ratio
- Verbatim quote usage
- Behavioral vs. emotional language

**Interpretation Quality Signals**:
- Causal language density ("because," "since," "led to")
- Perspective markers ("from their view," "she might have")
- Question complexity (Practical → Generative)
- Grounding (are interpretations linked to captures?)

**Mode Awareness Signals**:
- Does user distinguish capture from interpretation?
- Does user save pure captures sometimes?
- Does user wait before interpreting?

### 4.3 Prompt Adaptation by Stage

**Stage 1 (Emerging) - Capture Focus**:
```
"What actually happened? Pick the most specific moment and describe it:
• Where were you?
• Who was there?
• What was said or done?

Example: 'I was standing in the kitchen when my daughter said...'"
```

**Stage 2 (Developing) - Capture + Optional Interpretation**:
```
"You've captured the moment. Now, if you want: why did this stick with you?

[Hint available: Consider what you felt, or what surprised you.]"
```

**Stage 3 (Established) - User-Directed**:
```
"What's the question this experience is asking you?"
```

**Stage 4 (Fluent) - Minimal Scaffolding**:
```
[Blank space with optional: "See connections the AI noticed"]
```

---

## PART 5: NEURODIVERSE-FIRST DESIGN

### 5.1 Initiation Friction Reduction

**The Problem**: ADHD involves activation difficulty—getting started is the hardest part.

**Design Principles**:

1. **Prompt-First Interface**: Never show a blank page. Show a capture prompt first.

2. **One-Tap Modes**: 
   - "Quick Capture" (1-2 sentences, no interpretation expected)
   - "Guided Reflection" (full capture → optional interpretation flow)
   - "Just Write" (blank page for flow states)

3. **Micro-Entry Option**: One sentence counts. Pure captures are complete.

4. **Time-Bounded Sessions**: Optional 10-minute timer.

```
┌──────────────────────────────────────────────────────────────┐
│  How do you want to capture this moment?                     │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐  │
│  │ ⚡ Quick        │  │ 🧭 Guided      │  │ ✍️ Just Write  │  │
│  │ (1-2 sentences)│  │ (5-10 min)     │  │ (blank page)   │  │
│  └────────────────┘  └────────────────┘  └────────────────┘  │
│                                                              │
│  Last entry: 3 days ago · This month: 7 reflections         │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 5.2 Time Blindness Compensation

**Design Principles**:

1. **Topic Recency Indicators**: Show time since last reflection on each focus type

```
┌──────────────────────────────────────────────────────────────┐
│  Choose your lens:                                           │
├──────────────────────────────────────────────────────────────┤
│  ┌──────────┐ ┌──────────┐ ┌────────────┐ ┌──────────┐       │
│  │  Event   │ │  Person  │ │Relationship│ │  Place   │       │
│  │ 2d ago   │ │ 1w ago   │ │  3w ago ⚠️ │ │ 4d ago   │       │
│  └──────────┘ └──────────┘ └────────────┘ └──────────┘       │
│                                                              │
│  ⚠️ = It's been a while                                      │
└──────────────────────────────────────────────────────────────┘
```

2. **Pattern Surfacing**: At aggregation, show topic distribution
3. **Temporal Prompts**: "You captured this same topic 2 weeks ago. What's changed?"

### 5.3 Inconsistency Accommodation

**Design Principles**:

1. **Non-Punitive Return**: Never "You broke your streak!" Instead: "Welcome back. It's been 8 days. What stands out?"

2. **Flexible Tracking**: "This month: 3 reflections · All time: 47 reflections" (not consecutive days)

3. **Catch-Up Prompts**: "Want to capture anything from the past week?"

4. **Variable Modes**: On low-energy days, Quick Capture counts.

### 5.4 Executive Function Scaffolding

1. **Externalize Everything**: Show previous entry on same topic during writing
2. **Reduce Decision Points**: Default focus type suggestions; "Continue from last time" option
3. **Progress Visualization**: Clear step indicators in flows
4. **Working Memory Support**: Context Panel showing relevant past entries

### 5.5 Hyperfocus Accommodation

1. **Expandable Depth**: Always offer "Go deeper" for flow states
2. **Optional Time Boundaries**: Timers are opt-in
3. **Connection Surfacing**: Rich related content during productive periods
4. **Revision Access**: Easy return to old entries

---

## PART 6: WRITING DEVELOPMENT MECHANISMS

### 6.1 The "Revision Layer" System

At aggregation points, users revisit captures to add interpretation:

```
┌──────────────────────────────────────────────────────────────┐
│  Weekly Synthesis                       [🔮 SYNTHESIS MODE]  │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Here are your 4 captures from this week.                    │
│                                                              │
│  Before synthesizing, you can add interpretation to any      │
│  capture. What do you see now that you didn't see then?      │
│                                                              │
│  📷 Monday: The coffee shop conversation [Add layer]         │
│  📷 Tuesday: Walking through the park [Add layer]            │
│  📷→🔮 Thursday: The unexpected phone call                   │
│      └─ "I realize now this wasn't about the call—it was     │
│         about feeling interrupted."                          │
│  📷 Saturday: The quiet morning [Add layer]                  │
│                                                              │
│  [Continue to synthesis →]                                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**Revision Prompts**:
- "What do you see now that you didn't see then?"
- "What were you not ready to acknowledge?"
- "What question does this raise now?"
- "How does this connect to something that happened later?"

### 6.2 The "Thick Description" Training

AI analyzes captures for richness:

| Element | Description | AI Feedback |
|---------|-------------|-------------|
| **Sensory Detail** | Concrete sensory information | "Your capture has strong visuals. What sounds were present?" |
| **Context** | Setting, circumstances | "A stranger couldn't picture this yet. Where exactly were you?" |
| **Behavioral Observation** | What people did | "You wrote 'she was upset.' What did she actually do or say?" |
| **Verbatim Fragments** | Actual words | "Can you recall any exact words? They often reveal more than summaries." |

### 6.3 The "Synthesis Lab"

At aggregation, scaffold synthesis (not summary):

| Summary (Avoid) | Synthesis (Goal) |
|-----------------|------------------|
| "This week I wrote about work, family, and mornings." | "The thread connecting work stress and morning routine is control—I'm clinging to mornings because the day feels uncontrollable." |
| Restates content | Generates new insight |
| Lists topics | Finds connections |

**Synthesis Prompts**:
```
STEP 1: Review your captures

STEP 2: Before you write, consider:
🔗 "What thread runs through these moments?"
❓ "What question is this week asking you?"
🔮 "What do you understand now that you didn't before?"

STEP 3: Write your synthesis
"Don't summarize—generate."
```

**Grounding Check**: If synthesis reads as summary, prompt: "This reads like a summary. Can you point to the captures that support a deeper insight?"

### 6.4 The "Writing Growth Portrait"

Monthly view of development:

```
┌──────────────────────────────────────────────────────────────┐
│  Your Writing This Month                                     │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  MODE BALANCE                                                │
│  You saved 4 pure captures and 8 grounded reflections.       │
│  Your captures are becoming more sensory-rich.               │
│                                                              │
│  CAPTURE QUALITY                                             │
│  📍 Sensory Detail: ███████░░░ Strong                        │
│  📍 Specificity: █████░░░░░ Developing                       │
│  📍 Verbatim Quotes: ██░░░░░░░░ Emerging                     │
│                                                              │
│  SYNTHESIS DEPTH                                             │
│  Your weekly syntheses moved from Ground to Root level       │
│  twice this month—you questioned your own assumptions.       │
│                                                              │
│  EMERGING THEMES                                             │
│  Control, transition, morning rituals                        │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## PART 7: TRAINING THE DISTINCTION

### 7.1 Onboarding: Two Modes

```
┌──────────────────────────────────────────────────────────────┐
│  Welcome to Vicarious Me                                     │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Reflection has two modes. Both matter.                      │
│                                                              │
│  📷 CAPTURE                                                  │
│  Recording what happened—the scene, the details, the         │
│  sensory experience. Like taking a photograph.               │
│                                                              │
│  🔮 SYNTHESIS                                                │
│  Finding what it means—patterns, questions, connections.     │
│  Like developing the photograph into a story.                │
│                                                              │
│  The skill is knowing which mode you're in, and when         │
│  to switch. We'll help you develop both.                     │
│                                                              │
│  [Continue]                                                  │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 7.2 Mode Check Habit

Periodically:
```
"Before you continue: are you capturing or interpreting?

📷 I'm describing what happened
🔮 I'm exploring what it means
🔄 I'm mixing both (that's okay—just notice)

Noticing which mode you're in is itself a skill."
```

### 7.3 The Capture Challenge

```
┌──────────────────────────────────────────────────────────────┐
│  🎯 Today's Challenge: Pure Capture                          │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Write about something using only description.               │
│  No interpretations, no meanings, no "I realized."           │
│                                                              │
│  Just: what happened, what you saw, what was said.           │
│                                                              │
│  This is harder than it sounds. Interpretation sneaks in.    │
│                                                              │
│  [Accept Challenge] [Skip]                                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 7.4 The Grounded Interpretation Challenge

```
┌──────────────────────────────────────────────────────────────┐
│  🎯 Today's Challenge: Grounded Interpretation               │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Pick a capture from this week and add interpretation.       │
│                                                              │
│  The rule: every claim must point to evidence in the         │
│  capture. If you write "I was anxious," show what in         │
│  the capture demonstrates anxiety.                           │
│                                                              │
│  [Accept Challenge] [Skip]                                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 7.5 Interpretation Drift Warning

AI detects when users always interpret without capturing:

**Detection signals**:
- Every entry contains meaning-language ("I realized," "this means")
- Few concrete sensory details
- Abstract language without grounding
- Immediate interpretation without scene-setting

**Intervention**:
```
┌──────────────────────────────────────────────────────────────┐
│  💡 A thought about your writing                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  Your recent entries jump quickly to interpretation.         │
│  That's valuable—but meaning needs grounding.                │
│                                                              │
│  Try this: before "what does it mean?", spend a moment       │
│  on "what actually happened?" The details you capture        │
│  now might reveal different meanings later.                  │
│                                                              │
│  [Try Capture Mode] [Continue as usual]                      │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## PART 8: NEW FEATURE SPECIFICATIONS

### 8.1 Quick Capture Mode

**Purpose**: Reduce initiation friction; pure capture without interpretation pressure.

**Flow**:
1. User taps "Quick Capture"
2. Single prompt: "What's on your mind? Just capture it."
3. User writes 1-3 sentences
4. One-tap save → done
5. Entry tagged as 📷 Pure Capture

**Design**: No focus type required. No interpretation offered. Speed is the point.

### 8.2 Context Panel

**Purpose**: Support working memory during writing.

```
┌─────────────────────────────────────────────────────────────┐
│  ✍️ Write your capture                                      │
├─────────────────────────────────────────────────────────────┤
│  [Writing area]                                             │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  📎 Context Panel                              [Collapse ▲] │
│  ─────────────────────────────────────────────────────────  │
│  LAST CAPTURE ON "PERSON" (5 days ago):                     │
│  "The conversation with my mother left me..."               │
│                                                             │
│  RELATED QUESTION (from October):                           │
│  "Why do family conversations feel harder?"                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.3 Connection Surfacer

**Purpose**: Make cross-entry patterns visible during synthesis.

```
┌─────────────────────────────────────────────────────────────┐
│  🔗 Connections Detected                                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  These captures seem to be in conversation:                 │
│                                                             │
│  📷 Nov 15: "The morning felt rushed..."                    │
│  📷 Nov 18: "At the coffee shop, I finally felt..."         │
│  📷 Nov 21: "Why do I need to leave the house..."           │
│                                                             │
│  🧵 POSSIBLE THREAD: Relationship with time, presence       │
│                                                             │
│  [Explore this thread] [Show different connections]         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.4 Theme Navigator

**Purpose**: Enable thematic exploration across entries.

```
┌─────────────────────────────────────────────────────────────┐
│  🗂 Your Themes                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  RECURRING (5+ entries):                                    │
│  • Control (8 entries)                                      │
│  • Morning rituals (7 entries)                              │
│  • Family dynamics (6 entries)                              │
│                                                             │
│  EMERGING (2-4 entries):                                    │
│  • Professional identity (4 entries)                        │
│  • Solitude (3 entries)                                     │
│                                                             │
│  [Tap any theme to explore]                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.5 Writing Intention Setter

**Purpose**: Let users set developmental goals.

```
┌─────────────────────────────────────────────────────────────┐
│  🎯 Set Your Writing Intention                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  What would you like to develop?                            │
│                                                             │
│  ○ Capture more sensory detail                              │
│  ● Distinguish capture from interpretation                  │
│  ○ Include other perspectives                               │
│  ○ Connect experiences across time                          │
│  ○ Question my assumptions                                  │
│                                                             │
│  [Set Intention for December]                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## PART 9: PROMPT LIBRARY STRUCTURE

### 9.1 Mode-Specific Prompts

**CAPTURE PROMPTS** (for daily entries):

```json
{
  "id": "capture_scene_01",
  "type": "capture",
  "mode": "capture",
  "text": "Describe the scene like a camera would record it. No meanings—just what happened."
},
{
  "id": "capture_sensory_01",
  "type": "capture",
  "mode": "capture",
  "text": "What did you see, hear, smell, or feel? One specific detail."
},
{
  "id": "capture_verbatim_01",
  "type": "capture",
  "mode": "capture",
  "text": "What was actually said? Try to recall exact words."
},
{
  "id": "capture_behavior_01",
  "type": "capture",
  "mode": "capture",
  "text": "What did people do—not what they felt, but what they did?"
}
```

**INTERPRETATION PROMPTS** (for optional layer):

```json
{
  "id": "interpret_meaning_01",
  "type": "interpretation",
  "mode": "synthesis",
  "text": "Now that you've captured it: why did this stick with you?"
},
{
  "id": "interpret_assumption_01",
  "type": "interpretation",
  "mode": "synthesis",
  "text": "What assumption might you be making here?"
}
```

**SYNTHESIS PROMPTS** (for aggregation):

```json
{
  "id": "synthesis_thread_01",
  "type": "synthesis",
  "tier": "weekly",
  "text": "What thread connects these captures? Not a summary—what do you understand now?"
},
{
  "id": "synthesis_chapter_01",
  "type": "synthesis",
  "tier": "monthly",
  "text": "If this month were a chapter, what would it be called? What's its central tension?"
}
```

### 9.2 The Prompt Sequencing Rule

For daily entries, interpretation prompts appear only *after* capture prompts are addressed:

```
1. "What happened?" [Capture - required]
2. [User writes description]
3. "Now, if you want: what did this mean?" [Interpretation - optional]
```

---

## PART 10: AI ANALYSIS ARCHITECTURE

### 10.1 Mode Analysis

```typescript
interface ModeAnalysis {
  captureRatio: number;  // 0-1
  interpretationRatio: number;  // 0-1
  modeBalance: "pure_capture" | "capture_heavy" | "balanced" | "interpretation_heavy" | "pure_interpretation";
  
  captureElements: {
    sensoryDetails: string[];
    temporalMarkers: string[];
    spatialMarkers: string[];
    verbatimQuotes: string[];
    behavioralObservations: string[];
  };
  
  interpretationElements: {
    meaningClaims: string[];
    patternClaims: string[];
    causalClaims: string[];
  };
  
  groundingScore: number;  // Are interpretations supported by captures?
}
```

### 10.2 Capture Quality Analysis

```typescript
interface CaptureQualityAnalysis {
  specificity: "high" | "medium" | "low";
  sensoryDensity: number;  // sensory words per 100 words
  verbatimPresence: boolean;
  behavioralVsEmotional: number;  // ratio
  
  suggestions: string[];  // "Add sensory detail", "Include verbatim quotes"
}
```

### 10.3 Longitudinal Mode Tracking

```typescript
interface UserModeProfile {
  captureFrequency: number;  // How often pure captures
  interpretationTendency: number;  // How quickly to interpretation
  groundingScore: number;  // How well interpretations are supported
  modeAwareness: number;  // Does user distinguish modes?
  
  alerts: {
    interpretationDrift: boolean;  // Always interprets, never captures
    ungroundedAbstraction: boolean;  // Interprets without evidence
    captureOnly: boolean;  // Never synthesizes (different problem)
  };
}
```

---

## PART 11: IMPLEMENTATION PRIORITY

### Phase 0: Foundation (Sprint 0-1)
1. Two Modes framework introduction
2. Capture-First daily flow
3. Entry type labeling (📷 / 📷→🔮 / 🔮)
4. "Save Capture Only" option
5. Capture quality prompts

### Phase 1: Scaffolding (Sprint 2-3)
1. Quick Capture mode
2. Mode indicators in UI
3. Time-since indicators on focus types
4. Interpretation Drift warning

### Phase 2: Intelligence (Sprint 4-5)
1. Capture Quality feedback
2. Revision Layer system
3. Connection Surfacer
4. Context Panel

### Phase 3: Growth (Sprint 6-7)
1. Writing Growth Portrait
2. Theme Navigator
3. Synthesis Lab scaffolding
4. Writing Intention Setter

### Phase 4: Mastery (Sprint 8+)
1. Challenges (Pure Capture, Grounded Interpretation)
2. Mode Check prompts
3. Full linguistic signal tracking
4. Mentor Text system

---

## PART 12: SUCCESS METRICS

### Mode Balance Metrics
- **Capture ratio**: Percentage of entries that are pure or capture-heavy
- **Interpretation grounding**: Percentage of interpretations with linked evidence
- **Mode awareness**: User response to mode-check prompts
- **Marination usage**: Entries saved for later interpretation

### Quality Metrics
- **Capture quality**: Sensory density, specificity, verbatim presence
- **Interpretation quality**: Grounding, insight generation
- **Synthesis quality**: Integration vs. summary ratio

### Engagement Metrics
- **Entry frequency**: Per week/month
- **Mode selection**: Quick Capture vs. Guided usage
- **Return rate**: After gaps
- **Aggregation completion**: Weekly/monthly synthesis rates

---

## CONCLUSION

This specification transforms Vicarious Me from a reflection capture tool into a cognitive development platform that:

1. **Teaches the fundamental distinction** between capturing and interpreting—then develops both skills
2. **Enforces grounding** by requiring description before interpretation
3. **Celebrates pure captures** as complete, valuable entries
4. **Scaffolds synthesis** at appropriate temporal distances
5. **Supports neurodivergent users** through friction reduction, time-blindness compensation, and flexible modes
6. **Makes growth visible** through qualitative feedback, not scores

**The core insight**: Vicarious Me should train *observers who can interpret*, not *interpreters who skip observation*.

**The ethnographic wisdom**: You cannot interpret what you haven't observed. And what you observe too quickly becomes only what you expected to see.

---

*Document Version: 2.0 (Unified)*
*Based on: "Reflection as Cognitive Architecture: Evidence for Structured Writing in Neurodivergent Minds"*
*Key principle: The Two Modes framework is foundational, not supplementary*
