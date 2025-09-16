let
  skipDirs = ".git,node_modules,.venv,.local,.cache,.rye";
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidgetOptions = [
      "--layout reverse"
    ];
    tmux.enableShellIntegration = true;

    # CTRL-T opttions
    fileWidgetOptions = [
      "--walker-skip ${skipDirs}"
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];

    # ALT-C options
    changeDirWidgetOptions = [
      "--walker-skip ${skipDirs}"
    ];
  };
}
