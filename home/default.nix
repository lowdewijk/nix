{globals, ...}: {
  home.username = globals.username;
  home.homeDirectory = "/home/${globals.username}";

  imports = [
    ./google-drive.nix
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
    ./niri.nix
    ./aichat.nix
    ./neovim
    ./fonts.nix
    ./catppuccin.nix
    ./mpv.nix
  ];

  # never change this
  home.stateVersion = "24.05";
}
