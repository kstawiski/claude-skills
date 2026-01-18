---
name: codex-gemini-consensus
description: Multi-AI consensus workflow using OpenAI Codex CLI and Google Gemini CLI for critical code review and planning. Use when implementing features, reviewing code, or planning implementations that require rigorous validation for clinical research or high-stakes applications. Triggers on requests for consensus-based development, multi-AI review, critical code validation, or explicit mentions of Codex/Gemini collaboration.
---

# Codex & Gemini Consensus Workflow

Multi-AI agent consensus system for critical code development and review, especially suited for clinical research applications.

## Core Principle

**All plans must be accepted by Claude, Codex, AND Gemini. All code must be reviewed by Codex AND Gemini with critical evaluation. Do not accept findings blindly—argue and reach consensus.**

## Quick Reference

### Codex CLI (Full Auto with Permissions)

```bash
# Full auto mode with file editing, web search, commands
codex exec --full-auto \
  --model gpt-5.2-codex \
  --sandbox danger-full-access \
  --cd "$(pwd)" \
  "YOUR_PROMPT"

# With session continuity
codex exec --full-auto \
  --model gpt-5.2-codex \
  --sandbox danger-full-access \
  --session-id "$SESSION_ID" \
  "YOUR_PROMPT"
```

### Gemini CLI (Full Auto with Permissions)

```bash
# YOLO mode (auto-approve all tools)
gemini --yolo \
  --model gemini-3-pro-preview \
  -p "YOUR_PROMPT"

# With sandbox for safety
gemini --yolo --sandbox \
  --model gemini-3-pro-preview \
  -p "YOUR_PROMPT"
```

## Consensus Workflow

### Phase 1: Planning

1. **Claude proposes** initial implementation plan
2. **Submit to Codex** for critical review:
   ```bash
   codex exec --full-auto --model gpt-5.2-codex --sandbox danger-full-access \
     "Review this implementation plan critically. Focus on: edge cases, security, performance, maintainability. Be rigorous—this is for clinical research. Plan: [PASTE_PLAN]"
   ```
3. **Submit to Gemini** for independent review:
   ```bash
   gemini --yolo --model gemini-3-pro-preview \
     -p "Review this implementation plan critically. Focus on: edge cases, security, performance, maintainability. Be rigorous—this is for clinical research. Plan: [PASTE_PLAN]"
   ```
4. **Synthesize feedback**, argue points of disagreement, reach consensus
5. **Iterate** until all three agents agree

### Phase 2: Implementation

1. Claude implements based on consensus plan
2. Code review cycle (see below)

### Phase 3: Code Review

Submit code to both agents for critical review:

```bash
# Codex review
codex exec --full-auto --model gpt-5.2-codex --sandbox danger-full-access \
  "Review this code critically for clinical research application. Check: correctness, edge cases, error handling, security, performance, documentation. Code: [PASTE_CODE]"

# Gemini review  
gemini --yolo --model gemini-3-pro-preview \
  -p "Review this code critically for clinical research application. Check: correctness, edge cases, error handling, security, performance, documentation. Code: [PASTE_CODE]"
```

## Detailed CLI References

For comprehensive command-line options:
- **Codex CLI**: See [references/codex-cli.md](references/codex-cli.md)
- **Gemini CLI**: See [references/gemini-cli.md](references/gemini-cli.md)

## Environment Setup

### Prerequisites

```bash
# Install Codex CLI
npm i -g @openai/codex

# Install Gemini CLI
npm i -g @google/gemini-cli

# Authenticate Codex (ChatGPT OAuth or API key)
codex login
# Or: export OPENAI_API_KEY="your-key"

# Authenticate Gemini
export GEMINI_API_KEY="your-key"
# Or use Google account OAuth on first run
```

### Verification

```bash
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

## Critical Review Prompts

### For Plan Review

```
Review this implementation plan critically for a clinical research application.

REQUIRED CHECKS:
1. Logical correctness and completeness
2. Edge cases and error conditions
3. Security vulnerabilities
4. Performance implications
5. Maintainability and readability
6. Compliance with medical/research standards

BE CRITICAL. ARGUE AGAINST WEAK POINTS. DO NOT APPROVE BLINDLY.

Plan:
[PASTE_PLAN]
```

### For Code Review

```
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

Code:
[PASTE_CODE]
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
| Network blocked | Add `-c 'sandbox_workspace_write.network_access=true'` |
| Sandbox errors | Use `--sandbox danger-full-access` |
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
