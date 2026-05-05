{
  pkgs,
  globals,
  config,
  ...
}: let
  mkGitSymlink = gitPath: config.lib.file.mkOutOfStoreSymlink (/. + "${globals.nixos_git_root}/${gitPath}");

  # Starts Alacritty with the current Alacritty CWD (if the current window is Alacritty)
  alacrittyHere = pkgs.writeShellScriptBin "niri-alacritty-here" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    niri_bin=${pkgs.niri}/bin/niri
    alacritty_bin=${pkgs.alacritty}/bin/alacritty
    jq_bin=${pkgs.jq}/bin/jq
    pgrep_bin=${pkgs.procps}/bin/pgrep
    readlink_bin=${pkgs.coreutils}/bin/readlink

    find_deepest_cwd() {
      local pid="$1"
      local best=""
      local child=""

      while IFS= read -r child; do
        [ -n "$child" ] || continue
        local candidate=""
        candidate="$(find_deepest_cwd "$child")"
        if [ -n "$candidate" ]; then
          best="$candidate"
        fi
      done < <("$pgrep_bin" -P "$pid" || true)

      if [ -n "$best" ]; then
        printf '%s\n' "$best"
        return 0
      fi

      if [ -L "/proc/$pid/cwd" ]; then
        "$readlink_bin" -f "/proc/$pid/cwd" 2>/dev/null || true
      fi
    }

    focused_window="$("$niri_bin" msg -j focused-window 2>/dev/null || true)"
    if [ -z "$focused_window" ]; then
      exec "$alacritty_bin"
    fi

    app_id="$(printf '%s' "$focused_window" | "$jq_bin" -r '.app_id // ."app-id" // .appId // empty')"
    pid="$(printf '%s' "$focused_window" | "$jq_bin" -r '.pid // empty')"

    if [ "$app_id" != "Alacritty" ] || [ -z "$pid" ]; then
      exec "$alacritty_bin"
    fi

    cwd="$(find_deepest_cwd "$pid")"
    if [ -n "$cwd" ] && [ -d "$cwd" ]; then
      exec "$alacritty_bin" msg create-window --working-directory "$cwd"
    fi

    exec "$alacritty_bin"
  '';
in {
  home.packages = with pkgs; [
    rofi
    alacrittyHere
  ];

  home.file.".config/niri/config.kdl".source = mkGitSymlink "/home/niri/config.kdl";
  home.file.".config/waybar/config.jsonc".source = mkGitSymlink "/home/niri/waybar-config.jsonc";
  home.file.".config/waybar/style.css".source = mkGitSymlink "/home/niri/waybar-style.css";
  home.file.".config/rofi/config.rasi".source = mkGitSymlink "/home/niri/rofi-config.rasi";
}
