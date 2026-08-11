{
  config,
  globals,
  pkgs,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  home.packages = [
    pkgs.llm-agents.codex
    pkgs.llm-agents.codex-acp
  ];

  home.file.".codex/config.toml".source = mkGitSymlink "/home/codex/codex-config.toml";
}
