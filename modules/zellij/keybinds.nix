''
plugins {
    welcome-screen location="zellij:session-manager" {
        welcome_screen false
    }
}

keybinds {
    normal {
        bind "Ctrl f" {
            Run "zellij-sessionizer" {
                floating true
                close_on_exit true
                x "20%"
                y "20%"
                width "60%"
                height "60%"
            }
        }
    }
    session {
        bind "f" "s" "Ctrl f" {
            Run "zellij-sessionizer" {
                floating true
                close_on_exit true
                x "20%"
                y "20%"
                width "60%"
                height "60%"
            }
            SwitchToMode "Normal"
        }
    }
    tmux {
        bind "f" {
            Run "zellij-sessionizer" {
                floating true
                close_on_exit true
                x "20%"
                y "20%"
                width "60%"
                height "60%"
            }
            SwitchToMode "Normal"
        }
    }
    scroll {
        bind "e" { EditScrollback; SwitchToMode "Normal"; }
        bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
        bind "G" { ScrollToBottom; }
        bind "q" { ScrollToBottom; SwitchToMode "Normal"; }
    }
    search {
        bind "q" { ScrollToBottom; SwitchToMode "Normal"; }
    }
    tab {
        bind "1" { GoToTab 1; SwitchToMode "Normal"; }
        bind "2" { GoToTab 2; SwitchToMode "Normal"; }
        bind "3" { GoToTab 3; SwitchToMode "Normal"; }
        bind "4" { GoToTab 4; SwitchToMode "Normal"; }
        bind "5" { GoToTab 5; SwitchToMode "Normal"; }
        bind "6" { GoToTab 6; SwitchToMode "Normal"; }
        bind "7" { GoToTab 7; SwitchToMode "Normal"; }
        bind "8" { GoToTab 8; SwitchToMode "Normal"; }
        bind "9" { GoToTab 9; SwitchToMode "Normal"; }
    }
    shared_except "locked" {
        bind "Alt s" {
            LaunchOrFocusPlugin "session-manager" {
                floating true
                move_to_focused_tab true
            }
        }
        bind "Alt f" {
            Run "zellij-sessionizer" {
                floating true
                close_on_exit true
                x "20%"
                y "20%"
                width "60%"
                height "60%"
            }
        }
        bind "Alt t" { NewTab; }
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }
        bind "Alt 6" { GoToTab 6; }
        bind "Alt 7" { GoToTab 7; }
        bind "Alt 8" { GoToTab 8; }
        bind "Alt 9" { GoToTab 9; }

        bind "Alt h" { MoveFocusOrTab "Left"; }
        bind "Alt l" { MoveFocusOrTab "Right"; }
        bind "Alt j" { MoveFocus "Down"; }
        bind "Alt k" { MoveFocus "Up"; }

        bind "Alt d" { NewPane "Down"; }
        bind "Alt r" { NewPane "Right"; }
        bind "Alt n" { NewPane; }
        bind "Alt x" { CloseFocus; }
        bind "Alt w" { ToggleFloatingPanes; }
        bind "Alt z" { ToggleFocusFullscreen; }
        bind "Alt =" "Alt +" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt [" { PreviousSwapLayout; }
        bind "Alt ]" { NextSwapLayout; }
    }
}
''
