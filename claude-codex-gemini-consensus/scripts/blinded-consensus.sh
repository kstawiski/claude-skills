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
CODEX_MODEL="${CODEX_MODEL:-gpt-5.3-codex}"
CODEX_REASONING_EFFORT="${CODEX_REASONING_EFFORT:-xhigh}" # allowed: high|xhigh
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}" # Opus 4.6 alias on current Claude CLI
GEMINI_MODEL="${GEMINI_MODEL:-gemini-3-pro-preview}"
REVIEW_TIMEOUT_SEC="${REVIEW_TIMEOUT_SEC:-1800}"
MAX_INPUT_BYTES="${MAX_INPUT_BYTES:-200000}"
KEEP_CONSENSUS_DIR="${KEEP_CONSENSUS_DIR:-0}"

if ! [[ "$REVIEW_TIMEOUT_SEC" =~ ^[0-9]+$ ]] || [[ "$REVIEW_TIMEOUT_SEC" -lt 1 ]]; then
    echo "Warning: REVIEW_TIMEOUT_SEC must be a positive integer. Falling back to 1800." >&2
    REVIEW_TIMEOUT_SEC=1800
fi
if ! [[ "$MAX_INPUT_BYTES" =~ ^[0-9]+$ ]] || [[ "$MAX_INPUT_BYTES" -lt 1024 ]]; then
    echo "Warning: MAX_INPUT_BYTES must be >= 1024. Falling back to 200000." >&2
    MAX_INPUT_BYTES=200000
fi
if ! [[ "$KEEP_CONSENSUS_DIR" =~ ^[01]$ ]]; then
    echo "Warning: KEEP_CONSENSUS_DIR must be 0 or 1. Falling back to 0." >&2
    KEEP_CONSENSUS_DIR=0
fi

case "$CODEX_REASONING_EFFORT" in
    high|xhigh) ;;
    *)
        echo "Warning: CODEX_REASONING_EFFORT must be high or xhigh. Falling back to xhigh." >&2
        CODEX_REASONING_EFFORT="xhigh"
        ;;
esac

TIMEOUT_BIN=""
if command -v timeout >/dev/null 2>&1; then
    TIMEOUT_BIN="timeout"
elif command -v gtimeout >/dev/null 2>&1; then
    TIMEOUT_BIN="gtimeout"
fi
PERL_BIN=""
if command -v perl >/dev/null 2>&1; then
    PERL_BIN="perl"
fi
NO_TIMEOUT_WARNING_EMITTED=0

run_with_timeout() {
    if [[ -n "$TIMEOUT_BIN" ]]; then
        "$TIMEOUT_BIN" "$REVIEW_TIMEOUT_SEC" "$@"
        return $?
    fi
    if [[ -n "$PERL_BIN" ]]; then
        "$PERL_BIN" -e '
my $t = shift @ARGV;
my $pid = fork();
die "fork failed: $!" unless defined $pid;
if ($pid == 0) { exec @ARGV or die "exec failed: $!"; }
my $timed_out = 0;
local $SIG{ALRM} = sub {
  $timed_out = 1;
  kill "TERM", $pid;
  sleep 1;
  kill "KILL", $pid;
};
alarm $t;
waitpid($pid, 0);
alarm 0;
if ($timed_out) { exit 124; }
if ($? == -1) { exit 1; }
if ($? & 127) { exit 128 + ($? & 127); }
exit($? >> 8);
' "$REVIEW_TIMEOUT_SEC" "$@"
        return $?
    fi
    if [[ "$NO_TIMEOUT_WARNING_EMITTED" -eq 0 ]]; then
        echo "Warning: no timeout utility found (timeout/gtimeout/perl). Running without timeout." >&2
        NO_TIMEOUT_WARNING_EMITTED=1
    fi
    "$@"
}

# Check if CONSENSUS_DIR was set externally
if [[ -n "${CONSENSUS_DIR:-}" ]]; then
    CONSENSUS_DIR_EXTERNAL=1
else
    if CONSENSUS_DIR="$(mktemp -d 2>/dev/null)"; then
        :
    else
        # macOS/BSD fallback.
        CONSENSUS_DIR="$(mktemp -d -t consensus)"
    fi
    CONSENSUS_DIR_EXTERNAL=""
