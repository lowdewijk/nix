let
  skipDirs = ".git,node_modules,.venv,.local,.cache,.rye";
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget.options = ["--layout reverse"];
    tmux.enableShellIntegration = true;

    # CTRL-T opttions
    fileWidget.options = [
      "--walker-skip ${skipDirs}"
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];

    # ALT-C options
    changeDirWidget.options = [
      "--walker-skip ${skipDirs}"
    ];
  };
}
