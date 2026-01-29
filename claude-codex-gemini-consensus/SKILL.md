---
name: claude-codex-gemini-consensus
description: |
  Comprehensive multi-AI consensus workflow for:
  1. CODE REVIEW - Clinical/technical review following SOP with TODO.md/IDEAS.md tracking
  2. ANALYSIS PLANNING - Statistical/bioinformatic analysis plans saved to analysis/plan.md
  3. ANALYSIS EXECUTION - Conduct analysis per plan with completeness verification
  4. REPORT GENERATION - Publication-ready reports (Methods/Results/Discussion) with figures, tables, PubMed citations
  
  Uses Claude Code CLI, OpenAI Codex CLI, and Google Gemini CLI. All work requires consensus between Claude, Codex, AND Gemini.
  Each agent can consult the other two for validation.

  DEFAULT METHOD: Blinded consensus with multi-round argumentation. Agents review anonymously (Reviewer A/B/C),
  then discuss disagreements through reasoned debate until genuine consensus is reached.

  Triggers: "code review", "clinical review", "consensus", "blinded consensus", "Claude", "Codex", "Gemini", "statistical analysis", "publication", "scientific analysis", "review SOP"
---

# Claude, Codex & Gemini Consensus Workflow

Multi-AI agent consensus system for critical code development and review. Each agent can invoke the other two for validation.

## How to Use This Skill

### Invocation Examples

**For Code Review (SOP-Based):**
```
Review my application using the code review SOP. Start with TODO.md setup.
```
```
Run clinical code review on this project. Follow the consensus SOP.
```
```
Review all modules in src/ using the review SOP. Track in TODO.md.
```

**For Simple Code Review (No SOP):**
```
Review my code in src/ using Codex and Gemini consensus.
```
```
Use consensus workflow to review this Python script critically.
```

**For Planning (Code/Features):**
```
Plan implementation of [feature] with Codex and Gemini consensus.
```
```
I need to build [X]. Create a plan and validate with Codex and Gemini.
```

**For Scientific Analysis Planning:**
```
Plan a statistical analysis for this clinical dataset. Use scientific consensus workflow.
Save the approved plan to analysis/plan.md for later execution.
```
```
Design analysis plan for [study type]. Include Codex/Gemini validation. This is for publication.
Output: analysis/plan.md
```

**For Conducting Analysis (After Plan Approved):**
```
Conduct the analysis according to analysis/plan.md. Validate each step with Codex and Gemini. 
Ensure all planned analyses are completed. Generate publication-ready report.
```
```
Execute the plan in analysis/plan.md. Check completeness - no missing or wrong analyses.
Create analysis/report.md with Methods, Results, Discussion.
```

**For Report Generation:**
```
Generate publication-ready report in analysis/report.md. Include figures, tables, PubMed citations.
Validate clinically and scientifically with Codex and Gemini.
```

### Workflow Modes

| Mode | Trigger Phrases | What Happens |
|------|-----------------|--------------|
| **Code Review (SOP)** | "code review SOP", "clinical review", "TODO.md" | Full SOP workflow with TODO.md/IDEAS.md tracking |
| **Code Review (Simple)** | "review code", "consensus review" | Submit to Codex & Gemini for critical review |
| **Plan Review** | "plan", "design", "architecture" | Draft plan → Codex review → Gemini review → Consensus |
| **Implementation** | "implement", "build", "create" | Implement → **Auto code review by all agents** → Approval |
| **Scientific Analysis** | "statistical analysis", "clinical research", "publication" | Full scientific workflow with completeness checks |
| **Analysis Execution** | "conduct analysis", "execute plan", "run analyses" | Implement + validate + check completeness |
| **Report Generation** | "report", "manuscript", "Methods/Results/Discussion" | Publication-ready output with citations |

> [!IMPORTANT]
> **Implementation workflows ALWAYS include automatic code review:**
> 1. Plan is validated by all agents
> 2. Primary agent executes implementation
> 3. **Remaining agents verify:** features correctly implemented + no regressions
> 4. Each remaining agent must confirm: "Implementation correct, no regressions"
> 5. Only complete when ALL remaining agents approve

### Complete Workflow Example (Scientific Analysis)

**Phase A: Planning (generates analysis/plan.md)**
```
USER: "I have clinical trial data with survival outcomes. 
      Plan a comprehensive analysis with Codex/Gemini consensus."

CLAUDE WILL:
1. [PLAN] Draft statistical analysis plan
2. [VALIDATE] Submit plan to Codex → Get feedback
3. [VALIDATE] Submit plan to Gemini → Get feedback  
4. [CONSENSUS] Synthesize feedback, argue disagreements, iterate until agreed
5. [SAVE] Write approved plan to analysis/plan.md
```

**Phase B: Execution (reads analysis/plan.md, generates report.md)**
```
USER: "Execute the plan in analysis/plan.md. Generate publication-ready report."

CLAUDE WILL:
1. [READ] Load plan from analysis/plan.md
2. [EXECUTE] Implement each analysis
3. [CODE REVIEW] Submit implementation to Codex + Gemini for review
4. [VALIDATE] Ensure all agents approve - no bugs, no regressions
5. [COMPLETENESS] Check: Are ALL planned analyses done? Missing? Incomplete? Wrong?
6. [CORRECT] Fix any issues, re-validate with all agents
7. [REPORT] Generate analysis/report.md (Methods, Results, Discussion)
8. [FIGURES] Create publication-ready figures with captions
9. [HUMANIZE] Apply humanizer skill to remove AI writing patterns
10. [CITATIONS] Add and verify PubMed references
11. [CRITICAL FINAL REVIEW] **Clinical AND Scientific assessment by ALL models - MANDATORY SIGN-OFF FROM CLAUDE + CODEX + GEMINI BEFORE COMPLETION**
```

### What This Skill Does Automatically

- **Code review after implementation** - All agents verify code before completion
- **Consensus validation** - Plans require approval from Claude + Codex + Gemini
- **Regression checking** - Agents verify no new issues introduced

### Is This Comprehensive?

**YES, this skill provides end-to-end coverage:**

| Use Case | Covered | How |
|----------|---------|-----|
| **CODE REVIEW** | | |
| Clinical code review (SOP) | ✅ | TODO.md/IDEAS.md tracking, P0-P3 priorities |
| Module-by-module review | ✅ | Systematic workflow, don't stop until done |
| Security review | ✅ | P0: PII/PHI, injection, auth bypass |
| Clinical validity review | ✅ | P1: Calculations, units, data integrity |
| Usability review | ✅ | P2: Error handling, UX, performance |
| Fix verification | ✅ | Pal verifies fixes, checks for regressions |
| **SCIENTIFIC ANALYSIS** | | |
| Analysis planning | ✅ | Consensus plan → analysis/plan.md |
| Analysis execution | ✅ | Per-plan execution with validation |
| Completeness verification | ✅ | ✓/⚠/✗/❌ status tracking |
| Missing analysis detection | ✅ | Compare plan vs results |
| **REPORTING** | | |
| Publication-ready reports | ✅ | Methods/Results/Discussion in report.md |
| Figures with captions | ✅ | 300+ DPI, complete legends |
| Tables with footnotes | ✅ | Proper formatting, statistical notation |
| PubMed citations | ✅ | PMID verification |
| **VALIDATION** | | |
| Clinical assessment | ✅ | Actionable? Meaningful effect sizes? |
| Scientific assessment | ✅ | Methodology sound? Conclusions supported? |
| Validation tracking | ✅ | Internal status tracking (not in outputs) |
| Domain-specific hypotheses | ✅ | Examples provided (e.g., cancer type prediction) |

**Limitations:**
- Requires Codex CLI and Gemini CLI installed and authenticated
- Web search requires `--search` flag (Codex) or is built-in (Gemini)
- Large analyses may need multiple iterations

### Quick-Start Cheatsheet

```bash
# Code Review (SOP-based, comprehensive)
"Review my application using the code review SOP. Track in TODO.md."

# Code Review (simple)
"Review src/main.py with Codex and Gemini consensus"

# Plan something (saves to analysis/plan.md)
"Plan statistical analysis for [data]. Save to analysis/plan.md"

# Execute saved plan
"Execute the plan in analysis/plan.md. Generate report."

# Full scientific workflow
"Plan and conduct analysis for [data]. Generate publication-ready report."

# Just get Codex opinion
"Ask Codex to review this code: [paste code]"

# Just get Gemini opinion  
"Ask Gemini to review this plan: [paste plan]"
```

### analysis/plan.md Template

When planning, Claude generates this file for later execution:

```markdown
# Analysis Plan: [Study Title]

## Metadata
- **Created**: [date]
- **Status**: APPROVED / PENDING

## Objectives
1. Primary: [main research question]
2. Secondary: [additional questions]

## Data Description
- Source: [data source]
- Samples: [n=X]
- Variables: [list key variables]

## Planned Analyses

### 1. [Analysis Name]
- **Objective**: [what this answers]
- **Method**: [statistical test/approach]
- **Variables**: [input variables]
- **Expected output**: [tables, figures]
- **Status**: ☐ Not started

### 2. [Analysis Name]
- **Objective**: ...
- **Method**: ...
- **Status**: ☐ Not started

## Quality Control
- [ ] Data validation
- [ ] Missing data handling
- [ ] Outlier detection

## Review Notes
- [Feedback addressed]
- [Points of discussion]
```

