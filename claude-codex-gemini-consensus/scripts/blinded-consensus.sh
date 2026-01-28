#!/usr/bin/env bash
# =============================================================================
# Blinded Multi-Round Consensus Script
# =============================================================================
# Implements proper blinded consensus where:
# 1. Each agent reviews independently (Round 1)
# 2. Reviews are anonymized (Reviewer A/B/C - shuffled each run)
# 3. Anonymized reviews are shared with all agents for discussion (Round 2+)
# 4. Agents argue points with reasoning until consensus or max rounds
#
# Usage:
#   ./blinded-consensus.sh <plan|code|analysis|report> <file_or_text> [--rounds N] [--search]
#
# Output: Combined consensus report with anonymized discussion trail
# =============================================================================

set -euo pipefail

# Configuration
MAX_ROUNDS="${MAX_ROUNDS:-3}"
CONSENSUS_DIR="${CONSENSUS_DIR:-/tmp/consensus-$$}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

usage() {
    cat <<'USAGE'
Usage: blinded-consensus.sh <mode> <file_or_text> [options]

Modes:
  plan       - Review an implementation/analysis plan
  code       - Review code for bugs, security, performance
  analysis   - Validate statistical/scientific analysis
  report     - Review publication-ready report

Options:
  --rounds N     Maximum discussion rounds (default: 3)
  --search       Enable web search for reviewers
  --output FILE  Write consensus report to file
  --cd PATH      Working directory for agents

Examples:
  ./blinded-consensus.sh plan analysis/plan.md
  ./blinded-consensus.sh code src/pipeline.py --rounds 4
  ./blinded-consensus.sh analysis results/ --search
  ./blinded-consensus.sh report analysis/report.md --output consensus_report.md
USAGE
    exit 1
}

# =============================================================================
# Argument Parsing
# =============================================================================

if [[ $# -lt 2 ]]; then
    usage
fi

MODE="$1"
INPUT="$2"
shift 2

SEARCH_FLAG=""
OUTPUT_FILE=""
CD_PATH="$(pwd)"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --rounds)
            MAX_ROUNDS="$2"
            shift 2
            ;;
        --search)
            SEARCH_FLAG="--search"
            shift
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --cd)
            CD_PATH="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate mode
case "$MODE" in
    plan|code|analysis|report) ;;
    *)
        echo "Error: Unknown mode '$MODE'"
        usage
        ;;
esac

# Read input content
if [[ -f "$INPUT" ]]; then
    CONTENT=$(cat "$INPUT")
    echo "Reading from file: $INPUT"
else
    CONTENT="$INPUT"
    echo "Using provided text"
fi

# =============================================================================
# Setup
# =============================================================================

mkdir -p "$CONSENSUS_DIR"

# Randomize agent-to-label mapping (blinding)
AGENTS=("codex" "gemini" "claude")
LABELS=("A" "B" "C")

