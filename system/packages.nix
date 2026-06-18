{pkgs, ...}: let
  zapzap = pkgs.symlinkJoin {
    name = "zapzap-wayland";
    paths = [pkgs.zapzap];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/zapzap" \
        --set-default QT_QPA_PLATFORM "wayland;xcb"
    '';
  };

  desktopPackages = with pkgs; [
    kitty
    alacritty
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
    scribus
  ];
  shellPackages = with pkgs; [
    dnslookup
    dig
    neovim
    git
    wget
    eza
    devenv
    fd # used by telescope
    ffmpeg
    rclone
    sshfs # mount ssh disks
    nethogs # see what's eating up bandwidth
    htop # better top
    colordiff # better diff
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    httpie # execute rest commands on the command line
    videoduplicatefinder-cli
    file
    which
    ncdu # inspect diskspace
    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    pciutils # for inspecting hardware
    lsof # list open files
    calc # calculate on the command line
    bc # more calcuate on the command line tooling
    # archives
    zip
    xz
    unzip
    unrar
    p7zip
    slack
    trash-cli
  ];
in {
  environment.systemPackages = shellPackages ++ desktopPackages;
}
