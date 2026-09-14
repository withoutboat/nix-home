{ topBarPlugin, bottomBarPlugin }:
let
  swapLayouts = ''
    swap_tiled_layout name="vertical" {
        tab {
            pane split_direction="vertical" {
                children
            }
        }
    }
    swap_tiled_layout name="horizontal" {
        tab {
            pane split_direction="horizontal" {
                children
            }
        }
    }
    swap_tiled_layout name="stacked" {
        tab {
            pane stacked=true {
                children
            }
        }
    }
    swap_floating_layout name="staggered" {
        floating_panes
    }
    swap_floating_layout name="enlarged" {
        floating_panes max_panes=10 {
            pane { x "5%"; y 1; width "90%"; height "90%"; }
            pane { x "5%"; y 2; width "90%"; height "90%"; }
            pane { x "5%"; y 3; width "90%"; height "90%"; }
            pane { x "5%"; y 4; width "90%"; height "90%"; }
            pane { x "5%"; y 5; width "90%"; height "90%"; }
            pane { x "5%"; y 6; width "90%"; height "90%"; }
            pane { x "5%"; y 7; width "90%"; height "90%"; }
            pane { x "5%"; y 8; width "90%"; height "90%"; }
            pane { x "5%"; y 9; width "90%"; height "90%"; }
            pane focus=true { x 10; y 10; width "90%"; height "90%"; }
        }
    }
    swap_floating_layout name="spread" {
        floating_panes max_panes=1 {
            pane { y "50%"; x "50%"; }
        }
        floating_panes max_panes=2 {
            pane { x "1%"; y "25%"; width "45%"; }
            pane { x "50%"; y "25%"; width "45%"; }
        }
        floating_panes max_panes=3 {
            pane focus=true { y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; }
            pane { x "50%"; y "1%"; width "45%"; }
        }
        floating_panes max_panes=4 {
            pane { x "1%"; y "55%"; width "45%"; height "45%"; }
            pane focus=true { x "50%"; y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; }
            pane { x "50%"; y "1%"; width "45%"; }
        }
    }
  '';
in
{
  default = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                ${topBarPlugin}
            }
            children
            pane size=1 borderless=true {
                ${bottomBarPlugin}
            }
        }
        ${swapLayouts}
    }
  '';
  compact = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                ${topBarPlugin}
            }
            children
            pane size=1 borderless=true {
                ${bottomBarPlugin}
            }
        }
        ${swapLayouts}
    }
  '';
  dev = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                ${topBarPlugin}
            }
            children
            pane size=1 borderless=true {
                ${bottomBarPlugin}
            }
        }
        tab name="dev" focus=true {
            pane split_direction="vertical" {
                pane size="70%" name="editor"
                pane size="30%" split_direction="horizontal" {
                    pane name="terminal"
                    pane name="secondary"
                }
            }
        }
        ${swapLayouts}
    }
  '';
}
