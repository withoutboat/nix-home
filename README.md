# nix-home

`nix-home` exports:

- `homeModules.default` — Home Manager module with shared user configuration, `nix-hyprland`, `nix-ks3-infra`, and `nix-neovim`
- `homeModules.neovim` — standalone Neovim configuration powered by NixVim (`withoutboat/nix-neovim`) with default editor settings and `v` / `vim` aliases
- `homeModules.ks3` — standalone minimal K3s rootless service and Kubernetes tooling module (`programs.k3s-infra` / `services.k3s-infra`)
- `homeModules.scripts` — custom scripts module exporting `zellij-sessionizer`, `theme-set`, and `theme-toggle`
- `homeModules.shell` — shell configuration with Zsh, Nushell, Starship prompt, and Stylix theme integration
- `homeModules.zellij` — Zellij terminal workspace and session manager with Nushell default shell, centered floating sessionizer popup, and Stylix theming

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

### 1. Zellij Sessionizer (`zellij-sessionizer` / `zs`)

A quick project and session switcher powered by `fzf`, integrated directly into Zellij as a centered floating popup pane:

- **Inside Zellij (standard shortcuts)**:
  - **`Ctrl+o` → `f`** or **`Ctrl+o` → `s`**: standard Zellij Session mode shortcut.
  - **`Ctrl+f`**: quick direct shortcut from Normal mode.
  - **`Alt+f`**: global shortcut from any mode (except locked).
  - **`Ctrl+b` → `f`**: tmux compatibility mode.
  - Opens in a centered floating pane (`width: 60%`, `height: 60%`) that automatically closes upon project selection or cancel (`Esc`).
  - Automatically switches to an existing tab if already open, or creates a new tab rooted in the selected project folder.
- **Outside Zellij / terminal**:
  - Run `zs` or `zellij-sessionizer` (or press `Ctrl+f` in Zsh).
  - Attaches to an existing session or creates a new one rooted in the selected directory (`zellij attach -c <project>`).
- **Search paths**: scans configured workspace roots (`~/hiplabs`, `~/personal`, `~/.dotfiles`, etc.) and filters out non-project directories.

### 2. Built-in Session Manager (Floating Window)

- **`Alt+s`** (from any mode) or **`Ctrl+o` → `w`**: opens Zellij's floating session manager.
- Interactive fuzzy search and instant switching between running sessions without exiting the terminal.
- Resurrect exited sessions with their saved pane layouts and command history.
- Create new isolated sessions and rename current sessions.

### 3. Essential Zellij Keybindings

- **`Ctrl+o` → `d`**: detach from the current session (leaves processes running in background).
- **`Ctrl+o` → `f` / `s`** or **`Ctrl+f`**: open centered floating sessionizer.
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

