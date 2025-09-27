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
    aichat # prompt LLM on the command line
    devenv
    fd # used by telescope
    neofetch
    ffmpeg
    sshfs # mount ssh disks
    nethogs # see what's eating up bandwidth
    htop # better top
    colordiff # better diff
    git-repo-sync
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    httpie # execute rest commands on the command line
    file
    which
    ncdu # inspect diskspace
    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    pciutils # for inspecting hardware
    glxinfo # for checking whether X-server is running hardware or software rendering
    lsof # list open files
    calc # calculate on the command line
    # archives
    zip
    xz
    unzip
    p7zip
  ];
in {
  environment.systemPackages = shellPackages ++ desktopPackages;
}
