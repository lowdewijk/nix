{
  config,
  globals,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };
  home.file.".config/noctalia/config.toml".source = mkGitSymlink "/home/noctalia/noctalia-config.toml";
}