fi
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Cleanup trap - only remove if we created it
cleanup() {
    if [[ "$KEEP_CONSENSUS_DIR" -eq 1 ]]; then
        return
    fi
    if [[ -z "$CONSENSUS_DIR_EXTERNAL" ]] && [[ -d "$CONSENSUS_DIR" ]]; then
        echo "Cleaning up temporary directory: $CONSENSUS_DIR" >&2
        rm -rf "$CONSENSUS_DIR"
    fi
}
trap cleanup EXIT INT TERM

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

Environment overrides:
  REVIEW_TIMEOUT_SEC   Per-agent timeout in seconds (default: 1800)
  MAX_INPUT_BYTES      Max bytes loaded from input file/text (default: 200000)
  KEEP_CONSENSUS_DIR   Keep temp discussion dir after exit: 0|1 (default: 0)

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
            if [[ $# -lt 2 ]]; then
                echo "Error: --rounds requires a positive integer." >&2
                exit 1
            fi
            MAX_ROUNDS="$2"
            shift 2
            ;;
        --search)
            SEARCH_FLAG="--search"
            shift
            ;;
        --output)
            if [[ $# -lt 2 ]]; then
                echo "Error: --output requires a file path." >&2
                exit 1
            fi
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --cd)
            if [[ $# -lt 2 ]]; then
                echo "Error: --cd requires a directory path." >&2
                exit 1
            fi
            CD_PATH="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            ;;
    esac
done

if ! [[ "$MAX_ROUNDS" =~ ^[0-9]+$ ]] || [[ "$MAX_ROUNDS" -lt 1 ]]; then
    echo "Error: --rounds must be a positive integer." >&2
    exit 1
fi
if [[ ! -d "$CD_PATH" ]]; then
    echo "Error: --cd path does not exist or is not a directory: $CD_PATH" >&2
    exit 1
fi

# Validate mode
case "$MODE" in
    plan|code|analysis|report) ;;
    *)
        echo "Error: Unknown mode '$MODE'"
        usage
        ;;
esac

# Read input content (bounded)
read_input_content() {
    local src="$1"
    if [[ -f "$src" ]]; then
        local size
        size="$(wc -c < "$src" | tr -d '[:space:]')"
        if [[ "$size" -gt "$MAX_INPUT_BYTES" ]]; then
            head -c "$MAX_INPUT_BYTES" -- "$src"
            printf '\n\n[TRUNCATED: original file size %s bytes exceeded MAX_INPUT_BYTES=%s]\n' "$size" "$MAX_INPUT_BYTES"
        else
            cat -- "$src"
        fi
    else
        local LC_ALL=C
        local text_len
        text_len="${#src}"
        if [[ "$text_len" -gt "$MAX_INPUT_BYTES" ]]; then
            printf '%s' "${src:0:$MAX_INPUT_BYTES}"
        else
            printf '%s' "$src"
        fi
        if [[ "$text_len" -gt "$MAX_INPUT_BYTES" ]]; then
            printf '\n\n[TRUNCATED: input text length %s bytes exceeded MAX_INPUT_BYTES=%s]\n' "$text_len" "$MAX_INPUT_BYTES"
        fi
    fi
}

CONTENT="$(read_input_content "$INPUT")"
if [[ -f "$INPUT" ]]; then
    echo "Reading from file: $INPUT"
    INPUT_DESCRIPTOR="$INPUT"
else
    INPUT_BYTES="$(printf '%s' "$INPUT" | wc -c | tr -d '[:space:]')"
    INPUT_DESCRIPTOR="[inline text: ${INPUT_BYTES} bytes]"
    echo "Using provided text: $INPUT_DESCRIPTOR"
fi

# =============================================================================
# Setup
# =============================================================================

# Only create directory if it was provided externally (mktemp already created it)
[[ -n "$CONSENSUS_DIR_EXTERNAL" ]] && mkdir -p "$CONSENSUS_DIR"

# Randomize agent-to-label mapping (blinding)
AGENTS=("codex" "gemini" "claude")
LABELS=("A" "B" "C")

# Fisher-Yates shuffle for labels
random_index() {
    local max="$1"
    local range
    local limit
    local raw
    range=32768
    if od -An -N2 -tu2 /dev/urandom >/dev/null 2>&1; then
        range=65536
    fi
    limit=$((range - (range % (max + 1))))
    while :; do
        if raw="$(od -An -N2 -tu2 /dev/urandom 2>/dev/null | tr -d '[:space:]')"; then
            :
        else
            raw="$RANDOM"
        fi
        if [[ "$raw" -lt "$limit" ]]; then
            echo $((raw % (max + 1)))
            return 0
        fi
    done
}
for ((i=${#LABELS[@]}-1; i>0; i--)); do
    j="$(random_index "$i")"
    tmp="${LABELS[$i]}"
    LABELS[$i]="${LABELS[$j]}"
    LABELS[$j]="$tmp"
done

# bash3-compatible mapping helpers (no associative arrays)
CODEX_LABEL="${LABELS[0]}"
GEMINI_LABEL="${LABELS[1]}"
CLAUDE_LABEL="${LABELS[2]}"

label_for_agent() {
    case "$1" in
        codex) echo "$CODEX_LABEL" ;;
        gemini) echo "$GEMINI_LABEL" ;;
        claude) echo "$CLAUDE_LABEL" ;;
        *) echo "?" ;;
    esac
}

