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
  
  Triggers: "code review", "clinical review", "consensus", "Claude", "Codex", "Gemini", "statistical analysis", "publication", "scientific analysis", "review SOP"
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
| **Scientific Analysis** | "statistical analysis", "clinical research", "publication" | Full scientific workflow with completeness checks |
| **Analysis Execution** | "conduct analysis", "execute plan", "run analyses" | Implement + validate + check completeness |
| **Report Generation** | "report", "manuscript", "Methods/Results/Discussion" | Publication-ready output with citations |

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
3. [VALIDATE] Submit each result to Codex/Gemini for validation
4. [COMPLETENESS] Check: Are ALL planned analyses done? Missing? Incomplete? Wrong?
5. [CORRECT] Fix any issues, re-validate
6. [REPORT] Generate analysis/report.md (Methods, Results, Discussion)
7. [FIGURES] Create publication-ready figures with captions
8. [CITATIONS] Add and verify PubMed references
9. [FINAL] Clinical + Scientific assessment by all models
```

### What This Skill Does NOT Do Automatically

- Does NOT invoke Codex/Gemini unless you ask for consensus/review
- Does NOT start scientific workflow unless explicitly requested
- Does NOT assume clinical context unless mentioned

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

## Cross-Agent Consultation

| You are running | Consult these agents |
|-----------------|---------------------|
| **Claude** | Codex + Gemini |
| **Codex** | Claude + Gemini |
| **Gemini** | Claude + Codex |

## Quick Reference

### Claude Code CLI (Full Permissions - Concise Output)

```bash
# Standard command with concise output request
claude --dangerously-skip-permissions \
  --model claude-sonnet-4.5 \
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
  --model gpt-5.2-codex \
  --skip-git-repo-check \
  --cd "$(pwd)" \
  "BE CONCISE. Output only: findings, issues, recommendations. No preamble.

YOUR_PROMPT"

# JSON output for minimal, structured response
codex exec --dangerously-bypass-approvals-and-sandbox \
  --model gpt-5.2-codex \
  --skip-git-repo-check \
  --json \
  "YOUR_PROMPT"

# With web search
codex exec --dangerously-bypass-approvals-and-sandbox \
  --model gpt-5.2-codex \
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
  --model gemini-3-pro-preview \
  -p "BE CONCISE. Bullet points only. No preamble.

YOUR_PROMPT"

# JSON output for scripting
gemini --yolo \
  --model gemini-3-pro-preview \
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
  --model gpt-5.2-codex \
  --skip-git-repo-check \
  "STRICT FORMAT. Max 10 lines. No prose.

[TASK]

Output ONLY:
✓/✗ [check1]
✓/✗ [check2]
VERDICT: [word]"

# Pipe to head for hard truncation (if output still verbose)
codex exec --dangerously-bypass-approvals-and-sandbox \
  --model gpt-5.2-codex \
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

### Concise Output Instructions

**Always prepend to prompts:**
```
BE CONCISE. No preamble. Output format:
- ISSUES: [bullet list]
- RECOMMENDATIONS: [bullet list]  
- VERDICT: APPROVED / NEEDS CHANGES
```

### Phase 1: Planning

1. **Claude proposes** initial implementation plan
2. **Submit to Codex** for critical review:
   ```bash
   codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
     "BE CONCISE. No preamble. Review this plan. Output:
- ISSUES: [list]
- MISSING: [list]
- VERDICT: APPROVED/NEEDS CHANGES

Plan: [PASTE_PLAN]"
   ```
3. **Submit to Gemini** for independent review:
   ```bash
   gemini --yolo --model gemini-3-pro-preview \
     -p "BE CONCISE. No preamble. Review this plan. Output:
- ISSUES: [list]
- MISSING: [list]
- VERDICT: APPROVED/NEEDS CHANGES

Plan: [PASTE_PLAN]"
   ```
4. **Synthesize feedback**, argue points of disagreement, reach consensus
5. **Iterate** until all three agents agree

### Phase 2: Implementation

1. Claude implements based on consensus plan
2. Code review cycle (see below)

### Phase 3: Code Review

Submit code to both agents for critical review:

