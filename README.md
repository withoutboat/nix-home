# nix-home

`nix-home` exports:

- `homeModules.default` — Home Manager module with shared user configuration, `nix-hyprland`, `nix-ks3-infra`, and `nix-neovim`
- `homeModules.neovim` — standalone Neovim configuration powered by NixVim (`withoutboat/nix-neovim`) with default editor settings and `v` / `vim` aliases
- `homeModules.ks3` — standalone minimal K3s rootless service and Kubernetes tooling module (`programs.k3s-infra` / `services.k3s-infra`)
- `homeModules.projects` — project and repository manager automating work/personal workspace cloning based on `secrets/projects.yml`
- `homeModules.config` — user configuration options module (`lightTheme`, `darkTheme`)
- `homeModules.scripts` — custom scripts module exporting `zellij-sessionizer`, `theme-set`, and `theme-toggle`
- `homeModules.shell` — shell configuration with Zsh, Nushell, Starship prompt, Atuin unified shell history, and Stylix theme integration
- `homeModules.stylix` — standalone Stylix Home Manager module (only needed if Stylix is not enabled at the NixOS system level)
- `homeModules.theme` — per-user Stylix theming module applying user-configured themes from the catalog (or falling back to system defaults)
- `homeModules.ghostty` — Ghostty terminal configuration with 20% transparency (`background-opacity = 0.8`) and Stylix theming integration
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

### 3. Modal Architecture & Essential Keybindings

Zellij is configured with a modal system and a unified status line powered by **`zjstatus`**:

- **Modes**:
  - **Normal**: default mode with direct shortcuts (`^f` sessionizer, `^p` pane, `^t` tab, `^s` scroll, `^o` session, `^g` locked, `^q` quit).
  - **Pane (`Ctrl+p`)**: `h`/`j`/`k`/`l` (move focus), `n` (new pane), `d` (split down), `r` (split right), `x` (close), `f` (fullscreen), `w` (floating), `c` (rename).
  - **Tab (`Ctrl+t`)**: `h`/`l` (prev/next), `1`–`9` (direct tab switch), `n` (new tab), `x` (close tab), `r` (rename), `s` (sync).
  - **Scrollback & Search (`Ctrl+s`)**:
    - `j` / `k`: scroll down/up line-by-line; `d` / `u`: half-page down/up.
    - **`e` (`EditScrollback`)**: immediately dumps pane scrollback into **Neovim** (`$EDITOR`) for navigation, regex search, and block copying (`"+y`).
    - **`/` or `s`**: enters regex search mode (`n`/`p` for next/prev, `c` case-sensitivity, `w` wrap).
    - `q` / `Esc` / `Ctrl+c`: return to Normal mode at scroll bottom.
  - **Session (`Ctrl+o`)**: `d` (detach), `w` (session manager), `f`/`s` (sessionizer), `q` (quit).

- **Global Fast Keybindings (`shared_except "locked"`)**:
  - **Tabs**: `Alt+1` .. `Alt+9` (jump directly to tabs 1–9), `Alt+t` (new tab).
  - **Panes**:
    - `Alt+h` / `Alt+j` / `Alt+k` / `Alt+l`: move focus across panes/tabs.
    - `Alt+n`: new pane; `Alt+d`: split down; `Alt+r`: split right.
    - `Alt+x`: close focused pane; `Alt+w`: toggle floating; `Alt+z`: toggle fullscreen.
    - `Alt+=` / `Alt+-`: resize increase/decrease.
  - **Layouts**: `Alt+[` / `Alt+]`: cycle swap layouts (vertical, horizontal, stacked, floating).
  - **Sessionizer & Manager**: `Alt+f` (sessionizer popup), `Alt+s` (session manager).

### 4. Layouts (`zjstatus` & Swap Layouts)

Preconfigured layouts in `~/.config/zellij/layouts/`:
- **`default`**: full layout with active mode indicator, tabs with status icons (fullscreen, sync, floating), session name, and complete swap layouts (`Alt+[` / `Alt+]`).
- **`compact`**: streamlined single-line status bar.
- **`dev`**: development layout with main editor pane (70% width) and vertical side stack with two terminals (30% width).

### 5. Theming (Stylix & zjstatus)

Zellij, Starship, and Nushell are configured with automatic **Stylix** theming:
- Colors in `zjstatus` dynamically inherit from `config.lib.stylix.colors.withHashtag` (base00–base0F), with a monochrome fallback when Stylix is inactive.
- Zellij theme is set to `default` matching the Stylix-generated theme block.
- Automatically updates with `theme-set light` / `theme-set dark` and scheduled system timers.

## Project Management (`projects` module)

The `projects` module declaratively ensures project directories exist in `$HOME/` and clones work/personal repositories on Home Manager activation:

### Configuration (`secrets/projects.yml`)

Projects and their repositories are declared in `secrets/projects.yml`:

```yaml
- project_name:
    - git@wb:project_name.git
```

### SOPS Secrets Integration

`sops.secrets."projects.yml"` is declared directly in `modules/projects.nix`:
```nix
sops.secrets."projects.yml" = {
  sopsFile = ../secrets/projects.yml;
};
```
When encrypted with SOPS (`sops -e -i secrets/projects.yml`), `sops-nix` decrypts the file at runtime and `projects.nix` reads the decrypted path from `config.sops.secrets."projects.yml".path`.

### How it works

1. Standard Home Manager activation hook (`home.activation.cloneProjects`) runs on `home-manager switch`.
2. Evaluates declared projects in `zsh` directly within the activation hook.
3. For each declared project (e.g. `personal`, `work`), creates the folder in `$HOME/` (if it doesn't already exist).
4. Clones any missing repository via `git clone`.
5. Repositories that are already cloned are safely skipped without errors.


