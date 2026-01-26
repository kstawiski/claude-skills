---
name: humanizer
description: |
  Remove signs of AI-generated writing from text. Detects and corrects common AI writing patterns
  including inflated symbolism, promotional language, superficial analyses, vague attributions,
  excessive em dash usage, rule of three patterns, AI-specific vocabulary, negative parallelisms,
  and overuse of conjunctive phrases. Based on Wikipedia's comprehensive guide for identifying
  AI-generated content.
routing_description: |
  Post-processing skill to humanize AI-generated text, making it sound more natural and less
  machine-generated. Apply to reports, documentation, and any text that needs a human touch.
routing_keywords:
  - humanize
  - humanizer
  - ai writing
  - natural writing
  - remove ai patterns
  - human-like text
  - writing style
  - text polish
  - report finalization
version: 1.0.0
---

# Humanizer Skill

Remove signs of AI-generated writing from text to achieve a more natural, human-written tone.

## Overview

This skill identifies and corrects common patterns that indicate AI-generated content:

1. **Inflated Symbolism** - Overly dramatic metaphors and symbolism
2. **Promotional Language** - Marketing-speak and excessive enthusiasm
3. **Superficial Analyses** - Shallow observations, especially "-ing" constructions
4. **Vague Attributions** - "Some experts say...", "Many believe..."
5. **Excessive Em Dashes** - Overuse of "—" for parenthetical statements
6. **Rule of Three** - Compulsive use of three-item lists
7. **AI-Specific Vocabulary** - Words overused by AI models
8. **Negative Parallelisms** - "Not X, but Y" constructions
9. **Conjunctive Phrase Overuse** - "Furthermore", "Moreover", "Additionally"

## Quick Start

Apply humanizer to any text:

```
Humanize this report: [paste text]
```

```
Review this document for AI writing patterns and fix them.
```

```
Make this text sound more natural and human-written.
```

## When to Use

- **Reports**: After generating analysis/report.md
- **Documentation**: Before finalizing README or docs
- **Communications**: Emails, announcements, summaries
- **Publications**: Scientific manuscripts, articles

## Detection Patterns

### 1. Inflated Symbolism

**Detect:** Overly dramatic metaphors disconnected from content

| AI Pattern | Human Alternative |
|------------|-------------------|
| "a beacon of hope in the darkness" | "a promising development" |
| "the tapestry of human experience" | "people's varied experiences" |
| "a symphony of innovation" | "multiple innovations working together" |

### 2. Promotional Language

**Detect:** Marketing buzzwords and excessive enthusiasm

| AI Pattern | Human Alternative |
|------------|-------------------|
| "groundbreaking", "revolutionary" | "notable", "significant" |
| "game-changing", "cutting-edge" | "effective", "modern" |
| "unlock the full potential" | "improve results" |
| "seamlessly integrates" | "works with" |

### 3. Superficial "-ing" Analyses

**Detect:** Vague present participle constructions

| AI Pattern | Human Alternative |
|------------|-------------------|
| "highlighting the importance of..." | "This matters because..." |
| "showcasing the ability to..." | "This can..." |
| "underscoring the need for..." | "We need..." |

### 4. Vague Attributions

**Detect:** Unspecified sources and authorities

| AI Pattern | Human Alternative |
|------------|-------------------|
| "Some experts believe..." | [cite specific source] or remove |
| "Many argue that..." | [cite who argues] or state directly |
| "It is widely accepted..." | [cite evidence] or rephrase |
| "Research suggests..." | [cite the research] |

### 5. Excessive Em Dashes

**Detect:** More than 1-2 em dashes per paragraph

| AI Pattern | Human Alternative |
|------------|-------------------|
| "The results—which were surprising—showed that..." | "The surprising results showed that..." |
| "This approach—unlike traditional methods—offers..." | "Unlike traditional methods, this approach offers..." |

### 6. Rule of Three

**Detect:** Compulsive three-item lists