## Core Principle

**All plans must be accepted by Claude, Codex, AND Gemini. All code must be reviewed by all three agents with critical evaluation. Do not accept findings blindly—argue and reach consensus.**

---

## Output Validation: Zero Tolerance for Invalid Results

> [!CAUTION]
> **MANDATORY: Continuous output validation throughout all analyses.**

**Regularly check if output is correct/valid, clinically and scientifically plausible. Fix all issues as they arise. No compromises or deferred analysis.**

### Requirements

1. **Validate at every step** — Do not wait until the end to check results
2. **Clinical plausibility** — Results must make sense in real-world clinical context
3. **Scientific validity** — Statistical methods appropriate, assumptions met, results interpretable
4. **Immediate correction** — Fix issues when discovered, not later
5. **No deferred analysis** — If an analysis is planned, it MUST be completed or the plan MUST be changed
6. **Consensus on corrections** — All fixes require validation from Claude + Codex + Gemini

### When Issues Are Found

```
IF output is invalid/implausible:
  1. STOP immediately
  2. Diagnose the issue
  3. Fix the root cause
  4. DELETE incorrect scripts and outputs (keep repo clean)
  5. Re-run affected analyses
  6. Validate corrected output with all agents
  7. Continue only after consensus approval
```

**Repository hygiene:** When fixing issues, always remove wrong/incorrect scripts and outputs. Do not leave broken or invalid files in the repository — they cause confusion and may be accidentally used later.

### Resource Flexibility

**You can install or download whatever you need.** If a required package, tool, dataset, or reference is missing:
- Install packages via pip, conda, npm, etc.
- Download reference data from authoritative sources
- Fetch literature via web search
- Use any available MCP tools

Do not let missing resources block progress — acquire what you need and continue.

### Alternative Approaches

If an analysis cannot be completed as planned:
1. **Document why** — Explain the blocker clearly
2. **Propose alternative** — Suggest equivalent/better approach
3. **Get consensus** — All agents must approve the alternative
4. **Update plan** — Modify analysis/plan.md to reflect the change
5. **Execute alternative** — Complete the revised analysis

**No analysis should be skipped without consensus on an alternative approach.**

### Plan Compliance: Periodic Verification

**Periodically check if your work aligns with the consensus-approved plan.**

During execution, regularly verify:
- Are you following the approved analysis/plan.md?
- Are methods being applied as specified?
- Are outputs matching what was planned?

```
PERIODIC CHECK (every major step):
  1. Compare current work against plan
  2. IF aligned → continue
  3. IF deviating → STOP and follow deviation protocol below
```

**Deviation Protocol:**

If you need to do something NOT according to the approved plan:
1. **STOP** — Do not proceed with unapproved work
2. **Document the deviation** — What needs to change and why
3. **Argue with all models** — Present reasoning to Claude + Codex + Gemini
4. **Reach new consensus** — All agents must approve the change
5. **Update plan** — Modify analysis/plan.md with the approved corrections
6. **Continue** — Only after plan is re-approved with corrections

**Never silently deviate from an approved plan.** All changes require explicit consensus re-approval.

---

## Multi-Model Verification: Anti-Error Propagation

> [!IMPORTANT]
> **The primary purpose of multi-model consensus is to CATCH ERRORS that a single model would miss.**
> Models can share systematic biases and blindspots. Blinded, independent review is essential to prevent error propagation.

### Why Multi-Model Verification Matters

Single-model failure modes:
- **Hallucinated statistics** — Inventing p-values, confidence intervals, effect sizes
- **Methodological errors** — Wrong test for data type, violated assumptions, incorrect formulas
- **Clinical implausibility** — Results that make no sense in real-world medicine
- **Confirmation bias** — Seeing patterns that support expectations, missing contradictions
- **Copy-paste errors** — Propagating mistakes from earlier steps

Multi-model verification catches these because:
- Different training data → different blindspots
- Independent review → no anchoring on first answer
- Blinded identity → arguments judged on merit, not source

### Anti-Rubber-Stamping Rules

> [!CAUTION]
> **Rubber-stamping is FORBIDDEN.** Quick approvals without thorough review defeat the purpose of consensus.

Reviewers MUST:
1. **Actually verify** — Re-run calculations, check formulas, trace logic
2. **Challenge assumptions** — "Is this test appropriate?" "Are assumptions met?"
3. **Check plausibility** — "Does this make clinical/scientific sense?"
4. **Find something** — If review finds zero issues, reviewer is likely not looking hard enough
5. **Provide evidence** — Every approval must cite specific verification steps taken

```
BAD (rubber-stamp):
  VERDICT: APPROVED
  "Looks correct."

GOOD (verified):
  VERDICT: APPROVED
  VERIFICATION:
  - Recalculated HR manually: exp(0.693) = 2.0 ✓
  - Checked PH assumption via Schoenfeld test: p=0.42 (assumption holds) ✓
  - Median OS 14.2mo consistent with literature for this cancer type (PMID:12345678) ✓
  - Sample size adequate: 180 events for 5 covariates (36 EPV) ✓
```

### Independent Implementation for Critical Calculations

For high-stakes numerical results, **at least two models must independently compute**:

| Critical Output | Verification Method |
|-----------------|---------------------|
| Hazard ratios, odds ratios | Independent calculation from raw data |
| P-values | Re-run statistical test independently |
| Confidence intervals | Recalculate using formula |
| Sample sizes | Count from source data |
| Survival estimates | Independent KM calculation |
| Regression coefficients | Re-fit model independently |

```
INDEPENDENT VERIFICATION PROTOCOL:
  1. Model A computes result
  2. Model B computes SAME result independently (no seeing A's code)
  3. Compare: Results must match within acceptable tolerance
  4. IF mismatch → investigate discrepancy before proceeding
  5. IF match → high confidence in correctness
```

### Sanity Checks: Expected Ranges

Before accepting any result, verify against expected ranges:

| Metric | Suspicious If | Likely Error |
|--------|---------------|--------------|
| P-value | Exactly 0.000 or 1.000 | Calculation error |
| Hazard ratio | < 0.01 or > 100 | Model misspecification |
| Odds ratio | Negative | Formula error |
| Confidence interval | Crosses impossible values | Wrong method |
| Survival probability | < 0 or > 1 | Code bug |
| Sample size | Doesn't match data | Subsetting error |
| Percentages | Don't sum to 100% | Missing category |

### Literature Cross-Reference

**All key findings must be compared against published literature:**

1. **Method validation** — Is this statistical approach used in peer-reviewed publications for similar data?
2. **Result plausibility** — Are effect sizes consistent with published studies? (within 2-3x)
3. **Known benchmarks** — Do survival curves, response rates, etc. align with established values?
4. **Red flags** — Results dramatically different from literature require explanation

```bash
# Example verification prompt - REVIEWER_MODE
"REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY web search for PMIDs.

Cross-reference these results against published literature:
- HR for treatment: 0.65 (95% CI: 0.48-0.88)
- Median OS: 18.3 months
- 2-year survival: 42%

OUTPUT:
| Finding | Literature Range | Status | PMID |
PLAUSIBILITY: [consistent/suspicious/implausible]"
```

### Error Discovery is Success

**Finding errors is valuable, not failure.** The goal is correct results, not fast approval.

- Reviewers who find errors are doing their job well
- Models should actively try to break each other's work
- Disagreement is healthy — it reveals uncertainty
- "I found a problem" is better than "Looks fine" (when problems exist)

---

## DEFAULT: Blinded Consensus with Argumentation

> [!IMPORTANT]
> **Blinded consensus is the DEFAULT method for all reviews — not optional, not just "preferred".**
> It removes identity bias and prevents error replication through genuine independent assessment.
>
> **Why blinded by default?** When models see each other's identities or prior answers, they anchor on existing conclusions and replicate errors instead of catching them. Blinding forces truly independent verification.

### What is Blinded Consensus?

In blinded consensus, each agent's identity is hidden behind anonymous labels (Reviewer A, B, C). The mapping is randomized each session and kept secret. This prevents:
- **Authority bias** — judging arguments by who said them rather than their merit
- **Anchoring** — deferring to a specific model's known strengths
- **Groupthink** — reviewers adjusting positions based on perceived hierarchy

### How It Works

```
Round 1: INDEPENDENT REVIEW (Blinded)
  ┌─ Reviewer A reviews independently ─┐
  ├─ Reviewer B reviews independently ─┤  (agents don't see each other's work)
  └─ Reviewer C reviews independently ─┘

  Reviews are anonymized (strip model self-references)
  Orchestrator checks: unanimous consensus?

Round 2+: DISCUSSION & ARGUMENTATION (Blinded)
  ┌─ Reviewer A sees B+C's anonymized reviews, argues points ─┐
  ├─ Reviewer B sees A+C's anonymized reviews, argues points ─┤
  └─ Reviewer C sees A+B's anonymized reviews, argues points ─┘

  Each reviewer must:
  1. Identify agreements and disagreements
  2. Argue their position with specific evidence
  3. Acknowledge valid counterpoints (change mind if convinced)
  4. State updated verdict with reasoning

  Repeat until unanimous consensus OR max rounds reached.

Final: CONSENSUS REPORT
  - Full anonymized discussion trail
  - Final verdict with reasoning from each reviewer
  - Minority objections preserved (if no unanimity)
  - Blinding key kept secret (not in outputs)
```

