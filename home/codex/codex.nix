{pkgs, ...}: let
  codexPackages = import ./codex-packages.nix {inherit pkgs;};
in {
  home.packages = [
    codexPackages.codex
    codexPackages.codex-acp
  ];
}