| AI Pattern | Human Alternative |
|------------|-------------------|
| "fast, efficient, and reliable" | "fast and reliable" (if 2 suffice) |
| "analyze, synthesize, and evaluate" | "analyze and evaluate" |

### 7. AI-Specific Vocabulary

**Detect:** Words disproportionately used by AI

| Overused Word | Alternatives |
|---------------|--------------|
| "delve" | explore, examine, look at |
| "crucial" | important, key, essential |
| "utilize" | use |
| "leverage" | use, apply |
| "robust" | strong, reliable |
| "comprehensive" | complete, thorough |
| "facilitate" | help, enable, allow |
| "subsequently" | then, later, after |
| "pivotal" | key, important |
| "multifaceted" | complex, varied |
| "nuanced" | subtle, complex |
| "realm" | area, field, domain |
| "landscape" | situation, field, area |
| "tapestry" | mix, combination |
| "testament" | proof, evidence, sign |
| "myriad" | many, numerous |
| "plethora" | many, abundance |
| "intricate" | complex, detailed |
| "embark" | start, begin |
| "foster" | encourage, support |
| "endeavor" | effort, attempt, project |
| "commendable" | good, praiseworthy |
| "meticulous" | careful, thorough |
| "adept" | skilled, good at |
| "prowess" | skill, ability |

### 8. Negative Parallelisms

**Detect:** "Not X, but Y" constructions

| AI Pattern | Human Alternative |
|------------|-------------------|
| "not just a tool, but a paradigm shift" | "a significant improvement" |
| "not merely a change, but a transformation" | "a major change" |

### 9. Conjunctive Phrase Overuse

**Detect:** Excessive transitional phrases

| Overused | Use Sparingly or Replace |
|----------|-------------------------|
| "Furthermore" | "Also", or restructure |
| "Moreover" | "And", or new paragraph |
| "Additionally" | "Also", or omit |
| "In conclusion" | Just state the conclusion |
| "It is worth noting that" | Just state the point |
| "It is important to note" | State directly |

## Humanization Process

### Step 1: Scan for Patterns

Read through text identifying:
- [ ] Inflated metaphors
- [ ] Promotional language
- [ ] Vague "-ing" constructions
- [ ] Unattributed claims
- [ ] Em dash density
- [ ] Three-item lists
- [ ] AI vocabulary
- [ ] "Not X, but Y" patterns
- [ ] Conjunctive stacking

### Step 2: Apply Fixes

For each pattern found:
1. Replace with simpler, direct language
2. Add specific citations for claims
3. Vary sentence structure
4. Remove unnecessary flourishes
5. Keep the meaning, lose the AI fingerprint

### Step 3: Verify Naturalness

Read aloud. Does it sound like:
- [ ] A human wrote it?
- [ ] The author has genuine expertise?
- [ ] The style is consistent throughout?

## Integration with Consensus Workflow

When generating reports in the consensus workflow, apply humanizer as the **final step** before completion:

```
After report.md is complete:
1. Apply humanizer patterns
2. Verify all AI indicators removed
3. Maintain technical accuracy
4. Preserve scientific rigor
```

## Examples

### Before (AI-Generated)

> The study delves into the multifaceted landscape of treatment outcomes, highlighting the crucial role of early intervention. Furthermore, the results—which were comprehensive—underscore the pivotal nature of personalized approaches. This research is not merely a contribution, but a testament to the transformative potential of modern medicine.

### After (Humanized)

> The study examines treatment outcomes and the importance of early intervention. The results show that personalized approaches improve outcomes. This research adds to our understanding of modern treatment options.

## Reference Files

| File | Contents |
|------|----------|
| [reference.md](reference.md) | Complete pattern detection rules and examples |

## Important Notes

- Preserve technical accuracy when humanizing scientific text
- Don't over-simplify domain-specific terminology
- Maintain the author's intended meaning
- Some patterns are acceptable in moderation—flag only when excessive
