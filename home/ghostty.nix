{pkgs, ...}: let
  font = "Hack Nerd Font";
  palette = import ./catppuccin-mocha-palette.nix;
in {
  # This makes ctrl+shift+[ open Neovim with the current screen
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    exec = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.neovim}/bin/nvim %f";
    mimeType = [
      "text/plain"
      "text/markdown"
      "text/x-c"
      "text/x-c++"
      "text/x-chdr"
      "text/x-c++hdr"
      "text/x-java"
      "text/x-python"
      "text/x-rust"
      "text/x-script.python"
      "text/x-script.shell"
      "text/x-shellscript"
      "text/x-lua"
      "text/x-nix"
      "text/x-toml"
      "text/x-yaml"
      "text/x-log"
      "application/json"
      "application/toml"
      "application/x-yaml"
      "application/xml"
      "application/javascript"
      "application/x-sh"
    ];
    terminal = false;
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    clearDefaultKeybinds = true;

    settings = {
      "font-family" = font;
      "font-size" = 10;

      "window-decoration" = "none";
      "window-theme" = "ghostty";
      "confirm-close-surface" = false;
      "window-inherit-working-directory" = true;

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
        "ctrl+shift+[=write_screen_file:open,plain"
      ];
    };
  };
}
