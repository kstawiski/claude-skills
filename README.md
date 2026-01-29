# AI Coding Assistant Skills

Shared skills repository for Claude, Codex, Gemini, and Antigravity AI coding agents.

## Install

Install skills for all AI agents:

```bash
# Claude
[ -d ~/.claude/skills/.git ] && (git -C ~/.claude/skills fetch --depth 1 origin main && git -C ~/.claude/skills checkout -B main origin/main && git -C ~/.claude/skills pull --ff-only) || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.claude/skills

# Codex
[ -d ~/.codex/skills/.git ] && (git -C ~/.codex/skills fetch --depth 1 origin main && git -C ~/.codex/skills checkout -B main origin/main && git -C ~/.codex/skills pull --ff-only) || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.codex/skills

# Gemini
[ -d ~/.gemini/skills/.git ] && (git -C ~/.gemini/skills fetch --depth 1 origin main && git -C ~/.gemini/skills checkout -B main origin/main && git -C ~/.gemini/skills pull --ff-only) || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.gemini/skills

# Antigravity
[ -d ~/.gemini/antigravity/skills/.git ] && (git -C ~/.gemini/antigravity/skills fetch --depth 1 origin main && git -C ~/.gemini/antigravity/skills checkout -B main origin/main && git -C ~/.gemini/antigravity/skills pull --ff-only) || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.gemini/antigravity/skills
```

### One-liner (all agents)

```bash
for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills ~/.gemini/antigravity/skills; do [ -d "$d/.git" ] && (git -C "$d" fetch --depth 1 origin main && git -C "$d" checkout -B main origin/main && git -C "$d" pull --ff-only) || git clone --depth 1 https://github.com/kstawiski/claude-skills "$d"; done
```

### Update Alias

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
alias ai-skills-update='for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills ~/.gemini/antigravity/skills; do [ -d "$d/.git" ] && (git -C "$d" fetch --depth 1 origin main && git -C "$d" checkout -B main origin/main && git -C "$d" pull --ff-only) || git clone --depth 1 https://github.com/kstawiski/claude-skills "$d"; done'
```

Then update all skills with:

```bash
ai-skills-update
```

## Skills

| Skill | Description |
|-------|-------------|
| [bioinformatics-project-setup](bioinformatics-project-setup/) | Standardized project scaffolding for bioinformatics/computational biology with data separation and consensus workflow integration |
| [claude-codex-gemini-consensus](claude-codex-gemini-consensus/) | Multi-AI consensus workflow for code review, scientific analysis, and reports |
| [humanizer](humanizer/) | Remove AI-generated writing patterns from text for natural, human-like output |
| [scientific-figures](scientific-figures/) | Publication-ready figure creation with technical requirements, accessibility, and multi-model validation |
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