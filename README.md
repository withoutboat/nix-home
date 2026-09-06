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

## Управление сессиями (Zellij & Sessionizer)

Конфигурация включает полноценный стек сессионизации, заменяющий `tmux-sessionizer` и связку tmux:

### 1. Zellij Sessionizer (`zellij-sessionizer` / `zs` / `Ctrl+f`)

Скрипт быстрого поиска проектов и сессий через `fzf`:

- **Быстрый вызов**: нажать `Ctrl+f` в Zsh или запустить `zs` / `zellij-sessionizer`.
- **Поиск**: сканирует рабочие каталоги (`~/hiplabs`, `~/personal`, `~/nix-core`, `~/nix-home`, `~/.dotfiles` и др.).
- **Поведение вне Zellij**: подключается к существующей сессии или создаёт новую с именем проекта и переходом в целевую директорию (`zellij attach -c <project>`).
- **Поведение внутри Zellij**: открывает новую вкладку с именем проекта в выбранном каталоге (`zellij action new-tab --cwd ...`).

### 2. Встроенный Session Manager (плавающее окно)

- **`Alt+s`** (из любого режима) или **`Ctrl+o` → `w`**: открывает плавающее окно менеджера сессий Zellij.
- Интерактивный поиск и мгновенное переключение между запущенными сессиями без закрытия терминала.
- Воскрешение (resurrect) закрытых сессий с сохранением лейаутов и запущенных утилит.
- Создание новых изолированных сессий и переименование текущих.

### 3. Быстрые хоткеи Zellij

- **`Ctrl+o` → `d`**: отключиться от сессии (detach), сессия продолжит работать в фоне.
- **`Alt+s`**: переключить/выбрать сессию через плавающий session-manager.
- **`Ctrl+t` → `n`**: создать новую вкладку (tab).
- **`Ctrl+p` → `n`**: создать новый сплит/панель (pane).
- **`Ctrl+p` → `w`**: плавающий режим текущей панели (floating toggle).
- **`Ctrl+q`**: закрыть текущую панель.
- **`Ctrl+o` → `q`**: закрыть сессию целиком.

### 4. Темы оформления (Stylix)

Модули Zellij, Starship и Nushell автоматически интегрированы со **Stylix**:
- Цветовые палитры генерируются автоматически (Catppuccin Mocha / Catppuccin Latte).
- Поддерживается бесшовное переключение через `theme-set light` / `theme-set dark` и системные таймеры.

