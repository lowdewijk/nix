{
  pkgs,
  globals,
  config,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  home.packages = with pkgs; [
    waybar
    rofi
  ];

  home.file.".config/niri/config.kdl".source = mkGitSymlink "/home/niri/config.kdl";
  home.file.".config/waybar/config.jsonc".source = mkGitSymlink "/home/niri/waybar-config.jsonc";
  home.file.".config/waybar/style.css".source = mkGitSymlink "/home/niri/waybar-style.css";
  home.file.".config/rofi/config.rasi".source = mkGitSymlink "/home/niri/rofi-config.rasi";
}
