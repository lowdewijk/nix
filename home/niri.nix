{
  pkgs,
  globals,
  config,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");

  # Starts Ghostty with the current Ghostty CWD (if the current window is Ghostty)
  ghosttyHere = pkgs.writeShellScriptBin "niri-ghostty-here" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    niri_bin=${pkgs.niri}/bin/niri
    ghostty_bin=${pkgs.ghostty}/bin/ghostty
    jq_bin=${pkgs.jq}/bin/jq
    pgrep_bin=${pkgs.procps}/bin/pgrep
    readlink_bin=${pkgs.coreutils}/bin/readlink
    self_pid="$$"
    args=("$@")

    find_deepest_cwd() {
      local root_pid="$1"
      local -a queue=("$root_pid")
      local -a ordered=()
      local index=0
      local current_pid=""
      local child=""

      while [ "$index" -lt "''${#queue[@]}" ]; do
        current_pid="''${queue[$index]}"
        index=$((index + 1))

        [ -n "$current_pid" ] || continue
        [ "$current_pid" = "$self_pid" ] && continue

        ordered+=("$current_pid")

        while IFS= read -r child; do
          [ -n "$child" ] || continue
          [ "$child" = "$self_pid" ] && continue
          queue+=("$child")
        done < <("$pgrep_bin" -P "$current_pid" || true)
      done

      for ((index = ''${#ordered[@]} - 1; index >= 0; index--)); do
        current_pid="''${ordered[$index]}"
        if [ -L "/proc/$current_pid/cwd" ]; then
          child="$("$readlink_bin" -f "/proc/$current_pid/cwd" 2>/dev/null || true)"
          if [ -n "$child" ] && [ -d "$child" ]; then
            printf '%s\n' "$child"
            return 0
          fi
        fi
      done

      return 1
    }

    focused_window="$("$niri_bin" msg -j focused-window 2>/dev/null || true)"
    if [ -z "$focused_window" ]; then
      exec "$ghostty_bin" "''${args[@]}"
    fi

    app_id="$(printf '%s' "$focused_window" | "$jq_bin" -r '.app_id // ."app-id" // .appId // empty')"
    pid="$(printf '%s' "$focused_window" | "$jq_bin" -r '.pid // empty')"

    if [ "$app_id" != "com.mitchellh.ghostty" ] || [ -z "$pid" ]; then
      exec "$ghostty_bin" "''${args[@]}"
    fi

    cwd="$(find_deepest_cwd "$pid")"
    if [ -n "$cwd" ] && [ -d "$cwd" ]; then
      exec "$ghostty_bin" +new-window --working-directory="$cwd" "''${args[@]}"
    fi

    exec "$ghostty_bin" "''${args[@]}"
  '';
  start1password = pkgs.writeShellScriptBin "niri-start-1password" ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.util-linux}/bin/setsid ${pkgs._1password-gui}/bin/1password --silent >/dev/null 2>&1
  '';
in {
  home.packages = with pkgs; [
    ghosttyHere
    start1password
  ];

  home.file.".config/niri/config.kdl".source = mkGitSymlink "/home/niri/config.kdl";
  home.file.".config/waybar/config.jsonc".source = mkGitSymlink "/home/niri/waybar-config.jsonc";
  home.file.".config/waybar/style.css".source = mkGitSymlink "/home/niri/waybar-style.css";
}
