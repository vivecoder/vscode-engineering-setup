# VS Code & AI Engineering Setup

A reusable personal development environment configuration for Data Engineering, Artificial Intelligence and general Software Engineering.

This repository provides version-controlled configuration backups and restoration scripts to simplify environment recovery after operating system reinstallation, laptop formatting or migration to a new machine.

## 1. Supported Development Areas

- Python, SQL and PySpark
- Microsoft Fabric and Azure Databricks
- Snowflake and dbt
- Machine Learning and Deep Learning
- LLM, RAG and Advanced RAG
- AI Agents and MCP Servers
- API Development
- Excel, VBA, Power Query and DAX
- C, C++, C#, Java, JavaScript and TypeScript
- Software Engineering and Solution Architecture

## 2. Environment Configuration

| Component | Configuration |
|---|---|
| Operating System | Windows |
| IDE | Visual Studio Code |
| Terminal | Git Bash |
| Theme | Tokyo Night Storm |
| Editor Font | JetBrains Mono |
| Python Formatter | Black |
| Python Linter | Ruff |
| Version Control | Git and GitHub |
| AI Assistants | Claude Code, OpenAI Codex and GitHub Copilot |
| Project Management | Project Manager |
| Global AI Instructions | 19 Engineering Standards |
| Global Code Snippets | 16 Reusable Templates |
| Cloud Configuration Backup | VS Code Settings Sync |
| Remote Configuration Backup | Private GitHub Repository |

## 3. Repository Structure

```text
VSCode_Backup/
├── README.md
├── .gitignore
├── backup.sh
├── restore.sh
└── backups/
    └── YYYY-MM-DD_HH-MM-SS/
        ├── vscode/
        │   ├── settings.json
        │   ├── keybindings.json
        │   ├── extensions.txt
        │   ├── projects.json
        │   └── snippets/
        ├── claude/
        │   └── CLAUDE.md
        ├── codex/
        │   └── AGENTS.md
        ├── copilot/
        │   └── data-ai-engineering.instructions.md
        └── manifest.txt
```

## 4. Global AI Engineering Standards

All three AI assistants share the same global engineering instructions.

1. Working Approach
2. Software Engineering Standards
3. Python Development
4. SQL Development
5. Data Engineering
6. PySpark and Distributed Computing
7. Cloud Data Platforms
8. Machine Learning and Deep Learning
9. RAG and LLM Engineering
10. AI Agents and MCP Servers
11. API Development
12. Security
13. Testing and Validation
14. Documentation
15. Execution and Change Management
16. Communication Preferences
17. Instruction Scope
18. IDE and AI Assistant Behavior
19. Technology-Agnostic Development

### Global Instruction Locations

| Assistant | Configuration File |
|---|---|
| Claude Code | `~/.claude/CLAUDE.md` |
| OpenAI Codex | `~/.codex/AGENTS.md` |
| GitHub Copilot | `~/.copilot/instructions/data-ai-engineering.instructions.md` |

These instructions establish consistent engineering practices across AI assistants while allowing technology-specific and project-specific requirements.

## 5. AI Security and Permissions

Recommended permission settings:

| Assistant | Permission Mode |
|---|---|
| Claude Code | Manual |
| OpenAI Codex | Ask for approval |
| GitHub Copilot | Manual permissions |

Review destructive commands, credential access, dependency installations, production changes and Git operations before approval.

Permission settings must be verified manually after restoration.

## 6. Create a Configuration Backup

Open Git Bash and execute:

```bash
bash ~/VSCode_Backup/backup.sh
```

The script creates a timestamped configuration backup under the `backups` directory.

Review `settings.json` and other copied files for sensitive information before committing them to GitHub.

## 7. Update GitHub Backup

After creating and reviewing a new backup:

```bash
cd ~/VSCode_Backup
git status
git add backups/
git diff --cached --stat
git commit -m "chore: update engineering configuration backup"
git push origin main
```

Review staged content for credentials before committing.

Commit changes to backup scripts and documentation separately when required.

## 8. Recovery After Laptop Formatting

### Step 1: Install Prerequisites

- Visual Studio Code
- Git for Windows
- JetBrains Mono font

### Step 2: Clone the Backup Repository

Open standalone Git Bash:

```bash
cd ~
git clone https://github.com/vivecoder/vscode-engineering-setup.git VSCode_Backup
cd ~/VSCode_Backup
```

Authenticate using the GitHub account authorised to access the private repository.

The destination directory must not already contain another backup repository.

### Step 3: Validate Restoration

```bash
bash ~/VSCode_Backup/restore.sh --dry-run
```

Select the required backup number and review the restoration plan.

Dry-run mode does not modify configuration files or install extensions.

### Step 4: Restore Configuration

Ensure VS Code is closed and Settings Sync is temporarily disabled.

```bash
bash ~/VSCode_Backup/restore.sh --apply
```

Select the required backup and enter `RESTORE` when prompted.

Existing files that would be overwritten are preserved under the local `pre_restore` directory.

### Step 5: Restart and Validate

- Open VS Code.
- Verify the theme, settings and extensions.
- Sign in to Claude Code, Codex and GitHub Copilot.
- Verify global AI instruction loading.
- Verify AI security and permission settings.
- Test global snippets.
- Update machine-specific project paths.
- Re-enable Settings Sync after reviewing any conflicts.

## 9. Components Requiring Separate Installation

The configuration backup does not replace a complete operating system or application backup.

Install and configure the following components separately when required:

- Python and virtual environments
- Java JDK
- C and C++ compilers
- .NET SDK
- Node.js and npm
- Docker Desktop
- WSL
- NVIDIA drivers and CUDA
- Database drivers and development tools
- Cloud platform authentication
- AI assistant authentication
- MCP server configuration and credentials
- Project repositories and source data

Extension versions may need adjustment if previously backed-up versions are no longer available.

## 10. Security Guidelines

- Keep this repository private.
- Never commit passwords, API keys, access tokens or private keys.
- Never commit authentication stores or `.env` files.
- Review configuration files for embedded credentials.
- Keep pre-restoration safety backups local.
- Do not store production or client data in this repository.
- Review machine-specific paths before restoring to another laptop.

## 11. Maintenance Commands

| Purpose | Command |
|---|---|
| Create backup | `bash ~/VSCode_Backup/backup.sh` |
| Preview restoration | `bash ~/VSCode_Backup/restore.sh --dry-run` |
| Apply restoration | `bash ~/VSCode_Backup/restore.sh --apply` |
| Validate backup script | `bash -n ~/VSCode_Backup/backup.sh` |
| Validate restore script | `bash -n ~/VSCode_Backup/restore.sh` |
| Check repository status | `git status` |
| Upload committed changes | `git push origin main` |

## 12. Validation Status

| Component | Status |
|---|---|
| VS Code Configuration | Completed |
| Global AI Instructions | Verified |
| AI Security and Permissions | Configured |
| Global Snippets | Configured |
| Settings Sync | Verified |
| Local Configuration Backup | Successful |
| Backup Script Syntax | Passed |
| Restore Script Syntax | Passed |
| Restoration Dry Run | Passed |
| GitHub Backup | Successful |
| Full Restoration Test | Pending |

Initial configuration completed: 25 November 2026.

---

**Maintained by ViveCoders**

Personal Engineering Environment — Data, AI and Software Development.
