{ pkgs, ...}:

let 
  # Got this from https://willhbr.net/2023/02/07/dismissable-popup-shell-in-tmux/
  show_popup = pkgs.writeShellScriptBin "show_popup" ''
    #!/bin/bash
    session="_popup_$(tmux display -p '#S')"

    if ! tmux has -t "$session" 2> /dev/null; then
      session_id="$(tmux new-session -dP -s "$session" -F '#{session_id}' -c $1)"
      tmux set-option -s -t "$session_id" key-table popup
      tmux set-option -s -t "$session_id" status off
      tmux set-option -s -t "$session_id" prefix None
      session="$session_id"
    fi

    exec tmux attach -t "$session" -c $1 > /dev/null
  '';
in {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    terminal = "screen-256color";
    escapeTime = 0;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      catppuccin
    ];
    extraConfig = ''
      # for great colors
      set-option -a terminal-features 'xterm-256color:RGB'
      # set-option -a terminal-overrides 'xterm-256color:Tc'

      # reload config file (change file location to your the tmux.conf you want to use)
      bind r source-file ~/.config/tmux/tmux.conf

      # Allow scrolling with mouse in panes
      set-option -g mouse on

      # Bind new keys for splitting
      unbind %
      unbind '"'
      bind % split-window -v -c "#{pane_current_path}"
      bind '"' split-window -h -c "#{pane_current_path}"

      # Open new window on same path as current pane
      bind c new-window -c "#{pane_current_path}"
      unbind p

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1

      # Popup (toggles on ALT-SHIFT-M)
      # Got this from https://willhbr.net/2023/02/07/dismissable-popup-shell-in-tmux/
      bind -n M-A display-popup -E ${show_popup}/bin/show_popup "#{pane_current_path}"
      bind -T popup M-A detach
      # This lets us do scrollback and search within the popup
      bind -T popup C-[ copy-mode
    '';
  };
}
