{globals, ...}: {
  home.username = globals.username;
  home.homeDirectory = "/home/${globals.username}";
  catppuccin.flavor = "mocha";

  imports = [
    ./kitty.nix
    ./ssh.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./direnv.nix
    ./bat.nix
    ./fzf.nix
    ./fonts.nix
    ./plasma.nix
    ./aichat.nix
    ./neovim
  ];

  # never change this
  home.stateVersion = "24.05";
}
