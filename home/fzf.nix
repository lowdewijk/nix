{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidgetOptions = [
      "--layout reverse"
    ];
    catppuccin.enable = true;
    tmux.enableShellIntegration = true;
    fileWidgetOptions = [
      "--walker-skip .git,node_modules,.venv,.local,.cache,.rye"
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];
  };
}
