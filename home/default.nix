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

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    firefox
    neofetch
    nnn # terminal file manager
    xsel

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’

    # misc
    cowsay
    file
    which

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    lsof # list open files

    # system tools
    sysstat
  ];


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