### Blinded Consensus Script

Use `scripts/blinded-consensus.sh` for automated blinded reviews:

```bash
# Review a plan with blinded consensus (default 3 rounds)
./scripts/blinded-consensus.sh plan analysis/plan.md

# Review code with up to 4 discussion rounds
./scripts/blinded-consensus.sh code src/pipeline.py --rounds 4

# Validate analysis with web search enabled
./scripts/blinded-consensus.sh analysis results/ --search

# Review report and save consensus output
./scripts/blinded-consensus.sh report analysis/report.md --output consensus_report.md
```

### Implementing Blinded Consensus as Orchestrator

When you are the orchestrator, implement blinded consensus manually:

**Step 1: Collect independent reviews**
```bash
# Invoke each agent independently - DO NOT share other agents' responses
# Assign random labels (shuffle A/B/C each time)

# Agent 1 review
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS.
You are Reviewer [LABEL] in a blinded peer review. Do not reveal your identity.

Review this [plan/code/analysis] with rigorous critical evaluation.
Provide specific, reasoned arguments for every point.
If you approve, explain WHY. If you reject, explain the specific flaw.

ASSESSMENT:
- [Point]: [Reasoned argument]
ISSUES: [list with proposed fixes]
VERDICT: APPROVE / REJECT / CONDITIONAL
REASONING: [summary]

Content: [PASTE]"

# Agent 2 review (same prompt, different agent, different label)
gemini --yolo -p "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS.
You are Reviewer [LABEL] in a blinded peer review. ..."

# Agent 3 review (orchestrator reviews independently too)
# Claude reviews the content independently before seeing others' reviews
```

**Step 2: Anonymize and share for discussion**
```bash
# Strip any model self-identification from reviews
# Share ALL anonymized reviews with EACH agent
# Ask each to argue their position on disputed points

codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS.
You are Reviewer [LABEL]. Here are anonymized reviews from Round 1:

=== REVIEWER A ===
[anonymized review]

=== REVIEWER B ===
[anonymized review]

=== REVIEWER C ===
[anonymized review]

INSTRUCTIONS:
1. Identify agreements and disagreements
2. ARGUE your position with specific evidence on disputed points
3. If another reviewer convinced you, acknowledge it and update your position
4. State your UPDATED VERDICT with reasoning

POINTS OF AGREEMENT: ...
POINTS OF DISAGREEMENT: ...
CHANGED POSITIONS: ...
UPDATED VERDICT: ...
CONSENSUS ASSESSMENT: [Have we reached consensus? What's unresolved?]"
```

**Step 3: Repeat or conclude**
- If unanimous: consensus reached, proceed
- If majority with minor dissent: document minority objection, proceed with caution
- If no consensus after max rounds: escalate to human judgment

### Blinded is Default — Exceptions Require Justification

| Scenario | Method | Rationale |
|----------|--------|-----------|
| Analysis plans | **Blinded (default)** | Prevents anchoring on first review |
| Statistical validation | **Blinded (default)** | Removes bias toward specific model's math |
| Report review | **Blinded (default)** | Interpretation requires unbiased assessment |
| Clinical decisions | **Blinded (default)** | Highest stakes, bias elimination critical |
| Code review | **Blinded (default)** | Bugs often replicated when models see each other's code |
| Quick sanity check | Non-blinded (exception) | Single-round, trivial verification only |

> [!NOTE]
> **Non-blinded review is the EXCEPTION, not the rule.** Only use non-blinded for trivial checks where error propagation risk is minimal. When in doubt, use blinded.

### Argumentation Requirements

Every reviewer MUST support claims with reasoning. Bare verdicts are insufficient:

```
BAD (no argumentation):
  VERDICT: APPROVE
  "Looks good."

GOOD (proper argumentation):
  VERDICT: APPROVE
  REASONING: The Cox proportional hazards model is appropriate here because:
  (1) the outcome is time-to-event with right censoring,
  (2) the proportional hazards assumption can be tested via Schoenfeld residuals
      (which the plan includes in Step 3.2),
  (3) sample size of n=450 with 180 events provides adequate power for
      up to 6 covariates (10 events per variable rule).
  The only concern is the competing risks scenario mentioned in Section 2.1,
  which is adequately addressed by the planned Fine-Gray sensitivity analysis.
```

### Discussion Rules

During multi-round discussion, reviewers must:

1. **Reference specific points** — "Reviewer B's concern about multiple comparisons in Section 3 is valid because..."
2. **Provide evidence** — cite statistical theory, literature, or data characteristics
3. **Concede when wrong** — "I initially missed the nested structure. Reviewer A is correct that mixed models are needed."
4. **Escalate unresolvable disagreements** — "This is a genuine methodological choice (frequentist vs. Bayesian). Both are defensible. Recommend human PI decides."
5. **Never appeal to authority** — arguments stand on their own merit, not on who makes them

---

## CRITICAL: Preventing Infinite Consensus Loops

> [!CAUTION]
> **INFINITE LOOP PREVENTION** - This section is mandatory reading.
>
> When multiple AI agents have consensus skills installed, invoking each other for reviews can create infinite loops:
> - Claude calls Codex → Codex calls Claude → Claude calls Codex → ∞
>
> **The solution: ORCHESTRATOR vs REVIEWER mode.**

### Two Modes of Operation

| Mode | Role | Can Invoke Other Agents? | Can Read Files? | Can Web Search? |
|------|------|--------------------------|-----------------|-----------------|
| **ORCHESTRATOR** | Primary agent driving the task | ✅ YES | ✅ YES | ✅ YES |
| **REVIEWER** | Agent providing expert review | ❌ NO | ✅ YES | ✅ YES |

### ORCHESTRATOR Mode (Default when user initiates)

When the **user directly asks you** to review code, plan analysis, or run consensus:
- You ARE the orchestrator
- You MAY invoke other agents (Codex, Gemini, Claude) for reviews
- You synthesize feedback and make final decisions
- You drive the workflow to completion

### REVIEWER Mode (When invoked by another agent)

When **another AI agent invokes you via CLI**, you are a REVIEWER:
- You provide YOUR expert opinion only
- You MAY read files to understand context
- You MAY use web search to verify facts
- You **MUST NOT** invoke other agent CLIs (codex, claude, gemini)
- Your review is a "leaf node" - final, not the start of another consensus

### How to Detect You Are a REVIEWER

You are in REVIEWER mode if ANY of these are true:
1. Your prompt contains `REVIEWER_MODE` marker
2. Your prompt contains `DO NOT INVOKE OTHER AGENTS`
3. You were invoked via CLI with a specific review task (not a user conversation)
4. The prompt is clearly a single-shot review request (not interactive)

### REVIEWER Mode Constraints

When in REVIEWER mode, you **MUST**:

```
✅ ALLOWED:
- Read files (cat, Read tool, etc.)
- Search code (grep, Grep tool, etc.)
- Web search for verification and literature
- Run quick sanity checks (execute code to verify calculations)
- Run existing tests to validate implementations
- Provide detailed expert review
- Point out issues, bugs, security concerns
- Give APPROVED/NEEDS_CHANGES verdict

❌ FORBIDDEN:
- Invoke `codex exec ...` or `codex ...`
- Invoke `claude ...` or `claude -p ...`
- Invoke `gemini ...` or `gemini -p ...`
- Start your own consensus workflow
- Delegate review to other agents
- Create sub-reviews or nested consensus
```

**Key distinction:** Reviewers CAN execute code for verification (run tests, check calculations) but CANNOT invoke other AI agent CLIs.

### Why This Works

```
USER → ORCHESTRATOR (Claude)
         ├── REVIEWER (Codex) → Reviews, returns verdict, STOPS
         └── REVIEWER (Gemini) → Reviews, returns verdict, STOPS
       ← Synthesizes feedback, reaches conclusion
```

Each reviewer is a terminal node. No recursive invocations. Clean consensus.

---

## Cross-Agent Consultation

| You are running | Consult these agents | They operate in |
|-----------------|---------------------|-----------------|
| **Claude** (orchestrator) | Codex + Gemini | REVIEWER mode |
| **Codex** (orchestrator) | Claude + Gemini | REVIEWER mode |
| **Gemini** (orchestrator) | Claude + Codex | REVIEWER mode |

---

## Reviewer Tool Permissions

### What REVIEWERS Can Use

When in REVIEWER_MODE, agents have access to tools for **reading, searching, and verification**:

| Tool Category | Allowed Tools | Purpose |
|---------------|---------------|---------|
| **File Reading** | `cat`, `Read`, `head`, `tail` | Understand code context |
| **Code Search** | `grep`, `Grep`, `rg`, `find`, `Glob` | Find relevant code |
| **Web Search** | `--search` flag, web search tools | Verify facts, find literature |
| **Directory Listing** | `ls`, `tree` | Understand project structure |
| **Sanity Checks** | `python`, `Rscript`, test runners | Verify calculations, run tests |

