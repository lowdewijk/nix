{globals, ...}: {
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
    ./yazi/yazi.nix
    ./udiskie.nix
    ./xdg-mimeapps.nix
    ./niri/niri.nix
    ./neovim/neovim.nix
    ./catppuccin.nix
    ./mpv.nix
    ./noctalia/noctalia.nix
    ./firefox.nix
    ./nushell.nix
    ./zoxide.nix
    ./carapace.nix
  ];

  # never change this
  home.stateVersion = "24.05";
}
