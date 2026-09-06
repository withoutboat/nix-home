# nix-home

`nix-home` exports:

- `homeModules.default` — Home Manager module with shared user configuration, `nix-hyprland`, `nix-ks3-infra`, and `nix-neovim`
- `homeModules.neovim` — standalone Neovim configuration powered by NixVim (`withoutboat/nix-neovim`) with default editor settings and `v` / `vim` aliases
- `homeModules.ks3` — standalone minimal K3s rootless service and Kubernetes tooling module (`programs.k3s-infra` / `services.k3s-infra`)
- `homeModules.shell` — shell configuration with Zsh, Nushell, Starship prompt, and Stylix theme integration
- `homeModules.zellij` — Zellij terminal workspace and session manager with Nushell default shell, `zellij-sessionizer` tool, and Stylix theming

This repository is intended for reusable Home Manager configuration only.
Machine-specific system networking and VPN setup should live in `withoutboat/nix-core`.

## Usage

```nix
{
  imports = [
    inputs.nix-home.homeModules.default
  ];
}
```

## Session Management (Zellij & Sessionizer)

The configuration provides a complete sessionization workflow replacing `tmux-sessionizer` and the legacy tmux setup:

### 1. Zellij Sessionizer (`zellij-sessionizer` / `zs` / `Ctrl+f`)

A quick project and session switcher powered by `fzf`:

- **Quick launch**: press `Ctrl+f` in Zsh or run `zs` / `zellij-sessionizer`.
- **Search paths**: scans configured workspace roots (`~/hiplabs`, `~/personal`, `~/nix-core`, `~/nix-home`, `~/.dotfiles`, etc.).
- **Outside Zellij**: attaches to an existing session or creates a new one rooted in the chosen project directory (`zellij attach -c <project>`).
- **Inside Zellij**: opens a new tab named after the project with its working directory set to that project (`zellij action new-tab --cwd ...`).

### 2. Built-in Session Manager (Floating Window)

- **`Alt+s`** (from any mode) or **`Ctrl+o` → `w`**: opens Zellij's floating session manager.
- Interactive fuzzy search and instant switching between running sessions without exiting the terminal.
- Resurrect exited sessions with their saved pane layouts and command history.
- Create new isolated sessions and rename current sessions.

### 3. Essential Zellij Keybindings

- **`Ctrl+o` → `d`**: detach from the current session (leaves processes running in background).
- **`Alt+s`**: switch/select sessions via the floating session-manager.
- **`Ctrl+t` → `n`**: create a new tab.
- **`Ctrl+p` → `n`**: create a new pane.
- **`Ctrl+p` → `w`**: toggle floating mode for the current pane.
- **`Ctrl+q`**: close current pane.
- **`Ctrl+o` → `q`**: quit and terminate session.

### 4. Theming (Stylix)

Zellij, Starship, and Nushell are configured with automatic **Stylix** theming:
- Palettes are dynamically generated from base16 schemes (e.g. Catppuccin Mocha / Catppuccin Latte).
- Automatically updates with `theme-set light` / `theme-set dark` and scheduled system timers.

