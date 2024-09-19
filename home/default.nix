{ config, pkgs, nixpkgs-unstable, ... }:

{
  imports = [
    ./extra-dotfiles.nix
    ./ssh
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./bat.nix
    ./fzf.nix
    ./fonts.nix
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
