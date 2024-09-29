{ config, pkgs, nixpkgs-unstable, ... }:

{
  imports = [
    ./kitty.nix
    ./ssh.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./bat.nix
    ./fzf.nix
    ./fonts.nix
    ./plasma.nix
    ./aichat.nix
    ./neovim
  ];

  home.username = "lobo";
  home.homeDirectory = "/home/lobo";

  catppuccin.flavor = "mocha";

  # never change this
  home.stateVersion = "24.05";
}