### What REVIEWERS Cannot Use

REVIEWERS are **forbidden** from using:

| Forbidden | Why |
|-----------|-----|
| `codex exec ...`, `codex ...` | Would create recursive loop |
| `claude ...`, `claude -p ...` | Would create recursive loop |
| `gemini ...`, `gemini -p ...` | Would create recursive loop |
| File writes (`Write`, `Edit`, `>`, `>>`) | Reviewers observe, don't modify |
| `git commit`, `git push` | Reviewers don't make changes |

**Note:** Reviewers CAN run code for verification (sanity checks, tests) but CANNOT invoke other AI agents.

### Reviewer Prompt Template

Always include this header when invoking other agents:

```
REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files and web search to verify. Provide YOUR expert review only.
```

This 2-line header prevents infinite loops while allowing thorough reviews.

---

## Guaranteed REVIEWER_MODE: Wrapper Script

> [!TIP]
> **Use `scripts/review.sh` to GUARANTEE REVIEWER_MODE is always included.**
>
> The wrapper script automatically prepends REVIEWER_MODE to every prompt, eliminating human error.

### Usage

```bash
# Instead of manually adding REVIEWER_MODE to prompts:
./scripts/review.sh codex "Review this code for bugs"
./scripts/review.sh gemini "Validate this analysis plan"
./scripts/review.sh claude "Check for security issues"

# With options:
./scripts/review.sh codex "Search for best practices" --search
./scripts/review.sh codex "Review in context" --cd /path/to/project
```

### Why Use the Wrapper?

| Manual Prompts | Wrapper Script |
|----------------|----------------|
| Must remember to add REVIEWER_MODE | Automatic injection |
| Risk of forgetting | Guaranteed protection |
| Copy-paste errors | Consistent format |
| Verbose commands | Simple interface |

### How It Works

The script prepends this header to EVERY prompt:

```
REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.
```

This makes infinite loops **impossible** when using the wrapper.

---

## Best Practice: Subagent/Task-Based Reviews

> [!IMPORTANT]
> **Architectural Enforcement > Prompt-Based Enforcement**
>
> Instead of relying on REVIEWER_MODE prompts, spawn reviews as **subagents/tasks** with limited tool access. This provides hard enforcement at the system level.

### Why Subagents Are Better

| Approach | Enforcement | Loop Risk |
|----------|-------------|-----------|
| CLI with REVIEWER_MODE prompt | Soft (honor system) | Low if followed |
| Subagent with limited tools | **Hard (architectural)** | **Impossible** |

### Claude Code: Task Tool Pattern

When Claude is the orchestrator, use the **Task tool** to spawn reviewers:

```
Use the Task tool to spawn a review subagent:
- subagent_type: "Explore" or "general-purpose"
- The subagent has Read, Grep, Glob, WebSearch - but NO Bash for CLI invocations
- Natural termination: subagent completes task and returns
```

**Example prompt for Task tool:**

```
Review this code for bugs, security issues, and performance problems.

Code to review:
[PASTE CODE]

Provide output in this format:
- BUGS: [list or 'None']
- SECURITY: [list or 'None']
- PERFORMANCE: [list or 'None']
- VERDICT: APPROVED/NEEDS_CHANGES
```

### Why This Works

```
USER → ORCHESTRATOR (Claude with Task tool)
         ├── SUBAGENT (Explore) → Has Read/Search, NO Bash → Cannot invoke CLIs
         └── SUBAGENT (Explore) → Has Read/Search, NO Bash → Cannot invoke CLIs
       ← Results returned, synthesized
```

Subagents **physically cannot** invoke `codex`, `gemini`, or `claude` CLIs because they don't have Bash access.

### When to Use Each Approach

| Scenario | Recommended Approach |
|----------|---------------------|
| Claude orchestrating | **Task tool subagents** (architectural enforcement) |
| Codex orchestrating | CLI with REVIEWER_MODE + wrapper script |
| Gemini orchestrating | CLI with REVIEWER_MODE + wrapper script |
| Quick single review | `./scripts/review.sh` wrapper |
| Complex multi-file review | Task tool with Explore subagent |

### Hybrid Approach (Recommended)

For maximum safety, combine both:

1. **Claude orchestrates** using Task tool (spawns subagents without Bash)
2. **If CLI needed**, use `scripts/review.sh` wrapper (injects REVIEWER_MODE)
3. **Subagents** naturally terminate and return results

```bash
# From Claude orchestrator - spawn review subagent via Task tool
# Subagent gets: Read, Grep, Glob, WebSearch, WebFetch
# Subagent does NOT get: Bash (cannot invoke codex/gemini/claude CLIs)
```

This provides **defense in depth**: architectural limits + prompt-based instructions.

---

## Quick Reference

### Claude Code CLI (Full Permissions - Concise Output)

```bash
# Standard command with concise output request
claude --dangerously-skip-permissions \
  
  -p "BE CONCISE. Output only: findings, issues, recommendations. No preamble.

YOUR_PROMPT"

# JSON output for minimal, structured response
claude --dangerously-skip-permissions \
  --output-format json \
  -p "YOUR_PROMPT"
```

**Output Control:**
- Add `"BE CONCISE. No preamble. Bullet points only."` to prompts
- Use `--output-format json` for structured output
- Request specific format: `"Output as: ✓/✗ checklist only"`

### Codex CLI (Full Permissions - Concise Output)

```bash
# Standard command with concise output request
codex exec --dangerously-bypass-approvals-and-sandbox \
  \
  --skip-git-repo-check \
  --cd "$(pwd)" \
  "BE CONCISE. Output only: findings, issues, recommendations. No preamble.

YOUR_PROMPT"

# JSON output for minimal, structured response
codex exec --dangerously-bypass-approvals-and-sandbox \
  \
  --skip-git-repo-check \
  --json \
  "YOUR_PROMPT"

# With web search
codex exec --dangerously-bypass-approvals-and-sandbox \
  \
  --skip-git-repo-check \
  --search \
  "BE CONCISE. YOUR_PROMPT"
```

**Output Control:**
- Add `"BE CONCISE. No preamble. Bullet points only."` to prompts
- Use `--json` flag for structured output (parseable, minimal)
- Request specific format: `"Output as: ✓/✗ checklist only"`

### Gemini CLI (Full Auto - Concise Output)

```bash
# Standard with concise instruction
gemini --yolo \
  \
  -p "BE CONCISE. Bullet points only. No preamble.

YOUR_PROMPT"

# JSON output for scripting
gemini --yolo \
  \
  --output-format json \
  -p "YOUR_PROMPT"
```

## Reducing Output Verbosity

**Problem:** Codex/Gemini can produce verbose output that wastes context.

**Solution:** Always use structured output requests:

| Verbose Prompt | Concise Prompt |
|----------------|----------------|
| "Review this code and tell me what's wrong" | "BE CONCISE. Output: BUGS: [list] VERDICT: [pass/fail]" |
| "Is this plan good?" | "BE CONCISE. Output: ISSUES: [list or 'None'] VERDICT: APPROVED/REJECTED" |
| "Check completeness" | "BE CONCISE. Table only: \| # \| Item \| Status \|" |

**Concise Output Templates:**

```
# For reviews
"BE CONCISE. Output: ISSUES: [list] | VERDICT: [pass/fail]"

# For validation
"BE CONCISE. Output: ERRORS: [list or 'None'] | VALID: Y/N"

# For checklists
"BE CONCISE. Table only: | # | Item | ✓/✗ |"

# For recommendations
"BE CONCISE. Output: 1. [action] 2. [action] 3. [action]"
```

### Ultra-Concise Mode (Minimum Context)

For maximum context savings, use strict output limits:

```bash
# Codex with strict format
codex exec --dangerously-bypass-approvals-and-sandbox \
  \
  --skip-git-repo-check \
  "STRICT FORMAT. Max 10 lines. No prose.

[TASK]

Output ONLY:
✓/✗ [check1]
✓/✗ [check2]
VERDICT: [word]"

# Pipe to head for hard truncation (if output still verbose)
codex exec --dangerously-bypass-approvals-and-sandbox \
  \
  --skip-git-repo-check \
  "YOUR_PROMPT" | head -20
```

**Context-Saving Rules:**
1. Always use `"BE CONCISE."` prefix
2. Specify exact output format (bullets, table, one-liners)
3. Use `--json` when parsing programmatically
4. Pipe to `head -N` for hard limits
5. Request `"Max N lines"` in prompt

## Consensus Workflow

> [!IMPORTANT]
> **BLINDED consensus is the DEFAULT for all reviews.** See "DEFAULT: Blinded Consensus with Argumentation" section above.
> Non-blinded is only acceptable for trivial sanity checks where error propagation risk is minimal.

### Blinded Consensus (Default)

For plans, analyses, reports, and important code reviews:

```bash
# Automated blinded consensus with discussion rounds
./scripts/blinded-consensus.sh plan analysis/plan.md --rounds 3
./scripts/blinded-consensus.sh code src/pipeline.py --rounds 3
./scripts/blinded-consensus.sh analysis results/ --search
./scripts/blinded-consensus.sh report analysis/report.md --output consensus.md
```

