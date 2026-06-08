{
  pkgs,
  globals,
  config,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");
  start1password = pkgs.writeShellScriptBin "niri-start-1password" ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.util-linux}/bin/setsid ${pkgs._1password-gui}/bin/1password --silent >/dev/null 2>&1
  '';
  killWorkspace = pkgs.writeShellScriptBin "niri-kill-workspace" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    niri_bin=${pkgs.niri}/bin/niri
    jq_bin=${pkgs.jq}/bin/jq

    workspace_id="$("$niri_bin" msg -j workspaces | "$jq_bin" -r '.[] | select(.is_focused) | .id' | head -n1)"
    if [ -z "$workspace_id" ] || [ "$workspace_id" = "null" ]; then
      exit 0
    fi

    while true; do
      window_id="$(
        "$niri_bin" msg -j windows \
          | "$jq_bin" -r --argjson workspace_id "$workspace_id" \
            '.[] | select(.workspace_id == $workspace_id) | .id' \
          | head -n1
      )"

      if [ -z "$window_id" ] || [ "$window_id" = "null" ]; then
        break
      fi

      "$niri_bin" msg action focus-window --id "$window_id"
      "$niri_bin" msg action close-window
    done

    "$niri_bin" msg action unset-workspace-name
  '';
  nameWorkspace = pkgs.writeShellScriptBin "niri-name-workspace" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    niri_bin=${pkgs.niri}/bin/niri
    jq_bin=${pkgs.jq}/bin/jq
    zenity_bin=${pkgs.zenity}/bin/zenity

    current_name="$(
      "$niri_bin" msg -j workspaces \
        | "$jq_bin" -r '.[] | select(.is_focused) | .name // ""' \
        | head -n1
    )"

    new_name="$(
      "$zenity_bin" --entry \
        --title="Name Workspace" \
        --text="Workspace name:" \
        --entry-text="$current_name"
    )"

    if [ -z "$new_name" ]; then
      exit 0
    fi

    "$niri_bin" msg action set-workspace-name "$new_name"
  '';
in {
  home.packages = with pkgs; [
    start1password
    killWorkspace
    nameWorkspace
  ];

  home.file.".config/niri/config.kdl".source = mkGitSymlink "/home/niri/config.kdl";
  home.file.".config/waybar/config.jsonc".source = mkGitSymlink "/home/niri/waybar-config.jsonc";
  home.file.".config/waybar/style.css".source = mkGitSymlink "/home/niri/waybar-style.css";
}