# Fisher-Yates shuffle for labels
for ((i=${#LABELS[@]}-1; i>0; i--)); do
    j=$((RANDOM % (i+1)))
    tmp="${LABELS[$i]}"
    LABELS[$i]="${LABELS[$j]}"
    LABELS[$j]="$tmp"
done

# Create mapping (kept secret from agents)
declare -A AGENT_TO_LABEL
declare -A LABEL_TO_AGENT
for i in "${!AGENTS[@]}"; do
    AGENT_TO_LABEL["${AGENTS[$i]}"]="${LABELS[$i]}"
    LABEL_TO_AGENT["${LABELS[$i]}"]="${AGENTS[$i]}"
done

# Save mapping for orchestrator reference only
cat > "$CONSENSUS_DIR/mapping.secret" <<EOF
# BLINDING MAP - DO NOT SHARE WITH AGENTS
# Generated: $TIMESTAMP
# Reviewer A = ${LABEL_TO_AGENT[A]}
# Reviewer B = ${LABEL_TO_AGENT[B]}
# Reviewer C = ${LABEL_TO_AGENT[C]}
EOF

echo ""
echo "================================================================"
echo "  BLINDED CONSENSUS - Mode: $MODE | Max rounds: $MAX_ROUNDS"
echo "================================================================"
echo ""
echo "Agents assigned anonymous labels (A/B/C) - mapping is secret."
echo ""

# =============================================================================
# Mode-specific prompt templates
# =============================================================================

build_review_prompt() {
    local mode="$1"
    local content="$2"

    case "$mode" in
        plan)
            cat <<PROMPT
Review this implementation/analysis plan with rigorous critical evaluation.

REQUIRED ASSESSMENT:
1. Scientific/technical soundness - are methods appropriate?
2. Completeness - any missing steps or analyses?
3. Feasibility - can this be executed with available data/tools?
4. Statistical validity - correct tests, power, assumptions?
5. Edge cases and failure modes
6. Logical flow and dependencies between steps

IMPORTANT: Provide specific, reasoned arguments for every point. Do not give vague approval.
If you approve, explain WHY each aspect is sound. If you reject, explain the specific flaw and propose a fix.

OUTPUT FORMAT:
ASSESSMENT:
- [Point 1]: [Your reasoned argument]
- [Point 2]: [Your reasoned argument]
...

ISSUES (if any):
- [Issue]: [Why it matters] -> [Proposed fix]

VERDICT: APPROVE / REJECT / CONDITIONAL (explain conditions)

REASONING: [2-3 sentence summary of your overall assessment logic]

---
Plan to review:
$content
PROMPT
            ;;
        code)
            cat <<PROMPT
Review this code with rigorous critical evaluation for a research/clinical application.

REQUIRED ASSESSMENT:
1. Correctness - does the logic match the stated intent?
2. Edge cases - unhandled inputs, boundary conditions?
3. Security - injection, data leaks, auth issues?
4. Performance - bottlenecks, memory issues, scalability?
5. Error handling - failure modes, graceful degradation?
6. Reproducibility - deterministic results, seed handling?

IMPORTANT: Provide specific, reasoned arguments. Reference exact lines/functions.
For each issue found, explain the concrete failure scenario.

OUTPUT FORMAT:
ASSESSMENT:
- [Aspect]: [Your reasoned argument with code references]
...

BUGS/ISSUES (if any):
- [Location]: [What goes wrong] -> [Fix]

VERDICT: APPROVE / REJECT / CONDITIONAL

REASONING: [2-3 sentence summary]

---
Code to review:
$content
PROMPT
            ;;
        analysis)
            cat <<PROMPT
Validate this statistical/scientific analysis with rigorous critical evaluation.

REQUIRED ASSESSMENT:
1. Statistical validity - correct tests for data type and question?
2. Assumptions - are test assumptions met (normality, independence, etc.)?
3. Multiple comparisons - proper correction applied?
4. Effect sizes - reported alongside p-values?
5. Missing analyses - anything in the plan not addressed?
6. Interpretation - do conclusions follow from results?
7. Reproducibility - can results be independently verified?

IMPORTANT: Provide specific numerical/statistical arguments.
Challenge every conclusion - is there an alternative explanation?

OUTPUT FORMAT:
ASSESSMENT:
- [Statistical point]: [Your reasoned argument]
...

ERRORS/CONCERNS:
- [Analysis]: [Statistical issue] -> [Correct approach]

COMPLETENESS: [What's missing vs. plan]

VERDICT: VALID / INVALID / NEEDS REVISION

REASONING: [2-3 sentence summary]

---
Analysis to validate:
$content
PROMPT
            ;;
        report)
            cat <<PROMPT
Review this publication-ready report with rigorous critical evaluation.

REQUIRED ASSESSMENT:
1. Methods - sufficient detail for reproduction?
2. Results - do figures/tables support claims?
3. Statistics - correctly reported (test, df, p, CI, effect size)?
4. Discussion - balanced interpretation? Limitations acknowledged?
5. Clinical/practical significance - meaningful beyond statistical?
6. Internal consistency - do numbers match across sections?
7. Citations - appropriate and sufficient?

IMPORTANT: Be specific. Quote exact passages that need revision.
Challenge interpretive leaps and unsupported conclusions.

OUTPUT FORMAT:
ASSESSMENT:
- [Section/aspect]: [Your reasoned argument]
...

REVISIONS NEEDED:
- [Location]: [Issue] -> [Suggested revision]

VERDICT: PUBLISHABLE / MAJOR REVISION / MINOR REVISION

REASONING: [2-3 sentence summary]

---
Report to review:
$content
PROMPT
            ;;
    esac
}