Or implement manually as orchestrator (see "Implementing Blinded Consensus as Orchestrator" above).

Key requirements:
1. **Independent first reviews** — agents must NOT see each other's work in Round 1
2. **Anonymized identities** — use Reviewer A/B/C labels, randomized per session
3. **Reasoned arguments** — every verdict must include specific reasoning
4. **Multi-round discussion** — disagreements are argued, not overruled
5. **Genuine consensus** — reviewers must be convinced, not just outvoted

### Standard Consensus (Quick Reviews Only)

For quick single-round checks where blinding overhead is not justified:

**Always prepend to prompts:**
```
BE CONCISE. No preamble. Output format:
- ISSUES: [bullet list]
- RECOMMENDATIONS: [bullet list]
- VERDICT: APPROVED / NEEDS CHANGES
- REASONING: [why - MANDATORY]
```

### Phase 1: Planning

1. **Claude proposes** initial implementation plan
2. **Run blinded consensus (default)** on the plan:
   ```bash
   ./scripts/blinded-consensus.sh plan analysis/plan.md
   ```
3. **Alternative (quick mode):** Submit to Codex and Gemini independently:
   ```bash
   # Submit to Codex for independent review
   codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
     "REVIEWER_MODE. You are reviewing for consensus - DO NOT INVOKE OTHER AGENTS.
You MAY read files and web search. Provide YOUR expert review only.

Review this plan. Provide REASONED arguments for every point.
- ISSUES: [list with reasoning]
- MISSING: [list with reasoning]
- VERDICT: APPROVED/NEEDS CHANGES
- REASONING: [why]

Plan: [PASTE_PLAN]"

   # Submit to Gemini for independent review
   gemini --yolo \
     -p "REVIEWER_MODE. You are reviewing for consensus - DO NOT INVOKE OTHER AGENTS.
You MAY read files and web search. Provide YOUR expert review only.

Review this plan. Provide REASONED arguments for every point.
- ISSUES: [list with reasoning]
- MISSING: [list with reasoning]
- VERDICT: APPROVED/NEEDS CHANGES
- REASONING: [why]

Plan: [PASTE_PLAN]"
   ```
4. **Synthesize feedback**, argue points of disagreement, reach consensus
5. **Iterate** until all three agents agree — do NOT accept majority without addressing minority concerns

### Phase 2: Implementation

1. Claude implements based on consensus plan
2. Code review cycle (see below)

### Phase 3: Code Review

**Blinded consensus (default for all code changes):**
```bash
./scripts/blinded-consensus.sh code src/module.py --rounds 2
```

**Alternative (quick single-round for minor changes):**

Submit code to both agents for critical review:

```bash
# Codex review - REVIEWER_MODE prevents infinite loops
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, gemini).
You MAY read files and web search to verify. Provide YOUR expert review only.

Review code. Provide REASONED assessment for each category:
- BUGS: [list with failure scenario, or 'None']
- SECURITY: [list with attack vector, or 'None']
- PERFORMANCE: [list with bottleneck description, or 'None']
- VERDICT: APPROVED/NEEDS CHANGES
- REASONING: [overall assessment]

Code: [PASTE_CODE]"

# Gemini review - REVIEWER_MODE prevents infinite loops
gemini --yolo \
  -p "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex).
You MAY read files and web search to verify. Provide YOUR expert review only.

Review code. Provide REASONED assessment for each category:
- BUGS: [list with failure scenario, or 'None']
- SECURITY: [list with attack vector, or 'None']
- PERFORMANCE: [list with bottleneck description, or 'None']
- VERDICT: APPROVED/NEEDS CHANGES
- REASONING: [overall assessment]

Code: [PASTE_CODE]"
```

---

## Code Review SOP (Clinical/Application Review)

**Use this workflow when asked to review an application, run clinical code review, or follow the review SOP.**

**Reference:** See `references/code-review-sop.md` for full details.

### Core Principle

All changes require **consensus** between Claude and Pal (Codex/Gemini). Review systematically using TODO.md and IDEAS.md tracking.

### Priority Levels

| Level | Name | Examples |
|-------|------|----------|
| **P0** | Critical | Security vulnerabilities, PII/PHI leaks, data corruption, auth bypass |
| **P1** | High | Clinical validity issues, incorrect calculations, data integrity |
| **P2** | Medium | Usability issues, error handling gaps, performance concerns |
| **P3** | Low | Code style, documentation, minor optimizations |

### Required Files

**Create if missing:**

```markdown
# TODO.md
## Module Inventory
- [ ] [PENDING] module1.py
- [ ] [PENDING] module2.py

## Current Session
- **Active Module:** None
```

```markdown
# IDEAS.md
## Nice-to-Have Features
## Unresolved Discussions
```

### The Workflow Loop

