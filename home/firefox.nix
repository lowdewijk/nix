{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.pywalfox-native];

  home.activation.installPywalfoxManifest = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${lib.getExe pkgs.pywalfox-native} install
  '';

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";
    policies = {
      ExtensionSettings = {
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        "pywalfox@frewacom.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}/latest.xpi";
          installation_mode = "force_installed";
        };
        "everhour@everhour.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/everhour/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
