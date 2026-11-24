#!/usr/bin/env bash

# ==========================================================
# VS Code and AI Engineering Configuration Restore
# Platform: Windows with Git Bash
# Default mode: Dry run
# ==========================================================

set -euo pipefail

# 1. Configure paths
BACKUP_ROOT="$HOME/VSCode_Backup"
VSCODE_USER="$(cygpath -u "$APPDATA")/Code/User"
MODE="${1:---dry-run}"

# 2. Validate execution mode
case "$MODE" in
    --dry-run|--apply)
        ;;
    *)
        echo "Usage: bash restore.sh [--dry-run|--apply]"
        exit 1
        ;;
esac

# 3. Find available backups
shopt -s nullglob
BACKUPS=("$BACKUP_ROOT"/backups/*/)

if [ "${#BACKUPS[@]}" -eq 0 ]; then
    echo "[ERROR] No backups found."
    exit 1
fi

echo "=========================================="
echo "Available Configuration Backups"
echo "=========================================="

for i in "${!BACKUPS[@]}"; do
    echo "$((i + 1)). $(basename "${BACKUPS[$i]}")"
done

# 4. Select backup
read -r -p "Select backup number: " SELECTION

if ! [[ "$SELECTION" =~ ^[1-9][0-9]*$ ]] ||
   [ "$SELECTION" -gt "${#BACKUPS[@]}" ]; then
    echo "[ERROR] Invalid backup selection."
    exit 1
fi

BACKUP_DIR="${BACKUPS[$((SELECTION - 1))]%/}"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
SAFETY_DIR="$BACKUP_ROOT/pre_restore/$TIMESTAMP"

echo ""
echo "Selected backup: $BACKUP_DIR"
echo "Execution mode: $MODE"

# 5. Confirm actual restoration
if [ "$MODE" = "--apply" ]; then
    echo ""
    echo "Close VS Code and disable Settings Sync before restoring."
    echo "Existing configuration files will be preserved."
    read -r -p "Type RESTORE to continue: " CONFIRM

    if [ "$CONFIRM" != "RESTORE" ]; then
        echo "Restoration cancelled."
        exit 0
    fi

    mkdir -p "$SAFETY_DIR"
fi

# 6. Reusable file restoration function
restore_file() {
    local source="$1"
    local destination="$2"
    local relative_path="$3"

    if [ ! -f "$source" ]; then
        echo "[SKIPPED] Missing: $source"
        return 0
    fi

    if [ "$MODE" = "--dry-run" ]; then
        echo "[DRY RUN] Restore: $destination"
        return 0
    fi

    # Preserve existing file before replacing it
    if [ -f "$destination" ]; then
        mkdir -p "$(dirname "$SAFETY_DIR/$relative_path")"
        cp "$destination" "$SAFETY_DIR/$relative_path"
    fi

    mkdir -p "$(dirname "$destination")"
    cp "$source" "$destination"

    echo "[OK] Restored: $destination"
}

# 7. Restore VS Code settings
restore_file \
    "$BACKUP_DIR/vscode/settings.json" \
    "$VSCODE_USER/settings.json" \
    "vscode/settings.json"

# 8. Restore keyboard shortcuts
restore_file \
    "$BACKUP_DIR/vscode/keybindings.json" \
    "$VSCODE_USER/keybindings.json" \
    "vscode/keybindings.json"

# 9. Restore global snippets
if [ -d "$BACKUP_DIR/vscode/snippets" ]; then
    while IFS= read -r -d '' source; do
        relative="${source#"$BACKUP_DIR/vscode/snippets/"}"

        restore_file \
            "$source" \
            "$VSCODE_USER/snippets/$relative" \
            "vscode/snippets/$relative"
    done < <(
        find "$BACKUP_DIR/vscode/snippets" -type f -print0
    )
fi

# 10. Restore Claude global instructions
restore_file \
    "$BACKUP_DIR/claude/CLAUDE.md" \
    "$HOME/.claude/CLAUDE.md" \
    "claude/CLAUDE.md"

# 11. Restore Codex global instructions
restore_file \
    "$BACKUP_DIR/codex/AGENTS.md" \
    "$HOME/.codex/AGENTS.md" \
    "codex/AGENTS.md"

# 12. Restore Copilot global instructions
restore_file \
    "$BACKUP_DIR/copilot/data-ai-engineering.instructions.md" \
    "$HOME/.copilot/instructions/data-ai-engineering.instructions.md" \
    "copilot/data-ai-engineering.instructions.md"

# 13. Restore Project Manager configuration
restore_file \
    "$BACKUP_DIR/vscode/projects.json" \
    "$VSCODE_USER/globalStorage/alefragnani.project-manager/projects.json" \
    "vscode/projects.json"

# 14. Restore extensions
FAILED_EXTENSIONS=0

if [ -f "$BACKUP_DIR/vscode/extensions.txt" ]; then

    if [ "$MODE" = "--dry-run" ]; then
        echo "[DRY RUN] Extensions to install:"
        cat "$BACKUP_DIR/vscode/extensions.txt"

    elif command -v code >/dev/null 2>&1; then

        while IFS= read -r extension || [ -n "$extension" ]; do
            extension="${extension%$'\r'}"

            [ -z "$extension" ] && continue

            echo "Installing: $extension"

            if ! code --install-extension "$extension"; then
                echo "[FAILED] $extension"
                FAILED_EXTENSIONS=$((FAILED_EXTENSIONS + 1))
            fi

        done < "$BACKUP_DIR/vscode/extensions.txt"

    else
        echo "[WARNING] VS Code CLI unavailable."
        FAILED_EXTENSIONS=1
    fi
fi

# 15. Display final summary
echo ""
echo "=========================================="

if [ "$MODE" = "--dry-run" ]; then
    echo "Dry run completed."
    echo "No configuration files were modified."
    echo "No extensions were installed."
else
    echo "File restoration completed."
    echo "Extension failures: $FAILED_EXTENSIONS"
    echo "Previous files preserved at: $SAFETY_DIR"
    echo "Restart VS Code and review configuration."
fi

echo "=========================================="

if [ "$FAILED_EXTENSIONS" -gt 0 ]; then
    exit 1
fi
