{ pkgs, ...}:
let 
  desktopPackages = with pkgs; [
    firefox
    zotero
    gimp
  ];
  shellPackages = with pkgs; [
    git
    gcc
    neovim
    wget
    direnv

    firefox
    whatsapp-for-linux

    neofetch
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
in { 
  environment.systemPackages = shellPackages ++ desktopPackages;
}
