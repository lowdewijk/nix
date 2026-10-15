{
  config,
  globals,
  inputs,
  pkgs,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
in {
  home.packages = [
    inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.llm-agents.codex-acp
  ];

  home.file.".codex/config.toml".source = mkGitSymlink "/home/codex/codex-config.toml";
}
