{pkgs, ...}: let
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
          set -g @catppuccin_status_modules_right "directory application date_time"
          # bottom left show only the windows
          set -g @catppuccin_status_modules_left "null"

          # I just need to know that I am not making it too late :)
          set -g @catppuccin_date_time_text "%H:%M"

          # set current running command to bottom right module
          set -g @catppuccin_application_text "#{pane_current_command}"

          # use window names for window texts on the bottom left
          set -g @catppuccin_window_default_text "#{window_name}"
          set -g @catppuccin_window_current_text "#{window_name}"
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-processes '~nvim'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-boot 'on'
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1';
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
      bind r { source-file ~/.config/tmux/tmux.conf; display-message "tmux config reloaded" }

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

      # Fix visual mode
      bind -T copy-mode-vi v send -X begin-selection # 'v' to begin selection as in vim
      bind -T copy-mode-vi Escape send-keys -X cancel # escape to quit visual mode

      # Popup (toggles on ALT-SHIFT-M)
      # Got this from https://willhbr.net/2023/02/07/dismissable-popup-shell-in-tmux/
      bind -n M-A display-popup -E ${show_popup}/bin/show_popup "#{pane_current_path}"
      bind -T popup M-A detach
      # This lets us do scrollback and search within the popup
      bind -T popup C-[ copy-mode

      # position the status bar on top (so  it isn't in the way of neovim's statusbar)
      set-option -g status-position top
    '';
  };
}
