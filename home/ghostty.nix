{pkgs, ...}: let
  font = "Hack Nerd Font";
  palette = import ./catppuccin-mocha-palette.nix;
in {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "font-family" = font;
      "font-size" = 10;

      "window-decoration" = "none";
      "window-theme" = "ghostty";
      "confirm-close-surface" = false;

      command = "direct:${pkgs.zsh}/bin/zsh --login";
      "shell-integration" = "zsh";

      background = palette.base;
      foreground = palette.text;
      "cursor-color" = palette.rosewater;
      "selection-background" = palette.rosewater;
      "selection-foreground" = palette.base;

      palette = [
        "0=${palette.surface1}"
        "1=${palette.red}"
        "2=${palette.green}"
        "3=${palette.yellow}"
        "4=${palette.blue}"
        "5=${palette.pink}"
        "6=${palette.teal}"
        "7=${palette.subtext1}"
        "8=${palette.surface2}"
        "9=${palette.red}"
        "10=${palette.green}"
        "11=${palette.yellow}"
        "12=${palette.blue}"
        "13=${palette.pink}"
        "14=${palette.teal}"
        "15=${palette.subtext0}"
      ];

      keybind = [
        "ctrl+shift+equal=increase_font_size:1"
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+zero=reset_font_size"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
      ];
    };
  };
}
