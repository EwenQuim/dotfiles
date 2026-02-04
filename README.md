# Dotfiles

My personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply EwenQuim
```

Works on macOS (Intel/ARM) and Linux.

## What's Included

- **Shell**: Fish with starship prompt
- **Editor**: Neovim (NvChad config)
- **Terminal**: Ghostty
- **Git**: delta, lazygit, git-absorb
- **CLI tools**: bat, eza, fd, fzf, ripgrep, zoxide, btop

## Structure

```
.
├── .chezmoi.toml.tmpl          # chezmoi config template
├── .chezmoiignore              # files to ignore
├── .chezmoiscripts/            # bootstrap scripts
│   ├── run_once_set-fish-shell.sh.tmpl
│   ├── run_once_setup-secrets.sh.tmpl
│   └── run_onchange_install-packages.sh.tmpl
├── Brewfile                    # macOS packages
├── dot_config/
│   ├── btop/
│   ├── fish/
│   ├── ghostty/
│   ├── nvim/
│   └── starship.toml
└── dot_gitconfig.tmpl          # git config with templating
```

## Cross-Platform Support

Templates handle OS-specific differences:
- Homebrew paths (ARM vs Intel macOS, Linux)
- Package managers (brew, apt, pacman, dnf)
- Machine-specific git email

## Secrets

Secrets are managed via Bitwarden CLI. After install:

```bash
brew install bitwarden-cli
bw login
export BW_SESSION=$(bw unlock --raw)
chezmoi apply
```

## Commands

```bash
chezmoi diff        # Preview changes
chezmoi apply       # Apply changes
chezmoi edit        # Edit a managed file
chezmoi add ~/.foo  # Track a new file
chezmoi cd          # Enter source directory
```
