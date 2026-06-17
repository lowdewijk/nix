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
  ghosttyYaziHere = pkgs.writeShellScriptBin "ghostty-yazi-here" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    niri_bin=${pkgs.niri}/bin/niri
    ghostty_bin=${pkgs.ghostty}/bin/ghostty
    jq_bin=${pkgs.jq}/bin/jq
    pgrep_bin=${pkgs.procps}/bin/pgrep
    readlink_bin=${pkgs.coreutils}/bin/readlink
    self_pid="$$"

    find_deepest_cwd() {
      local root_pid="$1"
      local -a queue=("$root_pid")
      local -a ordered=()
      local index=0
      local current_pid=""
      local child_pid=""
      local cwd=""

      while [ "$index" -lt "''${#queue[@]}" ]; do
        current_pid="''${queue[$index]}"
        index=$((index + 1))

        [ -n "$current_pid" ] || continue
        [ "$current_pid" = "$self_pid" ] && continue

        ordered+=("$current_pid")

        while IFS= read -r child_pid; do
          [ -n "$child_pid" ] || continue
          [ "$child_pid" = "$self_pid" ] && continue
          queue+=("$child_pid")
        done < <("$pgrep_bin" -P "$current_pid" || true)
      done

      for ((index = ''${#ordered[@]} - 1; index >= 0; index--)); do
        current_pid="''${ordered[$index]}"
        if [ -L "/proc/$current_pid/cwd" ]; then
          cwd="$("$readlink_bin" -f "/proc/$current_pid/cwd" 2>/dev/null || true)"
          if [ -n "$cwd" ] && [ -d "$cwd" ]; then
            printf '%s\n' "$cwd"
            return 0
          fi
        fi
      done

      return 1
    }

    focused_window="$("$niri_bin" msg -j focused-window 2>/dev/null || true)"
    if [ -z "$focused_window" ]; then
      exec "$ghostty_bin" -e yazi
    fi

    app_id="$(printf '%s' "$focused_window" | "$jq_bin" -r '.app_id // empty')"
    pid="$(printf '%s' "$focused_window" | "$jq_bin" -r '.pid // empty')"

    if [ "$app_id" != "com.mitchellh.ghostty" ] || [ -z "$pid" ]; then
      exec "$ghostty_bin" -e yazi
    fi

    cwd="$(find_deepest_cwd "$pid" || true)"
    if [ -n "$cwd" ] && [ -d "$cwd" ]; then
      exec "$ghostty_bin" +new-window --working-directory="$cwd" -e yazi
    fi

    exec "$ghostty_bin" -e yazi
  '';
in {
  home.packages = with pkgs; [
    start1password
    killWorkspace
    nameWorkspace
    ghosttyYaziHere
    wl-clipboard
  ];

  home.file.".config/niri/config.kdl".source = mkGitSymlink "/home/niri/niri-config.kdl";
  home.file.".config/waybar/config.jsonc".source = mkGitSymlink "/home/niri/waybar-config.jsonc";
  home.file.".config/waybar/style.css".source = mkGitSymlink "/home/niri/waybar-style.css";
}
