# AI Coding Assistant Skills

Shared skills repository for Claude, Codex, Gemini, and Antigravity AI coding agents.

## Install

Install skills for all AI agents:

```bash
# Claude
[ -d ~/.claude/skills/.git ] && git -C ~/.claude/skills pull || (mkdir -p ~/.claude/skills && cd ~/.claude/skills && git init && git remote add origin https://github.com/kstawiski/claude-skills && git fetch --depth 1 && git checkout -f origin/main)

# Codex
[ -d ~/.codex/skills/.git ] && git -C ~/.codex/skills pull || (mkdir -p ~/.codex/skills && cd ~/.codex/skills && git init && git remote add origin https://github.com/kstawiski/claude-skills && git fetch --depth 1 && git checkout -f origin/main)

# Gemini  
[ -d ~/.gemini/skills/.git ] && git -C ~/.gemini/skills pull || (mkdir -p ~/.gemini/skills && cd ~/.gemini/skills && git init && git remote add origin https://github.com/kstawiski/claude-skills && git fetch --depth 1 && git checkout -f origin/main)

# Antigravity
[ -d ~/.gemini/antigravity/skills/.git ] && git -C ~/.gemini/antigravity/skills pull || (mkdir -p ~/.gemini/antigravity/skills && cd ~/.gemini/antigravity/skills && git init && git remote add origin https://github.com/kstawiski/claude-skills && git fetch --depth 1 && git checkout -f origin/main)
```

### One-liner (all agents)

```bash
for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills ~/.gemini/antigravity/skills; do [ -d "$d/.git" ] && git -C "$d" pull || (mkdir -p "$d" && cd "$d" && git init && git remote add origin https://github.com/kstawiski/claude-skills && git fetch --depth 1 && git checkout -f origin/main); done
```

### Update Alias

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
alias ai-skills-update='for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills ~/.gemini/antigravity/skills; do [ -d "$d/.git" ] && git -C "$d" pull || (mkdir -p "$d" && cd "$d" && git init && git remote add origin https://github.com/kstawiski/claude-skills 2>/dev/null; git fetch --depth 1 && git checkout -f origin/main); done'
```

Then update all skills with:

```bash
ai-skills-update
```

## Skills

| Skill | Description |
|-------|-------------|
| [claude-codex-gemini-consensus](claude-codex-gemini-consensus/) | Multi-AI consensus workflow for code review, scientific analysis, and reports |
| [humanizer](humanizer/) | Remove AI-generated writing patterns from text for natural, human-like output |
| [prostate-cancer](prostate-cancer/) | Prostate cancer clinical research domain knowledge |
| [b56-prostate-cancer-programme](b56-prostate-cancer-programme/) | B56 prostate cancer programme specifics |

## Usage

When running any AI agent, it will automatically pick up skills from its respective directory:

- **Claude**: Reads from `~/.claude/skills/`
- **Codex**: Reads from `~/.codex/skills/`
- **Gemini**: Reads from `~/.gemini/skills/`
- **Antigravity**: Reads from `~/.gemini/antigravity/skills/`

### Cross-Agent Consultation

With the `claude-codex-gemini-consensus` skill, each agent can consult the others:

| Running | Consults |
|---------|----------|
| Claude | Codex + Gemini |
| Codex | Claude + Gemini |
| Gemini | Claude + Codex |
| Antigravity | Claude + Codex + Gemini |

See the [skill documentation](claude-codex-gemini-consensus/SKILL.md) for details.