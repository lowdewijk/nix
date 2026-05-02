{pkgs, ...}: {
  home.packages = with pkgs; [
    waybar
    rofi
  ];

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "us"
                options "caps:escape,altwin:meta_win"
            }
            numlock
        }

        touchpad {
            tap
            natural-scroll
            click-method "clickfinger"
        }

        focus-follows-mouse
    }

    layout {
        gaps 16
        border {
            width 2
            active-color "#89b4fa"
            inactive-color "#45475a"
        }

        default-column-width { proportion 0.5; }

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
    }

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    spawn-at-startup "waybar"

    binds {
        Mod+Return { spawn "kitty"; }
        Mod+D { spawn "rofi" "-show" "drun"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }
        Mod+F { fullscreen-window; }
        Mod+Space { toggle-column-tabbed-display; }

        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        Mod+Ctrl+H { set-column-width "-10%"; }
        Mod+Ctrl+L { set-column-width "+10%"; }
        Mod+Minus { set-window-height "-10%"; }
        Mod+Equal { set-window-height "+10%"; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
    }
  '';

  xdg.configFile."waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 36,
      "margin-top": 8,
      "margin-left": 12,
      "margin-right": 12,
      "modules-left": ["niri/workspaces", "niri/window"],
      "modules-center": ["clock"],
      "modules-right": ["network", "pulseaudio", "battery", "tray"],
      "clock": {
        "format": "{:%a %d %b  %H:%M}"
      },
      "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
      },
      "network": {
        "format-wifi": "  {essid}",
        "format-ethernet": "󰈀  wired",
        "format-disconnected": "󰖪  offline",
        "tooltip-format": "{ifname} via {gwaddr}"
      },
      "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-muted": " muted",
        "format-icons": {
          "default": ["", "", ""]
        }
      },
      "tray": {
        "spacing": 10
      }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "Hack Nerd Font";
      font-size: 14px;
      min-height: 0;
    }

    window#waybar {
      background: transparent;
      color: #cdd6f4;
    }

    .modules-left,
    .modules-center,
    .modules-right {
      background: rgba(30, 30, 46, 0.92);
      border: 2px solid #45475a;
      border-radius: 14px;
      padding: 0 8px;
    }

    #workspaces button,
    #window,
    #clock,
    #network,
    #pulseaudio,
    #battery,
    #tray {
      padding: 0 10px;
      margin: 6px 2px;
    }

    #workspaces button {
      color: #bac2de;
      border-radius: 10px;
    }

    #workspaces button.active {
      background: #89b4fa;
      color: #1e1e2e;
    }

    #workspaces button:hover {
      background: #313244;
      color: #cdd6f4;
    }

    #clock {
      color: #f9e2af;
    }

    #battery {
      color: #a6e3a1;
    }

    #network {
      color: #89dceb;
    }

    #pulseaudio {
      color: #f5c2e7;
    }
  '';

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      icon-theme: "Papirus-Dark";
      display-drun: "apps";
      display-run: "run";
      display-window: "windows";
      drun-display-format: "{name}";
      font: "Hack Nerd Font 12";
    }

    * {
      bg: #1e1e2e;
      bg-alt: #313244;
      fg: #cdd6f4;
      selected: #89b4fa;
      selected-fg: #1e1e2e;
      urgent: #f38ba8;
      border: #45475a;
    }

    window {
      width: 42%;
      location: north;
      y-offset: 10%;
      border: 2px;
      border-color: @border;
      border-radius: 18px;
      background-color: @bg;
      padding: 18px;
    }

    mainbox {
      spacing: 12px;
      children: [inputbar, listview];
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 12px;
      padding: 10px 14px;
      children: [prompt, entry];
    }

    prompt {
      text-color: @selected;
      margin: 0 10px 0 0;
    }

    entry {
      text-color: @fg;
      placeholder: "Search";
      placeholder-color: #7f849c;
    }

    listview {
      columns: 1;
      lines: 10;
      fixed-height: false;
      scrollbar: false;
      spacing: 6px;
    }

    element {
      padding: 10px 12px;
      border-radius: 12px;
      text-color: @fg;
      background-color: transparent;
    }

    element selected {
      background-color: @selected;
      text-color: @selected-fg;
    }

    element urgent {
      text-color: @urgent;
    }
  '';
}
