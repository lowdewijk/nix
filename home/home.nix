{ config, pkgs, catppuccin, ... }:
{
  # update this if you are not me
  home.username = "lowdewijk"; 
  home.homeDirectory = "/home/lowdewijk";

  imports = [
    ./packages.nix
    ./extra-dotfiles.nix
    ./ssh.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./bat.nix
    ./fzf.nix
    ./fonts.nix
  ];

  catppuccin.flavor = "mocha";

  programs.home-manager = {
    enable = true;
  };

  # never change this
  home.stateVersion = "24.05";
}