```bash
# Codex review (concise)
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Review code. Output only:
- BUGS: [list or 'None']
- SECURITY: [list or 'None']
- PERFORMANCE: [list or 'None']
- VERDICT: APPROVED/NEEDS CHANGES

Code: [PASTE_CODE]"

# Gemini review (concise)
gemini --yolo --model gemini-3-pro-preview \
  -p "BE CONCISE. Review code. Output only:
- BUGS: [list or 'None']
- SECURITY: [list or 'None']
- PERFORMANCE: [list or 'None']
- VERDICT: APPROVED/NEEDS CHANGES

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

# Pal reviews independently (concise)
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Code review. Clinical context.

Output: P0: [list] | P1: [list] | P2: [list] | P3: [list]

Code: $(cat [MODULE])"
```

**Consensus:** Compare findings. For disagreements:
```bash
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Is [ISSUE] valid? Output: Y/N | REASON"
```

#### 2. Implementation Strategy

```bash
# Validate fix plan
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Validate fix plan.

Issues: [LIST]
Fixes: [LIST]

Output per fix: CORRECT/INCORRECT | [concern]"
```

#### 3. Execution & Verification

```bash
# Verify fixes applied
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Verify fixes. No regressions?

Issues: [LIST]
Output: | Issue | Fixed | Regression |

VERDICT: ALL_FIXED / ISSUES_REMAIN

Code: $(cat [MODULE])"
```

#### 4. Completion

1. Mark `[DONE]` in TODO.md
2. Log nice-to-haves to IDEAS.md
3. **Pick next [PENDING] module - DON'T STOP**

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
8. **Final Validation** → Clinical AND scientific assessment by all models
9. **Citations** → Verify all PubMed citations (PMIDs)

**See [references/scientific-analysis-workflow.md](references/scientific-analysis-workflow.md) for complete workflow.**

### Domain-Specific Hypothesis Example (Oncology)

For oncology research, you may want to add a cancer type hypothesis step:

```bash
# Example only - adapt to your domain
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check --search \
  "BE CONCISE. Hypothesize cancer type. Output:
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
# Clinical assessment (concise)
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Clinical assessment.
OUTPUT: ACTIONABLE: Y/N | EFFECT SIZE: meaningful/marginal | GENERALIZABLE: Y/N | VERDICT: [pass/fail]
Report: [PASTE_REPORT]"

# Scientific assessment (concise)
gemini --yolo --model gemini-3-pro-preview \
  -p "BE CONCISE. Scientific assessment.
OUTPUT: METHODS: sound/flawed | CONCLUSIONS: supported/unsupported | NOVEL: Y/N | VERDICT: [pass/fail]
Report: [PASTE_REPORT]"
```

### Analysis Completeness Verification

**CRITICAL: Verify ALL planned analyses are completed correctly.**

```bash
# Check for missing/incomplete analyses (concise output)
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. Compare analysis/plan.md vs results.

OUTPUT (table only):
| # | Analysis | Status | Action |
STATUS: ✓=Done ⚠=Partial ✗=Missing ❌=Wrong"

# Gemini verification (concise)
gemini --yolo --model gemini-3-pro-preview \
  -p "BE CONCISE. Verify: analysis/plan.md vs results. Table only: | # | Analysis | Status |"
```

After verification, **conduct/correct** all flagged items, then re-validate.

### Additional Analyses Discovery

After completing planned analyses:

```bash
codex exec --dangerously-bypass-approvals-and-sandbox --model gpt-5.2-codex --skip-git-repo-check \
  "BE CONCISE. What additional analyses needed?
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


## Recommended Configurations

### Codex Config (~/.codex/config.toml)

```toml
model = "gpt-5.2-codex"
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = true
```

### Gemini Config (~/.gemini/settings.json)

```json
{
  "model": "gemini-3-pro-preview",
  "theme": "dark"
}
```

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
| `scripts/consensus-review.sh` | Helper script for batch consensus reviews |

**Total coverage**: ~2500+ lines of instructions and references.

---

## Summary: What This Skill Does

| Task | Input | Output | Tracking |
|------|-------|--------|----------|
| **Code Review (SOP)** | Application code | Fixed code, verified | TODO.md, IDEAS.md |
| **Analysis Planning** | Data description | Approved plan | analysis/plan.md |
| **Analysis Execution** | plan.md | Results + validation | Status markers ✓/⚠/✗/❌ |
| **Report Generation** | Analysis results | Publication-ready report | analysis/report.md |

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