build_discussion_prompt() {
    local round="$1"
    local own_label="$2"
    local all_reviews="$3"
    local original_content="$4"
    local mode="$5"

    cat <<PROMPT
BLINDED CONSENSUS DISCUSSION - Round $round

You are Reviewer $own_label in an anonymous peer review. You do not know who the other reviewers are.
Below are the anonymized reviews from Round $((round-1)). Your task:

1. READ all reviews carefully
2. IDENTIFY points of agreement and disagreement
3. ARGUE your position on disputed points with specific reasoning
4. ACKNOWLEDGE valid points from other reviewers (change your mind if convinced)
5. STATE your updated position clearly

RULES:
- Support every claim with evidence or logical argument
- If you change your position, explain what convinced you
- If you maintain a disputed position, provide stronger arguments
- Focus on substance, not on who said what
- Seek genuine consensus through reasoned debate, not compromise

---
PREVIOUS REVIEWS:
$all_reviews
---

ORIGINAL $mode UNDER REVIEW:
$original_content
---

YOUR RESPONSE AS REVIEWER $own_label:

POINTS OF AGREEMENT:
- [Point]: [Why you agree]

POINTS OF DISAGREEMENT:
- [Disputed point]: [Your argument with evidence]

CHANGED POSITIONS (if any):
- [What changed]: [What convinced you]

UPDATED VERDICT: [Your current verdict with reasoning]

CONSENSUS ASSESSMENT: [Do you believe consensus has been reached? What remains unresolved?]
PROMPT
}

# =============================================================================
# Agent invocation functions
# =============================================================================

invoke_agent() {
    local agent="$1"
    local prompt="$2"
    local label="${AGENT_TO_LABEL[$agent]}"

    local reviewer_header="REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.
You are Reviewer $label in a blinded consensus process. Do not reveal your identity.

"
    local full_prompt="${reviewer_header}${prompt}"

    case "$agent" in
        codex)
            local cmd="codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check"
            [[ -n "$SEARCH_FLAG" ]] && cmd="$cmd --search"
            cmd="$cmd --cd \"$CD_PATH\""
            eval "$cmd \"\$full_prompt\"" 2>/dev/null || echo "[Reviewer $label review unavailable - agent error]"
            ;;
        gemini)
            eval "gemini --yolo -p \"\$full_prompt\"" 2>/dev/null || echo "[Reviewer $label review unavailable - agent error]"
            ;;
        claude)
            eval "claude --dangerously-skip-permissions -p \"\$full_prompt\"" 2>/dev/null || echo "[Reviewer $label review unavailable - agent error]"
            ;;
    esac
}

anonymize_review() {
    # Strip any accidental self-identification from reviews
    local review="$1"
    echo "$review" \
        | sed -E 's/\b[Aa]s (Claude|Codex|Gemini|GPT|OpenAI|Google|Anthropic)\b/As a reviewer/g' \
        | sed -E 's/\bI am (Claude|Codex|Gemini|GPT-[0-9.]+|an AI)\b/I am a reviewer/g' \
        | sed -E 's/\b(Claude|Codex|Gemini) (here|speaking|reviewing)\b/Reviewer reviewing/g'
}

