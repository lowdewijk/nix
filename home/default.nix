{ config, pkgs, nixpkgs-unstable, ... }:

{
  imports = [
    ./extra-dotfiles.nix
    ./ssh.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./bat.nix
    ./fzf.nix
    ./fonts.nix
    ./plasma.nix
  ];

  home.username = "lobo";
  home.homeDirectory = "/home/lobo";

  catppuccin.flavor = "mocha";

  # never change this
  home.stateVersion = "24.05";
}