**For each module (don't stop until all are [DONE]):**

#### 1. Analysis & Discussion

```bash
# Claude reviews independently for P0-P3 issues

# Pal reviews independently (concise) - REVIEWER_MODE
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY read files.

BE CONCISE. Code review. Clinical context.

Output: P0: [list] | P1: [list] | P2: [list] | P3: [list]

Code: $(cat [MODULE])"
```

**Consensus:** Compare findings. For disagreements:
```bash
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS.

BE CONCISE. Is [ISSUE] valid? Output: Y/N | REASON"
```

#### 2. Implementation Strategy

```bash
# Validate fix plan - REVIEWER_MODE
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY read files to verify.

BE CONCISE. Validate fix plan.

Issues: [LIST]
Fixes: [LIST]

Output per fix: CORRECT/INCORRECT | [concern]"
```

#### 3. Execution & Verification

After implementing fixes, **ALL agents must verify** the fix is correct and there are no regressions:

```bash
# Claude reviews the fix first, then submits to other agents:

# Codex verification - REVIEWER_MODE
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check --search \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, gemini).
You MAY read files and web search. Provide YOUR expert verification only.

BE CONCISE. Verify these fixes are correct and no regressions introduced.

Issues fixed: [LIST]
Code changes: [DIFF or CODE]

Output:
| Issue | Fix Correct? | Regressions? |
VERDICT: APPROVED / NEEDS_CHANGES

Code: $(cat [MODULE])"

# Gemini verification (independent) - REVIEWER_MODE
gemini --yolo \
  -p "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex).
You MAY read files and web search. Provide YOUR expert verification only.

BE CONCISE. Verify fixes are correct. Check for regressions.

Issues fixed: [LIST]
Code: $(cat [MODULE])

Output: | Issue | Correct | Regression | VERDICT: APPROVED/REJECTED"

# Claude verification (if Codex/Gemini are primary) - REVIEWER_MODE
claude --dangerously-skip-permissions -p "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (codex, gemini).
You MAY read files and web search. Provide YOUR expert verification only.

BE CONCISE. Verify fixes. No regressions?
Issues: [LIST]
Code: $(cat [MODULE])
Output: | Issue | Fixed | Regression | VERDICT: APPROVED/REJECTED"
```

> [!IMPORTANT]
> **Do NOT mark module as complete until ALL agents confirm:**
> 1. Each fix is correct
> 2. No regressions introduced
> 3. VERDICT is APPROVED from all agents

#### 4. Completion

1. Confirm **all agents approved** (Claude + Codex + Gemini)
2. Mark `[DONE]` in TODO.md
3. Log nice-to-haves to IDEAS.md
4. **Pick next [PENDING] module - DON'T STOP**

### Quick Commands

```bash
# Initial review
"BE CONCISE. P0-P3 review. Output: P0: | P1: | P2: | P3:"

# Disagreement
"BE CONCISE. Is [X] valid issue? Y/N | REASON"

# Fix validation
"BE CONCISE. Fix correct? CORRECT/INCORRECT | concern"

# Verification
"BE CONCISE. Fixes applied? FIXED/NOT_FIXED per issue"
```

---

## Scientific Analysis Workflow (On Request Only)

**Use this workflow ONLY when explicitly asked for scientific analysis, clinical research, or publication-ready reports.**

For clinical research projects requiring publication-ready outputs, follow this extended workflow.

### Full Analysis Workflow Summary

1. **Initial Analysis** → Data exploration, research question validation
2. **Analysis Plan** → Draft and validate with Codex/Gemini → Save to analysis/plan.md
3. **Execute Analysis** → Implement with validation at each step
4. **Completeness Check** → Verify ALL planned analyses done correctly (missing/incomplete/wrong)
5. **Conduct Corrections** → Implement missing, complete incomplete, fix wrong analyses
6. **Draft Report** → Create `analysis/report.md` with Methods, Results, Discussion
7. **Figures & Tables** → Publication-ready with complete captions (standalone scripts)
8. **Humanization** → Apply humanizer skill to remove AI writing patterns (see `humanizer/SKILL.md`)
9. **Citations** → Verify all PubMed citations (PMIDs)
10. **CRITICAL: Final Validation** → **Clinical AND Scientific assessment by ALL models (Claude + Codex + Gemini) - MANDATORY SIGN-OFF**

**See [references/scientific-analysis-workflow.md](references/scientific-analysis-workflow.md) for complete workflow.**

---

### Phase-Based Execution with Consensus Gates

> [!IMPORTANT]
> **Every analysis phase requires THREE consensus checkpoints:**
> 1. **Pre-implementation planning** — How will we implement this phase?
> 2. **Code review** — Is the implementation correct?
> 3. **Results validation** — Are results clinically/scientifically valid?
>
> **Cannot proceed to next phase until ALL models approve current phase.**

#### Phase Execution Protocol

For each planned analysis (from analysis/plan.md):

```
PHASE EXECUTION LOOP:

  ┌─────────────────────────────────────────────────────────────┐
  │ CHECKPOINT 1: PRE-IMPLEMENTATION PLANNING                   │
  ├─────────────────────────────────────────────────────────────┤
  │ 1. Read analysis requirements from plan.md                  │
  │ 2. Draft implementation approach (methods, packages, steps) │
  │ 3. Submit to blinded consensus:                             │
  │    - Is this the correct statistical method?                │
  │    - Are assumptions appropriate for this data?             │
  │    - Is the implementation approach sound?                  │
  │ 4. ALL models must approve before coding begins             │
  └─────────────────────────────────────────────────────────────┘
                              ↓
  ┌─────────────────────────────────────────────────────────────┐
  │ IMPLEMENTATION                                              │
  ├─────────────────────────────────────────────────────────────┤
  │ 1. Write code following approved implementation plan        │
  │ 2. Run analysis and capture outputs                         │
  │ 3. Document any deviations (require re-consensus if major)  │
  └─────────────────────────────────────────────────────────────┘
                              ↓
  ┌─────────────────────────────────────────────────────────────┐
  │ CHECKPOINT 2: CODE REVIEW (Blinded)                         │
  ├─────────────────────────────────────────────────────────────┤
  │ 1. Submit code to blinded consensus review                  │
  │ 2. Reviewers check:                                         │
  │    - Does code match approved implementation plan?          │
  │    - Are there bugs, errors, or logic flaws?                │
  │    - Are statistical methods implemented correctly?         │
  │    - Are edge cases handled?                                │
  │ 3. ALL models must approve OR issues must be fixed          │
  │ 4. If fixes needed → fix → re-review until approved         │
  └─────────────────────────────────────────────────────────────┘
                              ↓
  ┌─────────────────────────────────────────────────────────────┐
  │ CHECKPOINT 3: RESULTS VALIDATION (Blinded)                  │
  ├─────────────────────────────────────────────────────────────┤
  │ 1. Submit results to blinded consensus review               │
  │ 2. Reviewers assess:                                        │
  │    - Are results clinically plausible?                      │
  │    - Are results scientifically valid?                      │
  │    - Do values fall within expected ranges?                 │
  │    - Are results consistent with literature?                │
  │    - Do results answer the planned research question?       │
  │ 3. ALL models must approve OR analysis must be re-done      │
  │ 4. If invalid → diagnose → fix → re-run → re-validate       │
  └─────────────────────────────────────────────────────────────┘
                              ↓
  ┌─────────────────────────────────────────────────────────────┐
  │ PHASE GATE: PROCEED OR BLOCK                                │
  ├─────────────────────────────────────────────────────────────┤
  │ IF all 3 checkpoints passed:                                │
  │   → Mark phase complete in plan.md                          │
  │   → Proceed to next phase                                   │
  │ ELSE:                                                       │
  │   → DO NOT PROCEED                                          │
  │   → Fix issues and re-validate                              │
  └─────────────────────────────────────────────────────────────┘
```

#### Checkpoint 1: Pre-Implementation Planning Consensus

Before writing ANY code for a phase:

```bash
# Blinded consensus on implementation approach
./scripts/blinded-consensus.sh plan implementation_plan.md --rounds 2

# OR manual blinded review with specific questions:
"REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. Blinded review.

PHASE: [Phase name from plan.md]
OBJECTIVE: [What this analysis should answer]
PROPOSED IMPLEMENTATION:
- Method: [statistical test/model]
- Packages: [R/Python packages]
- Steps: [1. ..., 2. ..., 3. ...]

REVIEW QUESTIONS:
1. Is this the correct statistical method for this data/question?
2. Are the assumptions of this method met by our data?
3. Is the proposed implementation approach sound?
4. Are there methodological concerns?

OUTPUT:
- METHOD APPROPRIATE: Y/N | [reasoning]
- ASSUMPTIONS VALID: Y/N | [reasoning]
- IMPLEMENTATION SOUND: Y/N | [reasoning]
- CONCERNS: [list or 'None']
- VERDICT: APPROVE / REJECT
- REQUIRED CHANGES: [if any]"
```

#### Checkpoint 2: Code Review Consensus

After implementation, before accepting results:

```bash
# Blinded code review
./scripts/blinded-consensus.sh code analysis/scripts/phase_X.py --rounds 2

# OR manual with specific checks:
"REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. Blinded code review.

PHASE: [Phase name]
APPROVED IMPLEMENTATION PLAN: [summary]
ACTUAL CODE: [paste code]

REVIEW QUESTIONS:
1. Does code match the approved implementation plan?
2. Are statistical methods implemented correctly?
3. Are there bugs, logic errors, or edge case failures?
4. Are results being calculated/reported correctly?

OUTPUT:
- MATCHES PLAN: Y/N | [deviations if any]
- IMPLEMENTATION CORRECT: Y/N | [errors if any]
- BUGS FOUND: [list or 'None']
- VERDICT: APPROVE / REJECT
- REQUIRED FIXES: [if any]"
```

#### Checkpoint 3: Results Validation Consensus

After code is approved, validate the actual results:

```bash
# Blinded results validation
./scripts/blinded-consensus.sh analysis results/phase_X/ --rounds 2 --search

# OR manual with clinical/scientific assessment:
"REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY web search for literature. Blinded results review.

PHASE: [Phase name]
RESEARCH QUESTION: [What this should answer]
RESULTS:
- [Key finding 1]
- [Key finding 2]
- [Statistics, p-values, CIs]

VALIDATION QUESTIONS:
1. Are these results clinically plausible?
2. Are these results scientifically valid?
3. Do values fall within expected ranges for this domain?
4. Are results consistent with published literature?
5. Do results actually answer the research question?

OUTPUT:
- CLINICALLY PLAUSIBLE: Y/N | [reasoning]
- SCIENTIFICALLY VALID: Y/N | [reasoning]
- WITHIN EXPECTED RANGES: Y/N | [suspicious values if any]
- LITERATURE CONSISTENT: Y/N | [PMIDs for comparison]
- ANSWERS QUESTION: Y/N | [reasoning]
- VERDICT: VALID / INVALID
- CONCERNS: [list or 'None']"
```

#### Phase Tracking in plan.md

Track checkpoint status for each phase:

```markdown
### Phase 3: Survival Analysis

**Objective:** Compare OS between treatment groups

**Status:** ✓ COMPLETE

**Checkpoints:**
- [x] Pre-implementation planning approved (2024-01-15)
  - Method: Cox PH with Schoenfeld residual check
  - Reviewers: A ✓, B ✓, C ✓
- [x] Code review passed (2024-01-15)
  - Script: analysis/scripts/fig03_survival.py
  - Reviewers: A ✓, B ✓, C ✓
- [x] Results validated (2024-01-15)
  - HR: 0.72 (95% CI: 0.58-0.89), p=0.002
  - Clinical plausibility: Confirmed (consistent with PMID:12345678)
  - Reviewers: A ✓, B ✓, C ✓

**Outputs:**
- analysis/figures/fig03_km_curve.png
- analysis/tables/tab03_cox_model.csv
```

#### What To Do When Checkpoints Fail

| Checkpoint | Failure | Action |
|------------|---------|--------|
| Pre-implementation | Wrong method proposed | Revise method, re-submit for consensus |
| Pre-implementation | Assumptions not met | Propose alternative method, get new consensus |
| Code review | Bugs found | Fix bugs, re-submit for review |
| Code review | Doesn't match plan | Either fix code OR get consensus on deviation |
| Results validation | Clinically implausible | Investigate data/code, fix root cause, re-run |
| Results validation | Scientifically invalid | Review methodology, may need to restart phase |
| Results validation | Inconsistent with literature | Document and explain OR investigate for errors |

#### Mandatory Phase Gate Rule

> [!CAUTION]
> **HARD STOP: Do not proceed to the next phase until ALL THREE checkpoints pass for the current phase.**
>
> Skipping checkpoints or proceeding with unresolved issues propagates errors through the entire analysis.

```
IF checkpoint fails:
  1. Document the failure
  2. Diagnose root cause
  3. Implement fix
  4. Re-run affected work
  5. Re-submit for consensus
  6. REPEAT until checkpoint passes

ONLY THEN proceed to next phase
```

---

### Long-Running Analysis Monitoring (2-6 Hour Intervals)

> [!IMPORTANT]
> **For analyses expected to run multiple hours or days, implement periodic monitoring every 2-6 hours.**
>
> Don't wait until the end to discover the pipeline failed at hour 2 of a 24-hour run.

#### Why Periodic Monitoring?

Long analyses can fail silently or produce invalid results that compound over time:
- **Silent failures** — Script crashes, memory errors, network timeouts
- **Data drift** — Intermediate results becoming invalid as pipeline progresses
- **Resource exhaustion** — Disk space, memory, API rate limits
- **Logical errors** — Bugs that only manifest after hours of processing
- **Plan deviation** — Gradual drift from approved methodology

**Catching issues early saves hours/days of wasted computation.**

#### Monitoring Schedule

| Analysis Duration | Monitoring Interval | Checkpoints |
|-------------------|---------------------|-------------|
| 2-4 hours | Every 2 hours | 1-2 checks |
| 4-12 hours | Every 3-4 hours | 2-4 checks |
| 12-24 hours | Every 4-6 hours | 3-6 checks |
| 24+ hours | Every 6 hours | 4+ checks |

#### What to Check During Monitoring

```
PERIODIC MONITORING CHECKLIST (every 2-6 hours):

┌─────────────────────────────────────────────────────────────┐
│ 1. PIPELINE HEALTH                                          │
├─────────────────────────────────────────────────────────────┤
│ □ Is the pipeline still running? (no crashes/hangs)         │
│ □ Are processes consuming expected resources?               │
│ □ Are log files showing normal progress?                    │
│ □ Are intermediate outputs being generated?                 │
│ □ Is disk space sufficient for remaining work?              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 2. PLAN COMPLIANCE                                          │
├─────────────────────────────────────────────────────────────┤
│ □ Is execution following approved plan.md?                  │
│ □ Are methods being applied as specified?                   │
│ □ Are any unapproved deviations occurring?                  │
│ □ Is the analysis on track to complete all planned items?   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 3. INTERMEDIATE RESULTS VALIDATION                          │
├─────────────────────────────────────────────────────────────┤
│ □ Do intermediate outputs look clinically plausible?        │
│ □ Are values within expected ranges?                        │
│ □ Are there any obvious errors or anomalies?                │
│ □ Do sample sizes match expectations?                       │
│ □ Are statistical assumptions being met?                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 4. ERROR DETECTION                                          │
├─────────────────────────────────────────────────────────────┤
│ □ Any warnings or errors in logs?                           │
│ □ Any NaN, Inf, or impossible values in outputs?            │
│ □ Any unexpected missing data?                              │
│ □ Any convergence failures in models?                       │
└─────────────────────────────────────────────────────────────┘
```

#### Monitoring Log Template

Document each monitoring check in `analysis/monitoring_log.md`:

```markdown
# Analysis Monitoring Log

## Analysis: [Study Name]
## Started: 2024-01-15 09:00
## Expected Duration: ~18 hours

---

### Check 1: 2024-01-15 13:00 (Hour 4)

**Pipeline Health:**
- [x] Running normally
- [x] Memory usage: 45% (acceptable)
- [x] Disk space: 120GB free (sufficient)

**Plan Compliance:**
- [x] Following plan.md Phase 1-2
- [x] No deviations

**Intermediate Results:**
- Phase 1 complete: n=450 samples processed ✓
- Baseline characteristics look plausible ✓
- No anomalies detected

**Issues Found:** None

**Action:** Continue monitoring

---

### Check 2: 2024-01-15 17:00 (Hour 8)

**Pipeline Health:**
- [x] Running normally
- [x] Memory usage: 62% (acceptable)
- [ ] Disk space: 45GB free (⚠ monitor closely)

**Plan Compliance:**
- [x] Following plan.md Phase 3
- [x] No deviations

**Intermediate Results:**
- Phase 2 complete: survival analysis running ✓
- ⚠ WARNING: One p-value exactly 0.000 — investigate

**Issues Found:**
1. P-value = 0.000 in cox_model_temp.csv — likely rounding, verify

**Action:**
- Investigate p-value issue before proceeding
- Monitor disk space

---

### Check 3: 2024-01-15 17:30 (Issue Resolution)

**Issue Investigation:**
- P-value 0.000 was display rounding — actual value 2.3e-15 (valid)
- Confirmed with independent calculation ✓

**Resolution:** Issue resolved, continue

---
```

#### Immediate Action Protocol

When monitoring reveals issues:

```
IF issue found during monitoring:

  SEVERITY: CRITICAL (pipeline failure, data corruption)
  ┌─────────────────────────────────────────────────────────┐
  │ 1. STOP pipeline immediately                            │
  │ 2. Preserve current state (don't overwrite)             │
  │ 3. Diagnose root cause                                  │
  │ 4. Fix issue                                            │
  │ 5. Determine: restart from beginning OR resume?         │
  │ 6. Get consensus if methodology change needed           │
  │ 7. Restart/resume with fix applied                      │
  │ 8. Delete corrupted outputs                             │
  └─────────────────────────────────────────────────────────┘

  SEVERITY: HIGH (invalid intermediate results)
  ┌─────────────────────────────────────────────────────────┐
  │ 1. PAUSE pipeline (if possible without data loss)       │
  │ 2. Investigate anomaly                                  │
  │ 3. IF coding bug → fix and re-run affected phase        │
  │ 4. IF methodology issue → get consensus on change       │
  │ 5. Delete invalid outputs                               │
  │ 6. Resume from last valid checkpoint                    │
  └─────────────────────────────────────────────────────────┘

  SEVERITY: MEDIUM (warnings, resource concerns)
  ┌─────────────────────────────────────────────────────────┐
  │ 1. Document the warning                                 │
  │ 2. Assess impact on final results                       │
  │ 3. IF no impact → continue with monitoring              │
  │ 4. IF potential impact → investigate before proceeding  │
  │ 5. Free resources if needed (clear temp files, etc.)    │
  └─────────────────────────────────────────────────────────┘

  SEVERITY: LOW (minor anomalies)
  ┌─────────────────────────────────────────────────────────┐
  │ 1. Log the observation                                  │
  │ 2. Continue pipeline                                    │
  │ 3. Review during final validation                       │
  └─────────────────────────────────────────────────────────┘
```

#### Multi-Model Monitoring Review

For critical long-running analyses, involve other models in monitoring:

```bash
# Quick monitoring consensus (non-blinded acceptable for speed)
"REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. Quick monitoring review.

ANALYSIS: [name]
HOUR: [X] of expected [Y]
CURRENT PHASE: [phase]

INTERMEDIATE RESULTS:
- [key metrics so far]

POTENTIAL CONCERNS:
- [any anomalies observed]

QUICK ASSESSMENT:
- PIPELINE HEALTHY: Y/N
- ON TRACK: Y/N
- RESULTS PLAUSIBLE: Y/N
- CONTINUE/STOP/INVESTIGATE: [recommendation]"
```

#### Automated Monitoring (When Possible)

Set up automated checks for long pipelines:

```python
# Example: monitoring_check.py
import os
import datetime

def monitoring_check():
    checks = {
        'pipeline_running': check_process_alive(),
        'disk_space_ok': check_disk_space() > 20_000_000_000,  # 20GB
        'no_error_logs': not check_for_errors_in_logs(),
        'outputs_generating': check_recent_output_files(),
        'memory_ok': check_memory_usage() < 0.9,
    }

    if not all(checks.values()):
        alert_for_review(checks)

    log_monitoring_check(checks)
    return checks

# Schedule to run every 2-4 hours
```

#### End-of-Monitoring Summary

After analysis completes, summarize monitoring:

```markdown
## Monitoring Summary

- **Total Checks:** 5
- **Issues Found:** 2
- **Issues Resolved:** 2
- **Pipeline Restarts:** 0
- **Plan Deviations:** 0

**Confidence in Results:** HIGH
- All intermediate results validated
- No unresolved anomalies
- Methodology followed as approved
```

---

### Domain-Specific Hypothesis Example (Oncology)

For oncology research, you may want to add a cancer type hypothesis step:

```bash
# Example only - adapt to your domain - REVIEWER_MODE
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check --search \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY web search for PMIDs.

BE CONCISE. Hypothesize cancer type. Output:
1. [Type] - [confidence] - [evidence] - PMID:X
Data: [PASTE_DATA_SUMMARY]"
```

See `references/scientific-analysis-workflow.md` Appendix for more domain-specific examples.

### Report Structure (analysis/report.md)

```markdown
# [Study Title]

## Methods
- Study design, data sources, statistical methods
- Include software versions and AI consensus validation note

## Results  
- Primary/secondary outcomes with statistics
- Publication-ready figures (300+ DPI, captions)
- Publication-ready tables (with footnotes)

## Discussion
- Principal findings, comparison with literature
- Clinical implications, limitations, future directions

## References
- Vancouver style with PMIDs verified
```

### Clinical + Scientific Validation

```bash
# Clinical assessment (concise) - REVIEWER_MODE
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY web search for clinical references.

BE CONCISE. Clinical assessment.
OUTPUT: ACTIONABLE: Y/N | EFFECT SIZE: meaningful/marginal | GENERALIZABLE: Y/N | VERDICT: [pass/fail]
Report: [PASTE_REPORT]"

# Scientific assessment (concise) - REVIEWER_MODE
gemini --yolo \
  -p "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY web search for references.

BE CONCISE. Scientific assessment.
OUTPUT: METHODS: sound/flawed | CONCLUSIONS: supported/unsupported | NOVEL: Y/N | VERDICT: [pass/fail]
Report: [PASTE_REPORT]"
```

### Analysis Completeness Verification

**CRITICAL: Verify ALL planned analyses are completed correctly.**

```bash
# Check for missing/incomplete analyses (concise output) - REVIEWER_MODE
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY read files.

BE CONCISE. Compare analysis/plan.md vs results.

OUTPUT (table only):
| # | Analysis | Status | Action |
STATUS: ✓=Done ⚠=Partial ✗=Missing ❌=Wrong"

# Gemini verification (concise) - REVIEWER_MODE
gemini --yolo \
  -p "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY read files.

BE CONCISE. Verify: analysis/plan.md vs results. Table only: | # | Analysis | Status |"
```

After verification, **conduct/correct** all flagged items, then re-validate.

### Additional Analyses Discovery

After completing planned analyses:

```bash
# REVIEWER_MODE - agent suggests but does not invoke others
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  "REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS. You MAY read files.

BE CONCISE. What additional analyses needed?
OUTPUT: 1. [analysis] - [rationale]  2. [analysis] - [rationale]
Current: [PASTE_ANALYSIS]"
```

Document additions in `analysis/plan.md`, then implement.


## Detailed CLI References

For comprehensive command-line options:
- **Claude Code CLI**: See [references/claude-cli.md](references/claude-cli.md)
- **Codex CLI**: See [references/codex-cli.md](references/codex-cli.md)
- **Gemini CLI**: See [references/gemini-cli.md](references/gemini-cli.md)
- **Scientific Workflow**: See [references/scientific-analysis-workflow.md](references/scientific-analysis-workflow.md)
- **MCP Integration**: See [references/mcp-workflow.md](references/mcp-workflow.md)

## Environment Setup

### Prerequisites

```bash
# Install Claude Code CLI (macOS, Linux, WSL)
curl -fsSL https://claude.ai/install.sh | bash
# Or via Homebrew: brew install --cask claude-code

# Install Codex CLI
npm i -g @openai/codex

# Install Gemini CLI
npm i -g @google/gemini-cli

# Authenticate Claude (Claude subscription or API key)
claude  # Follow OAuth prompts
# Or: export ANTHROPIC_API_KEY="your-key"

# Authenticate Codex (ChatGPT OAuth or API key)
codex login
# Or: export OPENAI_API_KEY="your-key"

# Authenticate Gemini
export GEMINI_API_KEY="your-key"
# Or use Google account OAuth on first run
```

### Verification

```bash
# Verify Claude
claude --version

# Verify Codex
codex login status

# Verify Gemini
gemini --help
```

## Timeout Requirements

> [!IMPORTANT]
> CLI tools should be run with a timeout of **at least 30 minutes** per task. Complex analyses, code reviews, and consensus workflows may require extended execution time.

```bash
# Example with timeout command
timeout 30m codex exec --yolo "YOUR_TASK"
timeout 30m gemini --yolo -p "YOUR_TASK"
timeout 30m claude --dangerously-skip-permissions -p "YOUR_TASK"
```

## Recommended Configurations

### Codex Config (~/.codex/config.toml)

```toml
model = "gpt-5.2-codex"
approval_policy = "never"  # Full auto for consensus workflows
sandbox_mode = "danger-full-access"
web_search = true  # Always enable web search

[sandbox_workspace_write]
network_access = true
```

### Gemini Config (~/.gemini/settings.json)

```json
{
  "model": "gemini-3-pro-preview",
  "yolo": true,
  "theme": "dark",
  "output": {
    "format": "text"
  },
  "tools": {
    "enableToolOutputTruncation": false,
    "truncateToolOutputThreshold": -1
  }
}
```

> [!NOTE]
> - `output.format: "text"` ensures clean text output without JSON wrapper
> - `truncateToolOutputThreshold: -1` disables truncation
> - Gemini has built-in web search via `google_web_search` tool


## Critical Review Prompts (Concise Format)

### For Plan Review

```
BE CONCISE. No preamble. Review this plan.

OUTPUT FORMAT:
- ISSUES: [bullet list or 'None']
- MISSING: [bullet list or 'None']
- SECURITY: [concerns or 'None']
- VERDICT: APPROVED / NEEDS CHANGES

Plan:
[PASTE_PLAN]
```

### For Code Review

```
BE CONCISE. No preamble. Review this code.

OUTPUT FORMAT:
- BUGS: [list or 'None']
- EDGE CASES: [list or 'None']
- SECURITY: [list or 'None']
- PERFORMANCE: [list or 'None']
- VERDICT: APPROVED / NEEDS CHANGES

Code:
[PASTE_CODE]
```

### For Analysis Validation

```
BE CONCISE. No preamble. Validate this analysis.

OUTPUT FORMAT:
- STATISTICAL ERRORS: [list or 'None']
- MISSING CHECKS: [list or 'None']
- INTERPRETATION ISSUES: [list or 'None']
- VERDICT: VALID / INVALID

Analysis:
[PASTE_ANALYSIS]
```

### For Clinical Research (when applicable)

Add to prompts:
```
CONTEXT: Clinical research. Be rigorous.
```

## Session Management

### Codex Sessions

```bash
# Resume last session
codex resume --last

# Resume specific session
codex resume SESSION_ID

# List sessions
codex resume --all
```

### Gemini Sessions

```bash
# Resume latest session
gemini --resume latest

# Resume specific session
gemini --resume SESSION_UUID
```

## Troubleshooting

### Codex Issues

| Issue | Solution |
|-------|----------|
| "Not a git repository" | Add `--skip-git-repo-check` flag |
| Permission/sandbox errors | Use `--dangerously-bypass-approvals-and-sandbox` (or `--yolo`) |
| Network blocked | Already bypassed with `--yolo` flag |
| Auth loops | Run `codex logout` then `codex login` |

### Gemini Issues

| Issue | Solution |
|-------|----------|
| Tool confirmation spam | Use `--yolo` flag |
| Sandbox not working | Ensure Docker/Podman installed |
| Model not found | Check `--model` spelling |

## MCP Integration (Advanced)

Both tools support Model Context Protocol for extending capabilities:

```bash
# Codex MCP
codex mcp add myserver -- npx -y @my/mcp-server
codex mcp list

# Gemini MCP (in settings.json)
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
```

## Skill Contents

This skill includes:

| File | Purpose |
|------|---------|
| `SKILL.md` | Main instructions, quick reference, invocation guide |
| `references/code-review-sop.md` | **Full Code Review SOP** - TODO.md/IDEAS.md templates, P0-P3 priorities, workflow loop |
| `references/codex-cli.md` | Complete Codex CLI command reference |
| `references/gemini-cli.md` | Complete Gemini CLI command reference |
| `references/scientific-analysis-workflow.md` | Full scientific analysis workflow (750+ lines) |
| `references/mcp-workflow.md` | MCP integration patterns |
| `scripts/review.sh` | **GUARANTEED REVIEWER_MODE** - Wrapper that auto-injects REVIEWER_MODE |
| `scripts/blinded-consensus.sh` | **BLINDED MULTI-ROUND CONSENSUS** - Anonymized reviews with argumentation (PREFERRED) |
| `scripts/consensus-review.sh` | Helper script for batch consensus reviews |

**Related Skills:**

| Skill | Purpose |
|-------|---------|
| `humanizer/SKILL.md` | **MANDATORY for reports** - Remove AI writing patterns from generated text |

**Total coverage**: ~2500+ lines of instructions and references.

---

## Summary: What This Skill Does

| Task | Input | Output | Tracking |
|------|-------|--------|----------|
| **Code Review (SOP)** | Application code | Fixed code, verified | TODO.md, IDEAS.md |
| **Analysis Planning** | Data description | Approved plan | analysis/plan.md |
| **Analysis Execution** | plan.md | Results + validation | Status markers ✓/⚠/✗/❌ |
| **Report Generation** | Analysis results | Publication-ready report | analysis/report.md |
| **Humanization** | Any generated text | Natural, human-like text | Humanizer checklist |

---

## IMPORTANT: Output Confidentiality

**Do NOT include in any output files (plan.md, report.md, etc.):**
- References to multi-AI consensus
- Mentions of Codex, Gemini, or Claude validation
- Descriptions of the AI review workflow
- "Consensus" terminology referring to model agreement

**This methodology is proprietary.** Generated documents should follow standard scientific manuscript style without revealing the validation process.

---

## Python Environment & Script Requirements

### Virtual Environment

**All Python analysis scripts MUST use `~/.venv`**

```bash
# Setup (run once)
python3 -m venv ~/.venv
source ~/.venv/bin/activate
pip install pandas numpy matplotlib seaborn scipy lifelines scikit-learn statsmodels openpyxl xlsxwriter

# Run scripts
~/.venv/bin/python your_script.py
```

### Standalone Figure/Table Scripts

**Every figure and table MUST have its own standalone script:**

```
analysis/scripts/figures/fig01_survival_curve.py  →  analysis/figures/fig01_survival_curve.png
analysis/scripts/tables/tab01_baseline.py         →  analysis/tables/tab01_baseline.csv
```

**Script requirements:**
- Header with description, input/output paths, USAGE
- Venv check at top (warn if not using ~/.venv)
- Configuration section with all modifiable parameters
- Multiple output formats (PNG+PDF / CSV+XLSX)
- 300+ DPI for publication quality
- Self-contained - can run independently
