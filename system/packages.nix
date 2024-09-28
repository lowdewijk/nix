{ pkgs, ...}:
let 
  desktopPackages = with pkgs; [
    kitty
    firefox
    zotero
    gimp
    whatsapp-for-linux
    vlc
    mattermost-desktop
  ];
  shellPackages = with pkgs; [
    neovim
    git
    wget
    eza
    direnv
    aichat
    matterhorn
    devenv
    fd # used by telescope
    
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

    pciutils # for inspecting hardware
    glxinfo # for checking whether X-server is running hardware or software rendering
    
    lsof # list open files
  ];
in { 
  environment.systemPackages = shellPackages ++ desktopPackages;
}
