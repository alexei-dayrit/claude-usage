#!/usr/bin/env bash
# Claude Code settings sync setup for macOS/Linux
# Run once from within the cloned repo:
#   cd ~/Documents/claude-usage && bash setup-mac.sh

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_DIR="$REPO_ROOT/settings"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

link_setting() {
    local target="$SETTINGS_DIR/$1"
    local link="$CLAUDE_DIR/$1"

    if [ -L "$link" ]; then
        echo "  Already linked: $link"
        return
    fi

    if [ -e "$link" ]; then
        mv "$link" "${link}.bak"
        echo "  Backed up existing file to ${link}.bak"
    fi

    ln -s "$target" "$link"
    echo "  Linked: $link -> $target"
}

echo ""
echo "Linking Claude Code settings to repo..."
link_setting "settings.json"
link_setting "keybindings.json"
link_setting "CLAUDE.md"

echo ""
echo "Done. Settings are now synced from:"
echo "  $SETTINGS_DIR"
echo ""
echo "To keep settings in sync:"
echo "  git pull                                          # get changes from other machines"
echo "  git add settings/ && git commit && git push      # push your changes"
