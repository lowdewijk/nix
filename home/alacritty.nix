{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      font = {
        normal.family = "Hack Nerd Font";
        size = 11;
      };

      window = {
        decorations = "None";
        dynamic_title = true;
      };

      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = ["--login"];
      };

      mouse.hide_when_typing = true;

      selection.save_to_clipboard = true;

      keyboard.bindings = [
        {
          key = "Space";
          mods = "Control";
          action = "ToggleViMode";
        }
      ];

      hints.enabled = [
        {
          command = "${pkgs.xdg-utils}/bin/xdg-open";
          hyperlinks = true;
          post_processing = true;
          persist = false;
          mouse = {
            enabled = true;
            mods = "None";
          };
          binding = {
            key = "H";
            mods = "Control|Shift";
          };
        }
      ];

      colors = {
        primary = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        cursor = {
          cursor = "#F5E0DC";
          text = "#1E1E2E";
        };

        selection = {
          background = "#F5E0DC";
          text = "#1E1E2E";
        };

        normal = {
          black = "#45475A";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#BAC2DE";
        };

        bright = {
          black = "#585B70";
          red = "#F38BA8";
          green = "#A6E3A1";
          yellow = "#F9E2AF";
          blue = "#89B4FA";
          magenta = "#F5C2E7";
          cyan = "#94E2D5";
          white = "#A6ADC8";
        };
      };
    };
  };
}
