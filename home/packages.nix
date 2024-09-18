{ pkgs, ...}:
{
  home.packages = with pkgs; [
    kitty

    wget
    eza
    direnv
    
    # used by neovim
    tree-sitter
    lua5_1
    luarocks

    neofetch
    xsel # used by neovim and tmux
    xclip # used by zsh-system-clipboard
    
    # archives
    zip
    xz
    unzip
    p7zip
    
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    
    # misc
    cowsay
    file
    which
    
    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    
    lsof # list open files
  ];
}
