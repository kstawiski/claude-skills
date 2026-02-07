#!/usr/bin/env bash
# =============================================================================
# Consensus Review Wrapper Script
# =============================================================================
# GUARANTEED REVIEWER_MODE injection for all agent invocations.
# Use this script instead of calling agents directly to prevent infinite loops.
#
# Usage:
#   ./review.sh codex "Your review prompt here"
#   ./review.sh gemini "Your review prompt here"
#   ./review.sh claude "Your review prompt here"
#
# The script automatically prepends REVIEWER_MODE constraints to every prompt.
# =============================================================================

set -euo pipefail

# Preferred model configuration (override via env vars).
CODEX_MODEL="${CODEX_MODEL:-gpt-5.3-codex}"
CODEX_REASONING_EFFORT="${CODEX_REASONING_EFFORT:-xhigh}" # allowed: high|xhigh
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}" # Opus 4.6 alias on current Claude CLI
GEMINI_MODEL="${GEMINI_MODEL:-gemini-3-pro-preview}"
REVIEW_TIMEOUT_SEC="${REVIEW_TIMEOUT_SEC:-1800}"

if ! [[ "$REVIEW_TIMEOUT_SEC" =~ ^[0-9]+$ ]] || [[ "$REVIEW_TIMEOUT_SEC" -lt 1 ]]; then
    echo "Warning: REVIEW_TIMEOUT_SEC must be a positive integer. Falling back to 1800." >&2
    REVIEW_TIMEOUT_SEC=1800
fi

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

case "$CODEX_REASONING_EFFORT" in
    high|xhigh) ;;
    *)
        echo "Warning: CODEX_REASONING_EFFORT must be high or xhigh. Falling back to xhigh." >&2
        CODEX_REASONING_EFFORT="xhigh"
        ;;
esac

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

REVIEWER_HEADER='REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.

'

usage() {
    echo "Usage: $0 <agent> <prompt> [options]"
    echo ""
    echo "Agents:"
    echo "  codex   - Invoke OpenAI Codex CLI"
    echo "  gemini  - Invoke Google Gemini CLI"
    echo "  claude  - Invoke Anthropic Claude CLI"
    echo ""
    echo "Options:"
    echo "  --search    Enable web search (codex/gemini)"
    echo "  --cd PATH   Change working directory"
    echo ""
    echo "Environment overrides:"
    echo "  CODEX_MODEL              (default: gpt-5.3-codex)"
    echo "  CODEX_REASONING_EFFORT   (default: xhigh, allowed: high|xhigh)"
    echo "  CLAUDE_MODEL             (default: opus)"
    echo "  GEMINI_MODEL             (default: gemini-3-pro-preview)"
    echo "  REVIEW_TIMEOUT_SEC       (default: 1800)"
    echo ""
    echo "Examples:"
    echo "  $0 codex 'Review src/main.py for bugs'"
    echo "  $0 gemini 'Validate this analysis plan' --search"
    echo "  $0 claude 'Check for security issues in auth.py'"
    exit 1
}

if [[ $# -lt 2 ]]; then
    usage
fi

AGENT="$1"
PROMPT="$2"
shift 2

# Parse optional arguments
SEARCH_FLAG=""
CD_PATH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --search)
            SEARCH_FLAG="--search"
            shift
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
            usage
            ;;
    esac
done

if [[ -n "$CD_PATH" ]] && [[ ! -d "$CD_PATH" ]]; then
    echo "Error: --cd path does not exist or is not a directory: $CD_PATH" >&2
    exit 1
fi

# Prepend REVIEWER_MODE header to prompt (GUARANTEED)
FULL_PROMPT="${REVIEWER_HEADER}${PROMPT}"

case "$AGENT" in
    codex)
        if ! command -v codex >/dev/null 2>&1; then
            echo "Error: codex CLI not found in PATH." >&2
            exit 127
        fi
        CMD=(codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check)
        CMD+=(-m "$CODEX_MODEL")
        CMD+=(-c "model_reasoning_effort=\"$CODEX_REASONING_EFFORT\"")
        [[ -n "$SEARCH_FLAG" ]] && CMD+=(--search)
        [[ -n "$CD_PATH" ]] && CMD+=(--cd "$CD_PATH")
        CMD+=("$FULL_PROMPT")
        run_with_timeout "${CMD[@]}"
        ;;
    gemini)
        if ! command -v gemini >/dev/null 2>&1; then
            echo "Error: gemini CLI not found in PATH." >&2
            exit 127
        fi
        CMD=(gemini --yolo --model "$GEMINI_MODEL" -p "$FULL_PROMPT")
        # Gemini has built-in web search, no flag needed.
        if [[ -n "$CD_PATH" ]]; then
            (cd "$CD_PATH" && run_with_timeout "${CMD[@]}")
        else
            run_with_timeout "${CMD[@]}"
        fi
        ;;
    claude)
        if ! command -v claude >/dev/null 2>&1; then
            echo "Error: claude CLI not found in PATH." >&2
            exit 127
        fi
        CMD=(claude --dangerously-skip-permissions --model "$CLAUDE_MODEL" -p "$FULL_PROMPT")
        if [[ -n "$CD_PATH" ]]; then
            (cd "$CD_PATH" && run_with_timeout "${CMD[@]}")
        else
            run_with_timeout "${CMD[@]}"
        fi
        ;;
    *)
        echo "Error: Unknown agent '$AGENT'"
        echo "Valid agents: codex, gemini, claude"
        exit 1
        ;;
esac
