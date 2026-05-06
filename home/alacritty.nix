{
  pkgs,
  config,
  ...
}: let
  font = "Hack Nerd Font";
  palette = import ./catppuccin-mocha-palette.nix;
in {
  home.packages = [
    pkgs.alacritty.terminfo
  ];
  home.sessionVariables.TERMINFO_DIRS = "${config.home.homeDirectory}/.nix-profile/share/terminfo";
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = font;
          style = "Regular";
        };
        bold = {
          family = font;
          style = "Bold";
        };
        italic = {
          family = font;
          style = "Italic";
        };
        bold_italic = {
          family = font;
          style = "Bold Italic";
        };
        size = 10.0;
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
          background = palette.base;
          foreground = palette.text;
        };

        cursor = {
          cursor = palette.rosewater;
          text = palette.base;
        };

        selection = {
          background = palette.rosewater;
          text = palette.base;
        };

        normal = {
          black = palette.surface1;
          red = palette.red;
          green = palette.green;
          yellow = palette.yellow;
          blue = palette.blue;
          magenta = palette.pink;
          cyan = palette.teal;
          white = palette.subtext1;
        };

        bright = {
          black = palette.surface2;
          red = palette.red;
          green = palette.green;
          yellow = palette.yellow;
          blue = palette.blue;
          magenta = palette.pink;
          cyan = palette.teal;
          white = palette.subtext0;
        };
      };
    };
  };
}
