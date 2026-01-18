# AI Coding Assistant Skills

Shared skills repository for Claude, Codex, Gemini, and Antigravity AI coding agents.

## Install

Install skills for all AI agents:

```bash
# Claude
[ -d ~/.claude/skills/.git ] && git -C ~/.claude/skills pull || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.claude/skills

# Codex
[ -d ~/.codex/skills/.git ] && git -C ~/.codex/skills pull || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.codex/skills

# Gemini
[ -d ~/.gemini/skills/.git ] && git -C ~/.gemini/skills pull || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.gemini/skills

# Antigravity
[ -d ~/.gemini/antigravity/skills/.git ] && git -C ~/.gemini/antigravity/skills pull || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.gemini/antigravity/skills
```

### One-liner (all agents)

```bash
for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills ~/.gemini/antigravity/skills; do [ -d "$d/.git" ] && git -C "$d" pull || git clone --depth 1 https://github.com/kstawiski/claude-skills "$d"; done
```

## Update Alias

Add this to your shell profile (`~/.zshrc` or `~/.bashrc`) for easy updates:

```bash
echo 'alias ai-skills-update='\''for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills ~/.gemini/antigravity/skills; do [ -d "$d/.git" ] && git -C "$d" pull || git clone --depth 1 https://github.com/kstawiski/claude-skills "$d"; done'\''' >> ~/.zshrc && source ~/.zshrc
```

Then update all skills with:

```bash
ai-skills-update
```

## Skills

| Skill | Description |
|-------|-------------|
| [claude-codex-gemini-consensus](claude-codex-gemini-consensus/) | Multi-AI consensus workflow for code review, scientific analysis, and reports |
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