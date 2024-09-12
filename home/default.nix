{ config, pkgs, nixpkgs-unstable, ... }:

{
  imports = [
    ./ssh.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./kitty.nix
    ./neovim
    ./tmux.nix
    ./bat.nix
    ./fzf.nix
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
  ];

  home.username = "lobo";
  home.homeDirectory = "/home/lobo";

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  catppuccin.flavor = "mocha";

  # never change this
  home.stateVersion = "24.05";
}