REVIEWER_A_AGENT=""
REVIEWER_B_AGENT=""
REVIEWER_C_AGENT=""
for agent in "${AGENTS[@]}"; do
    label="$(label_for_agent "$agent")"
    case "$label" in
        A) REVIEWER_A_AGENT="$agent" ;;
        B) REVIEWER_B_AGENT="$agent" ;;
        C) REVIEWER_C_AGENT="$agent" ;;
    esac
done

# Save mapping for orchestrator reference only
cat > "$CONSENSUS_DIR/mapping.secret" <<EOF
# BLINDING MAP - DO NOT SHARE WITH AGENTS
# Generated: $TIMESTAMP
# Reviewer A = ${REVIEWER_A_AGENT}
# Reviewer B = ${REVIEWER_B_AGENT}
# Reviewer C = ${REVIEWER_C_AGENT}
EOF
if ! chmod 600 "$CONSENSUS_DIR/mapping.secret" 2>/dev/null; then
    echo "Warning: Could not chmod 600 $CONSENSUS_DIR/mapping.secret" >&2
fi

echo ""
echo "================================================================"
echo "  BLINDED CONSENSUS - Mode: $MODE | Max rounds: $MAX_ROUNDS"
echo "================================================================"
echo ""
echo "Agents assigned anonymous labels (A/B/C) - mapping is secret."
echo ""

# Strict requirement: all three reviewer CLIs must be available.
MISSING_CLIS=()
for cli in codex gemini claude; do
    if ! command -v "$cli" >/dev/null 2>&1; then
        MISSING_CLIS+=("$cli")
    fi
done
if [[ "${#MISSING_CLIS[@]}" -gt 0 ]]; then
    echo "Error: blinded consensus requires all reviewer CLIs. Missing: ${MISSING_CLIS[*]}" >&2
    exit 127
fi

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

VERDICT: [APPROVE|REJECT|CONDITIONAL] (choose exactly one)

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

VERDICT: [APPROVE|REJECT|CONDITIONAL] (choose exactly one)

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

VERDICT: [VALID|INVALID|NEEDS REVISION] (choose exactly one)

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

VERDICT: [PUBLISHABLE|MAJOR REVISION|MINOR REVISION] (choose exactly one)

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
    local label
    label="$(label_for_agent "$agent")"

    local reviewer_header="REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.
You are Reviewer $label in a blinded consensus process. Do not reveal your identity.

