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
      { 
        plugin = catppuccin;
        extraConfig = ''
        # bottom right show the current working dir followed by the current command
        set -g @catppuccin_status_modules_right "directory application"
        # bottom left show only the windows
        set -g @catppuccin_status_modules_left "null"
        
        # set current running command to bottom right module
        set -g @catppuccin_application_text "#{pane_current_command}"

        # use window names for window texts on the bottom left
        set -g @catppuccin_window_default_text "#{window_name}"
        set -g @catppuccin_window_current_text "#{window_name}" 
        '';
      }
    ];
    disableConfirmationPrompt = true;
    # Start windows and panes at 1, not 0
    baseIndex = 1;
    extraConfig = ''
      # allow ME to rename (kind of confusing this flag)
      set-option -g allow-rename off

      # for great colors
      set-option -a terminal-features 'xterm-256color:RGB'

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

      # Popup (toggles on ALT-SHIFT-M)
      # Got this from https://willhbr.net/2023/02/07/dismissable-popup-shell-in-tmux/
      bind -n M-A display-popup -E ${show_popup}/bin/show_popup "#{pane_current_path}"
      bind -T popup M-A detach
      # This lets us do scrollback and search within the popup
      bind -T popup C-[ copy-mode

      # use the name of the window in the windows overview left-bottom 
      # (it is very odd that this is not the default, but the default it the name of
      # of the current working path of the active pane)
    '';
  };
}