# =============================================================================
# Round 1: Independent Blinded Reviews
# =============================================================================

echo "================================================================"
echo "  ROUND 1: Independent Reviews (Blinded)"
echo "================================================================"
echo ""

REVIEW_PROMPT=$(build_review_prompt "$MODE" "$CONTENT")

for agent in "${AGENTS[@]}"; do
    label="${AGENT_TO_LABEL[$agent]}"
    echo "--- Collecting review from Reviewer $label ---"

    raw_review=$(invoke_agent "$agent" "$REVIEW_PROMPT")
    clean_review=$(anonymize_review "$raw_review")

    echo "$clean_review" > "$CONSENSUS_DIR/round1_reviewer_${label}.txt"
    echo "    Reviewer $label review collected ($(echo "$clean_review" | wc -l) lines)"
    echo ""
done

# Compile all Round 1 reviews
ROUND1_REVIEWS=""
for label in A B C; do
    if [[ -f "$CONSENSUS_DIR/round1_reviewer_${label}.txt" ]]; then
        review_content=$(cat "$CONSENSUS_DIR/round1_reviewer_${label}.txt")
        ROUND1_REVIEWS+="
=== REVIEWER ${label} ===
${review_content}

"
    fi
done

echo "$ROUND1_REVIEWS" > "$CONSENSUS_DIR/round1_compiled.txt"

# =============================================================================
# Check for immediate consensus
# =============================================================================

check_consensus() {
    local reviews_file="$1"
    # Simple heuristic: check if all verdicts align
    local approvals=$(grep -ciE '(VERDICT:.*APPROV|VERDICT:.*VALID|VERDICT:.*PUBLISHABLE|VERDICT:.*MINOR)' "$reviews_file" 2>/dev/null || echo 0)
    local rejections=$(grep -ciE '(VERDICT:.*REJECT|VERDICT:.*INVALID|VERDICT:.*MAJOR|VERDICT:.*NEEDS)' "$reviews_file" 2>/dev/null || echo 0)
    local total=$((approvals + rejections))

    if [[ "$total" -eq 0 ]]; then
        echo "UNCLEAR"
    elif [[ "$approvals" -ge 3 ]]; then
        echo "CONSENSUS_APPROVE"
    elif [[ "$rejections" -ge 3 ]]; then
        echo "CONSENSUS_REJECT"
    elif [[ "$approvals" -ge 2 ]]; then
        echo "MAJORITY_APPROVE"
    elif [[ "$rejections" -ge 2 ]]; then
        echo "MAJORITY_REJECT"
    else
        echo "NO_CONSENSUS"
    fi
}

round1_status=$(check_consensus "$CONSENSUS_DIR/round1_compiled.txt")
echo ""
echo "Round 1 status: $round1_status"

# =============================================================================
# Rounds 2+: Discussion (if no unanimous consensus)
# =============================================================================

CURRENT_ROUND=1
CURRENT_REVIEWS="$ROUND1_REVIEWS"

while [[ "$CURRENT_ROUND" -lt "$MAX_ROUNDS" ]]; do
    # Check if we have unanimous consensus
    status=$(check_consensus "$CONSENSUS_DIR/round${CURRENT_ROUND}_compiled.txt")

    if [[ "$status" == "CONSENSUS_APPROVE" ]] || [[ "$status" == "CONSENSUS_REJECT" ]]; then
        echo ""
        echo "Unanimous consensus reached after Round $CURRENT_ROUND: $status"
        break
    fi

    NEXT_ROUND=$((CURRENT_ROUND + 1))

    echo ""
    echo "================================================================"
    echo "  ROUND $NEXT_ROUND: Discussion & Argumentation (Blinded)"
    echo "================================================================"
    echo ""
    echo "Disagreements detected. Sharing anonymized reviews for discussion."
    echo ""

    NEXT_REVIEWS=""

    for agent in "${AGENTS[@]}"; do
        label="${AGENT_TO_LABEL[$agent]}"
        echo "--- Reviewer $label responding to discussion ---"

        discussion_prompt=$(build_discussion_prompt "$NEXT_ROUND" "$label" "$CURRENT_REVIEWS" "$CONTENT" "$MODE")
        raw_response=$(invoke_agent "$agent" "$discussion_prompt")
        clean_response=$(anonymize_review "$raw_response")

        echo "$clean_response" > "$CONSENSUS_DIR/round${NEXT_ROUND}_reviewer_${label}.txt"
        echo "    Reviewer $label discussion response collected"
        echo ""

        NEXT_REVIEWS+="
