{
  pkgs,
  git-repo-sync,
  ...
}: let
  desktopPackages = with pkgs; [
    kitty
    firefox
    zotero
    gimp
    zapzap
    vlc
    mattermost-desktop
    todoist-electron
    discord
    chromium
    spotify
    signal-desktop
    zed-editor
  ];
  shellPackages = with pkgs; [
    neovim
    git
    wget
    eza
    aichat
    devenv
    fd # used by telescope
    neofetch
    ffmpeg
    sshfs

    git-repo-sync

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    httpie # execute rest commands on the command line

    # misc
    file
    which
    ncdu # inspect diskspace

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    pciutils # for inspecting hardware
    glxinfo # for checking whether X-server is running hardware or software rendering

    lsof # list open files
  ];
in {
  environment.systemPackages = shellPackages ++ desktopPackages;
}
