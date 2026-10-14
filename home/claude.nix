{
  config,
  globals,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  home.file.".claude/settings.json".source = mkGitSymlink "/home/claude/settings.json";
}
