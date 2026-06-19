{
  pkgs,
  globals,
  config,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = true;
  };

  home.file.".config/yazi/yazi.toml".source = mkGitSymlink "/home/yazi/yazi-config.toml";
  home.file.".config/yazi/keymap.toml".source = mkGitSymlink "/home/yazi/keymap.toml";

  home.packages = with pkgs; [
    ffmpegthumbnailer
    unar
    poppler
    jq
    file
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    chafa
    mediainfo
    mpv
    wl-clipboard
  ];
}
