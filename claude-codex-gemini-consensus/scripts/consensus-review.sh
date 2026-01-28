#!/usr/bin/env bash
# consensus-review.sh - Submit code/plan to Codex and Gemini for critical review
# Usage: ./consensus-review.sh <plan|code> <file_or_text> [--blinded]
#
# NOTE: For non-trivial reviews, prefer blinded-consensus.sh which provides
# anonymized multi-round discussion with argumentation.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MODE="${1:-}"
INPUT="${2:-}"
BLINDED=false

# Check for --blinded flag
for arg in "$@"; do
    if [[ "$arg" == "--blinded" ]]; then
        BLINDED=true
    fi
done

if [[ -z "$MODE" ]] || [[ -z "$INPUT" ]]; then
    echo "Usage: $0 <plan|code> <file_path_or_text> [--blinded]"
    echo ""
    echo "Options:"
    echo "  --blinded    Use blinded multi-round consensus (RECOMMENDED)"
    echo ""
    echo "Examples:"
    echo "  $0 plan implementation_plan.md --blinded    # Preferred: blinded consensus"
    echo "  $0 code src/analysis.py --blinded           # Preferred: blinded consensus"
    echo "  $0 plan implementation_plan.md              # Quick: standard consensus"
    echo "  $0 code src/analysis.py                     # Quick: standard consensus"
    echo ""
    echo "NOTE: For rigorous reviews, use --blinded or call blinded-consensus.sh directly."
    exit 1
fi

# Delegate to blinded-consensus.sh if --blinded flag is set
if [[ "$BLINDED" == true ]]; then
    echo "Delegating to blinded-consensus.sh for anonymized multi-round review..."
    echo ""
    exec "$SCRIPT_DIR/blinded-consensus.sh" "$MODE" "$INPUT"
fi

echo ""
echo "WARNING: Running standard (non-blinded) consensus review."
echo "For rigorous reviews, re-run with --blinded flag or use blinded-consensus.sh directly."
echo ""

# Determine if input is a file or text
if [[ -f "$INPUT" ]]; then
    CONTENT=$(cat "$INPUT")
    echo "Reading from file: $INPUT"
else
    CONTENT="$INPUT"
    echo "Using provided text"
fi

# Build the review prompt based on mode
if [[ "$MODE" == "plan" ]]; then
    PROMPT="REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.

Review this implementation plan critically for a clinical research application.

REQUIRED CHECKS:
1. Logical correctness and completeness
2. Edge cases and error conditions
3. Security vulnerabilities
4. Performance implications
5. Maintainability and readability
6. Compliance with medical/research standards

BE CRITICAL. ARGUE AGAINST WEAK POINTS. DO NOT APPROVE BLINDLY.
Provide SPECIFIC REASONING for every assessment point.

OUTPUT FORMAT:
ASSESSMENT:
- [Point]: [Your reasoned argument]
ISSUES: [list with proposed fixes]
VERDICT: APPROVE / REJECT / CONDITIONAL
REASONING: [2-3 sentence summary of your assessment logic]

Plan:
$CONTENT"

elif [[ "$MODE" == "code" ]]; then
    PROMPT="REVIEWER_MODE. DO NOT INVOKE OTHER AGENTS (claude, codex, gemini).
You MAY read files, web search, and run sanity checks. Provide YOUR expert review only.

Critically review this code for a clinical research application.

REQUIRED CHECKS:
1. Correctness: Does it do what it claims?
2. Edge cases: Are all inputs handled?
3. Error handling: Are failures graceful?
4. Security: Any vulnerabilities?
5. Performance: Any bottlenecks?
6. Documentation: Is intent clear?
7. Tests: What tests are needed?

BE HARSH. FIND PROBLEMS. DO NOT APPROVE BLINDLY.
Provide SPECIFIC REASONING for every finding. Reference exact lines/functions.

OUTPUT FORMAT:
ASSESSMENT:
- [Aspect]: [Your reasoned argument with code references]
BUGS/ISSUES: [list with failure scenarios and fixes]
VERDICT: APPROVE / REJECT / CONDITIONAL
REASONING: [2-3 sentence summary]

Code:
$CONTENT"

else
    echo "Unknown mode: $MODE (use 'plan' or 'code')"
    exit 1
fi

echo ""
echo "================================================================"
echo "  CODEX REVIEW"
echo "================================================================"
echo ""

# Check if codex is available
if command -v codex &> /dev/null; then
    codex exec --dangerously-bypass-approvals-and-sandbox \
        --skip-git-repo-check \
        "$PROMPT" 2>&1 || echo "Codex review failed or not authenticated"
else
    echo "Codex CLI not installed. Install with: npm i -g @openai/codex"
fi

echo ""
echo "================================================================"
echo "  GEMINI REVIEW"
echo "================================================================"
echo ""

# Check if gemini is available
if command -v gemini &> /dev/null; then
    gemini --yolo \
        -p "$PROMPT" 2>&1 || echo "Gemini review failed or not authenticated"
else
    echo "Gemini CLI not installed. Install with: npm i -g @google/gemini-cli"
fi

echo ""
echo "================================================================"
echo "  REVIEWS COMPLETE - Synthesize feedback and reach consensus"
echo "================================================================"
echo ""
echo "NEXT STEPS:"
echo "  1. Compare findings from both reviewers"
echo "  2. Argue any disagreements with specific evidence"
echo "  3. If disagreements persist, run blinded consensus:"
echo "     ./scripts/blinded-consensus.sh $MODE $INPUT"
echo "================================================================"