"
    local full_prompt="${reviewer_header}${prompt}"

    case "$agent" in
        codex)
            if ! command -v codex >/dev/null 2>&1; then
                echo "Error: codex CLI not found for Reviewer $label." >&2
                return 127
            fi
            local args=(exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check)
            args+=(-m "$CODEX_MODEL")
            args+=(-c "model_reasoning_effort=\"$CODEX_REASONING_EFFORT\"")
            [[ -n "$SEARCH_FLAG" ]] && args+=(--search)
            args+=(--cd "$CD_PATH")
            args+=("$full_prompt")
            if ! run_with_timeout codex "${args[@]}"; then
                echo "Error: Reviewer $label (codex) failed or timed out." >&2
                return 1
            fi
            ;;
        gemini)
            if ! command -v gemini >/dev/null 2>&1; then
                echo "Error: gemini CLI not found for Reviewer $label." >&2
                return 127
            fi
            local args=(gemini --yolo --model "$GEMINI_MODEL" -p "$full_prompt")
            if [[ -n "$CD_PATH" ]]; then
                if ! (cd "$CD_PATH" && run_with_timeout "${args[@]}"); then
                    echo "Error: Reviewer $label (gemini) failed or timed out." >&2
                    return 1
                fi
            else
                if ! run_with_timeout "${args[@]}"; then
                    echo "Error: Reviewer $label (gemini) failed or timed out." >&2
                    return 1
                fi
            fi
            ;;
        claude)
            if ! command -v claude >/dev/null 2>&1; then
                echo "Error: claude CLI not found for Reviewer $label." >&2
                return 127
            fi
            local args=(claude --dangerously-skip-permissions --model "$CLAUDE_MODEL" -p "$full_prompt")
            if [[ -n "$CD_PATH" ]]; then
                if ! (cd "$CD_PATH" && run_with_timeout "${args[@]}"); then
                    echo "Error: Reviewer $label (claude) failed or timed out." >&2
                    return 1
                fi
            else
                if ! run_with_timeout "${args[@]}"; then
                    echo "Error: Reviewer $label (claude) failed or timed out." >&2
                    return 1
                fi
            fi
            ;;
    esac
}

anonymize_review() {
    # Strip any accidental self-identification from reviews
    local review="$1"
    if [[ -n "$PERL_BIN" ]]; then
        printf '%s\n' "$review" | "$PERL_BIN" -pe '
          s/\b[Aa]s (Claude|Codex|Gemini|GPT|OpenAI|Google|Anthropic)\b/As a reviewer/g;
          s/\bI am (Claude|Codex|Gemini|GPT-[0-9.]+|an AI)\b/I am a reviewer/g;
          s/\b(Claude|Codex|Gemini) (here|speaking|reviewing)\b/Reviewer reviewing/g;
        '
        return 0
    fi
    printf '%s\n' "$review" | sed -E \
      -e 's/[Aa]s ([Cc]laude|[Cc]odex|[Gg]emini|GPT|OpenAI|Google|Anthropic)/As a reviewer/g' \
      -e 's/[Ii] am ([Cc]laude|[Cc]odex|[Gg]emini|GPT-[0-9.]+|an AI)/I am a reviewer/g' \
      -e 's/([Cc]laude|[Cc]odex|[Gg]emini) (here|speaking|reviewing)/Reviewer reviewing/g'
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
    label="$(label_for_agent "$agent")"
    echo "--- Collecting review from Reviewer $label ---"

    if ! raw_review="$(invoke_agent "$agent" "$REVIEW_PROMPT" 2>&1)"; then
        echo "Error: failed to collect round 1 review from Reviewer $label." >&2
        exit 1
    fi
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
    local round
    local approvals=0
    local rejections=0
    local verdict_line
    local verdict_lines
    local verdict_value
    local verdict_class
    local reviewer_file

    if [[ "$reviews_file" =~ round([0-9]+)_compiled\.txt$ ]]; then
        round="${BASH_REMATCH[1]}"
    else
        echo "UNCLEAR"
        return 0
    fi

    for label in A B C; do
        reviewer_file="$CONSENSUS_DIR/round${round}_reviewer_${label}.txt"
        if [[ ! -f "$reviewer_file" ]]; then
            continue
        fi

        verdict_lines="$(grep -Ei 'VERDICT[[:space:]]*:' "$reviewer_file" || true)"
        if [[ -z "$verdict_lines" ]]; then
            continue
        fi

        verdict_class="UNCLEAR"
        while IFS= read -r verdict_line; do
            [[ -z "$verdict_line" ]] && continue
            verdict_value="$(printf '%s\n' "$verdict_line" | sed -E 's/^[^:]*:[[:space:]]*//; s/[[:space:]]+$//' | tr '[:lower:]' '[:upper:]' | sed -E 's/[*_`]+//g; s/[[:space:]]+/ /g')"
            case "$verdict_value" in
                *"/"*|*"|"*|*" OR "*|*"["*|*"]"*|*"ONE OF "*)
                    continue
                    ;;
                APPROVE*|APPROVED*|VALID*|PUBLISHABLE*|PASS*)
                    verdict_class="APPROVE"
                    break
                    ;;
                REJECT*|REJECTED*|INVALID*|MAJOR\ REVISION*|MINOR\ REVISION*|NEEDS\ CHANGE*|NEEDS\ CHANGES*|NEEDS\ REVISION*|CONDITIONAL*|CONDITIONALLY*|FAIL*|FAILED*|NOT\ APPROVED*)
                    verdict_class="REJECT"
                    break
                    ;;
            esac
        done <<< "$verdict_lines"

        case "$verdict_class" in
            APPROVE)
                approvals=$((approvals + 1))
                ;;
            REJECT)
                rejections=$((rejections + 1))
                ;;
        esac
    done

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
        label="$(label_for_agent "$agent")"
        echo "--- Reviewer $label responding to discussion ---"

        discussion_prompt=$(build_discussion_prompt "$NEXT_ROUND" "$label" "$CURRENT_REVIEWS" "$CONTENT" "$MODE")
        if ! raw_response="$(invoke_agent "$agent" "$discussion_prompt" 2>&1)"; then
            echo "Error: failed to collect discussion response from Reviewer $label (round $NEXT_ROUND)." >&2
            exit 1
        fi
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
echo "Input:          $INPUT_DESCRIPTOR"
echo "Rounds:         $CURRENT_ROUND / $MAX_ROUNDS"
echo "Final Status:   $FINAL_STATUS"
echo "Timestamp:      $TIMESTAMP"
echo ""

