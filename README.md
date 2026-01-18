## Install

```
[ -d ~/.claude/skills/.git ] && git -C ~/.claude/skills pull || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.claude/skills
```

# Install tool

```
echo "alias claude-skills-update='[ -d ~/.claude/skills/.git ] && git -C ~/.claude/skills pull || git clone --depth 1 https://github.com/kstawiski/claude-skills ~/.claude/skills'" >> ~/.zshrc && source ~/.zshrc
```