{
  globals,
  ...
}: {
  home.username = globals.username;
  home.homeDirectory = "/home/${globals.username}";

  imports = [
    ./google-drive.nix
    ./kitty.nix
    ./ghostty.nix
    ./ssh.nix
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./codex/codex.nix
    ./direnv.nix
    ./bat.nix
    ./desktop-entries.nix
    ./fzf.nix
    ./yazi.nix
    ./xdg-mimeapps.nix
    ./fonts.nix
    ./niri/nix.nix
    ./neovim/neovim.nix
    ./catppuccin.nix
    ./mpv.nix
    ./noctalia.nix
    ./firefox.nix
  ];

  # never change this
  home.stateVersion = "24.05";
}
