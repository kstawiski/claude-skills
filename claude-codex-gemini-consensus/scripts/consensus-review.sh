#!/usr/bin/env bash
# consensus-review.sh - Consensus helper for code/plan reviews
#
# Default behavior: run blinded consensus (all three models) via blinded-consensus.sh.
# Optional quick mode: single-round non-blinded checks by Codex + Gemini + Claude.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_MODEL="${CODEX_MODEL:-gpt-5.3-codex}"
CODEX_REASONING_EFFORT="${CODEX_REASONING_EFFORT:-high}" # quick mode defaults to high
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}" # Opus 4.6 alias on current Claude CLI
GEMINI_MODEL="${GEMINI_MODEL:-gemini-3-pro-preview}"
REVIEW_TIMEOUT_SEC="${REVIEW_TIMEOUT_SEC:-1800}"
MAX_INPUT_BYTES="${MAX_INPUT_BYTES:-200000}"

if ! [[ "$REVIEW_TIMEOUT_SEC" =~ ^[0-9]+$ ]] || [[ "$REVIEW_TIMEOUT_SEC" -lt 1 ]]; then
    echo "Warning: REVIEW_TIMEOUT_SEC must be a positive integer. Falling back to 1800." >&2
    REVIEW_TIMEOUT_SEC=1800
fi
if ! [[ "$MAX_INPUT_BYTES" =~ ^[0-9]+$ ]] || [[ "$MAX_INPUT_BYTES" -lt 1024 ]]; then
    echo "Warning: MAX_INPUT_BYTES must be >= 1024. Falling back to 200000." >&2
    MAX_INPUT_BYTES=200000
fi

case "$CODEX_REASONING_EFFORT" in
    high|xhigh) ;;
    *)
        echo "Warning: CODEX_REASONING_EFFORT must be high or xhigh. Falling back to high." >&2
        CODEX_REASONING_EFFORT="high"
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

usage() {
    echo "Usage: $0 <plan|code|analysis|report> <file_path_or_text> [options]"
    echo ""
    echo "Modes:"
    echo "  plan | code | analysis | report"
    echo ""
    echo "Options:"
    echo "  --quick      Run non-blinded single-round review (all 3 models)"
    echo "  --blinded    Explicitly force blinded mode (default)"
    echo "  --rounds N   Max discussion rounds in blinded mode"
    echo "  --search     Enable web search for reviewers"
    echo "  --output F   Output file for blinded report"
    echo "  --cd PATH    Working directory"
    echo ""
    echo "Environment overrides:"
    echo "  CODEX_MODEL, CODEX_REASONING_EFFORT, CLAUDE_MODEL, GEMINI_MODEL"
    echo "  REVIEW_TIMEOUT_SEC (default: 1800)"
    echo "  MAX_INPUT_BYTES    (default: 200000)"
    exit 1
}

MODE="${1:-}"
INPUT="${2:-}"
if [[ -z "$MODE" ]] || [[ -z "$INPUT" ]]; then
    usage
fi

case "$MODE" in
    plan|code|analysis|report) ;;
    *)
        echo "Error: Unknown mode '$MODE' (use plan|code|analysis|report)." >&2
        exit 1
        ;;
esac

BLINDED=true
SEARCH_FLAG=""
CD_PATH="$(pwd)"
ROUNDS=""
OUTPUT_FILE=""

