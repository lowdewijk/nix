{ pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    terminal = "xterm-256color";
    escapeTime = 0;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      catppuccin
    ];
    extraConfig = ''
      # Allow scrolling with mouse in panes
      set-option -g mouse on
    '';
  };
}