=== REVIEWER ${label} (Round $NEXT_ROUND) ===
${clean_response}

"
    done

    echo "$NEXT_REVIEWS" > "$CONSENSUS_DIR/round${NEXT_ROUND}_compiled.txt"
    CURRENT_REVIEWS="$NEXT_REVIEWS"
    CURRENT_ROUND=$NEXT_ROUND
done

# =============================================================================
# Final Consensus Report
# =============================================================================

FINAL_STATUS=$(check_consensus "$CONSENSUS_DIR/round${CURRENT_ROUND}_compiled.txt")

echo ""
echo "================================================================"
echo "  BLINDED CONSENSUS REPORT"
echo "================================================================"
echo ""
echo "Mode:           $MODE"
echo "Input:          $INPUT"
echo "Rounds:         $CURRENT_ROUND / $MAX_ROUNDS"
echo "Final Status:   $FINAL_STATUS"
echo "Timestamp:      $TIMESTAMP"
echo ""

# Compile full discussion trail
FULL_REPORT="# Blinded Consensus Report

## Summary
- **Mode**: $MODE
- **Input**: $INPUT
- **Rounds completed**: $CURRENT_ROUND / $MAX_ROUNDS
- **Final consensus**: $FINAL_STATUS
- **Timestamp**: $TIMESTAMP

## Discussion Trail
"

for round in $(seq 1 "$CURRENT_ROUND"); do
    FULL_REPORT+="
### Round $round
"
    for label in A B C; do
        if [[ -f "$CONSENSUS_DIR/round${round}_reviewer_${label}.txt" ]]; then
            review=$(cat "$CONSENSUS_DIR/round${round}_reviewer_${label}.txt")
            FULL_REPORT+="
#### Reviewer $label
$review
"
        fi
    done
done

FULL_REPORT+="
## Consensus Status

**$FINAL_STATUS**

$(case "$FINAL_STATUS" in
    CONSENSUS_APPROVE) echo "All three reviewers independently approved. Consensus is strong." ;;
    CONSENSUS_REJECT)  echo "All three reviewers independently rejected. Revision required." ;;
    MAJORITY_APPROVE)  echo "Majority (2/3) approved. Review minority objections before proceeding." ;;
    MAJORITY_REJECT)   echo "Majority (2/3) rejected. Address identified issues before re-review." ;;
    NO_CONSENSUS)      echo "No consensus reached after $CURRENT_ROUND rounds. Escalate to human judgment." ;;
    UNCLEAR)           echo "Verdicts could not be parsed. Manual review of discussion required." ;;
esac)

---
*Blinding key stored in: $CONSENSUS_DIR/mapping.secret*
*Full discussion archived in: $CONSENSUS_DIR/*
"

echo "$FULL_REPORT"

# Write to output file if specified
if [[ -n "$OUTPUT_FILE" ]]; then
    echo "$FULL_REPORT" > "$OUTPUT_FILE"
    echo ""
    echo "Report written to: $OUTPUT_FILE"
fi

echo ""
echo "Discussion archive: $CONSENSUS_DIR/"
echo "================================================================"