# Compile full discussion trail
FULL_REPORT="# Blinded Consensus Report

## Summary
- **Mode**: $MODE
- **Input**: $INPUT_DESCRIPTOR
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

case "$FINAL_STATUS" in
    CONSENSUS_APPROVE) FINAL_NOTE="All three reviewers independently approved. Consensus is strong." ;;
    CONSENSUS_REJECT)  FINAL_NOTE="All three reviewers independently rejected. Revision required." ;;
    MAJORITY_APPROVE)  FINAL_NOTE="Majority (2/3) approved. Review minority objections before proceeding." ;;
    MAJORITY_REJECT)   FINAL_NOTE="Majority (2/3) rejected. Address identified issues before re-review." ;;
    NO_CONSENSUS)      FINAL_NOTE="No consensus reached after $CURRENT_ROUND rounds. Escalate to human judgment." ;;
    UNCLEAR)           FINAL_NOTE="Verdicts could not be parsed. Manual review of discussion required." ;;
    *)                 FINAL_NOTE="Consensus outcome not recognized. Review output manually." ;;
esac

ARCHIVE_NOTE="Discussion directory is temporary and will be removed on exit."
if [[ "$KEEP_CONSENSUS_DIR" -eq 1 ]] || [[ -n "$CONSENSUS_DIR_EXTERNAL" ]]; then
    ARCHIVE_NOTE="Discussion directory kept at: $CONSENSUS_DIR/"
fi

FULL_REPORT+="
## Consensus Status

**$FINAL_STATUS**

$FINAL_NOTE

---
*Blinding key stored in: $CONSENSUS_DIR/mapping.secret*
*$ARCHIVE_NOTE*
"

echo "$FULL_REPORT"

# Write to output file if specified
if [[ -n "$OUTPUT_FILE" ]]; then
    echo "$FULL_REPORT" > "$OUTPUT_FILE"
    echo ""
    echo "Report written to: $OUTPUT_FILE"
fi

echo ""
if [[ "$KEEP_CONSENSUS_DIR" -eq 1 ]] || [[ -n "$CONSENSUS_DIR_EXTERNAL" ]]; then
    echo "Discussion archive: $CONSENSUS_DIR/"
else
    echo "Discussion archive: temporary directory (auto-cleanup enabled)."
fi
echo "================================================================"
