{
  config,
  globals,
  inputs,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };
  home.file.".config/noctalia/config.toml".source = mkGitSymlink "/home/noctalia/noctalia-config.toml";
  home.file.".config/noctalia/udiskie.toml".text = ''
    [plugins]
    enabled = ["aristides/udiskie"]

    [[plugins.source]]
    name = "nix-community-plugins"
    kind = "path"
    location = "${inputs."noctalia-community-plugins"}"

    [plugin_settings."aristides/udiskie"]
    enable_notifications = false
  '';
}