shift 2
while [[ $# -gt 0 ]]; do
    case "$1" in
        --quick)
            BLINDED=false
            shift
            ;;
        --blinded)
            BLINDED=true
            shift
            ;;
        --rounds)
            if [[ $# -lt 2 ]]; then
                echo "Error: --rounds requires an integer argument." >&2
                exit 1
            fi
            ROUNDS="$2"
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
                echo "Error: --cd requires a path argument." >&2
                exit 1
            fi
            CD_PATH="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

if [[ -n "$ROUNDS" ]] && { ! [[ "$ROUNDS" =~ ^[0-9]+$ ]] || [[ "$ROUNDS" -lt 1 ]]; }; then
    echo "Error: --rounds must be a positive integer." >&2
    exit 1
fi
if [[ ! -d "$CD_PATH" ]]; then
    echo "Error: --cd path does not exist or is not a directory: $CD_PATH" >&2
    exit 1
fi

if [[ "$BLINDED" == true ]]; then
    echo "Delegating to blinded-consensus.sh (default, all-model blinded consensus)..."
    echo ""
    ARGS=("$MODE" "$INPUT" --cd "$CD_PATH")
    [[ -n "$ROUNDS" ]] && ARGS+=(--rounds "$ROUNDS")
    [[ -n "$SEARCH_FLAG" ]] && ARGS+=(--search)
    [[ -n "$OUTPUT_FILE" ]] && ARGS+=(--output "$OUTPUT_FILE")
    exec "$SCRIPT_DIR/blinded-consensus.sh" "${ARGS[@]}"
fi

echo ""
echo "WARNING: Running QUICK non-blinded mode."
echo "Default and recommended mode is blinded consensus."
echo ""

if [[ -f "$INPUT" ]]; then
    INPUT_DESCRIPTOR="$INPUT"
    BLINDED_INPUT_ARG="$INPUT"
else
    INPUT_BYTES="$(printf '%s' "$INPUT" | wc -c | tr -d '[:space:]')"
    INPUT_DESCRIPTOR="[inline text: ${INPUT_BYTES} bytes]"
    BLINDED_INPUT_ARG="<inline-text>"
fi

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
    echo "Reading from file: $INPUT_DESCRIPTOR"
else
    echo "Using provided text: $INPUT_DESCRIPTOR"
fi

PROMPT="REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.

BE CONCISE. Review this $MODE submission and provide:
- ISSUES: [list with exact file:line when applicable]
- VERDICT: APPROVE / REJECT / CONDITIONAL
- REASONING: [brief]

Submission:
$CONTENT"

echo ""
echo "================================================================"
echo "  CODEX REVIEW (QUICK)"
echo "================================================================"
echo ""
if command -v codex >/dev/null 2>&1; then
    CODEX_ARGS=(codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check)
    CODEX_ARGS+=(-m "$CODEX_MODEL")
    CODEX_ARGS+=(-c "model_reasoning_effort=\"$CODEX_REASONING_EFFORT\"")
    [[ -n "$SEARCH_FLAG" ]] && CODEX_ARGS+=(--search)
    CODEX_ARGS+=(--cd "$CD_PATH")
    CODEX_ARGS+=("$PROMPT")
    run_with_timeout "${CODEX_ARGS[@]}" || echo "Codex review failed or timed out"
else
    echo "Codex CLI not installed. Install with: npm i -g @openai/codex"
fi

echo ""
echo "================================================================"
echo "  GEMINI REVIEW (QUICK)"
echo "================================================================"
echo ""
if command -v gemini >/dev/null 2>&1; then
    GEMINI_ARGS=(gemini --yolo --model "$GEMINI_MODEL" -p "$PROMPT")
    (cd "$CD_PATH" && run_with_timeout "${GEMINI_ARGS[@]}") || echo "Gemini review failed or timed out"
else
    echo "Gemini CLI not installed. Install with: npm i -g @google/gemini-cli"
fi

echo ""
echo "================================================================"
echo "  CLAUDE REVIEW (QUICK)"
echo "================================================================"
echo ""
if command -v claude >/dev/null 2>&1; then
    CLAUDE_ARGS=(claude --dangerously-skip-permissions --model "$CLAUDE_MODEL" -p "$PROMPT")
    (cd "$CD_PATH" && run_with_timeout "${CLAUDE_ARGS[@]}") || echo "Claude review failed or timed out"
else
    echo "Claude CLI not installed."
fi

echo ""
echo "================================================================"
echo "  QUICK REVIEW COMPLETE"
echo "================================================================"
echo "For full consensus and sign-off, run blinded mode:"
echo "  ./scripts/consensus-review.sh $MODE \"$BLINDED_INPUT_ARG\" --blinded --rounds 3 --cd \"$CD_PATH\""
