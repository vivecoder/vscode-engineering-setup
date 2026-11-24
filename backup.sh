#!/usr/bin/env bash

# ==========================================================
# VS Code and AI Engineering Configuration Backup
# Platform: Windows with Git Bash
# ==========================================================

set -euo pipefail

# 1. Configure backup paths
BACKUP_ROOT="$HOME/VSCode_Backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BACKUP_ROOT/backups/$TIMESTAMP"

VSCODE_USER="$(cygpath -u "$APPDATA")/Code/User"

# 2. Create backup directories
mkdir -p "$BACKUP_DIR/vscode"
mkdir -p "$BACKUP_DIR/claude"
mkdir -p "$BACKUP_DIR/codex"
mkdir -p "$BACKUP_DIR/copilot"

echo "=========================================="
echo "Starting VS Code Configuration Backup"
echo "=========================================="

# 3. Reusable file backup function
backup_file() {
    local source="$1"
    local destination="$2"

    if [ -f "$source" ]; then
        cp "$source" "$destination"
        echo "[OK] $(basename "$source")"
    else
        echo "[SKIPPED] File not found: $source"
    fi
}

# 4. VS Code settings
# Settings may contain sensitive connection information.
# Require manual review before copying.

read -r -p "Have you reviewed settings.json for secrets? (y/N): " REVIEWED

if [[ "$REVIEWED" =~ ^[Yy]$ ]]; then
    backup_file \
        "$VSCODE_USER/settings.json" \
        "$BACKUP_DIR/vscode/settings.json"
else
    echo "[SKIPPED] settings.json requires security review"
fi

# 5. Keyboard shortcuts
backup_file \
    "$VSCODE_USER/keybindings.json" \
    "$BACKUP_DIR/vscode/keybindings.json"

# 6. Global code snippets
if [ -d "$VSCODE_USER/snippets" ]; then
    cp -R "$VSCODE_USER/snippets" "$BACKUP_DIR/vscode/"
    echo "[OK] Global snippets"
else
    echo "[SKIPPED] Snippets directory not found"
fi

# 7. Installed extensions
if command -v code >/dev/null 2>&1; then
    code --list-extensions --show-versions \
        > "$BACKUP_DIR/vscode/extensions.txt"
    echo "[OK] Installed extensions"
else
    echo "[SKIPPED] VS Code CLI not available"
fi

# 8. Claude global instructions
backup_file \
    "$HOME/.claude/CLAUDE.md" \
    "$BACKUP_DIR/claude/CLAUDE.md"

# 9. Codex global instructions
backup_file \
    "$HOME/.codex/AGENTS.md" \
    "$BACKUP_DIR/codex/AGENTS.md"

# 10. Copilot global instructions
backup_file \
    "$HOME/.copilot/instructions/data-ai-engineering.instructions.md" \
    "$BACKUP_DIR/copilot/data-ai-engineering.instructions.md"

# 11. Project Manager configuration
backup_file \
    "$VSCODE_USER/globalStorage/alefragnani.project-manager/projects.json" \
    "$BACKUP_DIR/vscode/projects.json"

# 12. Generate backup manifest
{
    echo "Backup date: $(date)"
    echo "Computer: ${COMPUTERNAME:-Unknown}"
    echo ""
    echo "Backed-up files:"
    cd "$BACKUP_DIR"
    find . -type f ! -name manifest.txt | sort
} > "$BACKUP_DIR/manifest.txt"

# 13. Display backup summary
echo ""
echo "=========================================="
echo "Backup completed"
echo "=========================================="
echo "Location: $BACKUP_DIR"
echo ""
echo "Backed-up files:"
find "$BACKUP_DIR" -type f
echo ""
echo "Review backup contents before external storage."
