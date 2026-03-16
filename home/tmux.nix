{
  pkgs,
  config,
  lib,
  ...
}: {
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
          # Catppuccin status line (official catppuccin/tmux)
          set -g status-left-length 100
          set -g status-right-length 100

          # left: nothing (windows will still show via window-status)
          set -g status-left ""

          # right: directory, current command, time
          set -g status-right "#{E:@catppuccin_status_directory}#{E:@catppuccin_status_application}#{E:@catppuccin_status_date_time}"

          # I just need to know that I am not making it too late :)
          set -g @catppuccin_date_time_text "%H:%M"

          # set current running command to right module
          set -g @catppuccin_application_text "#{pane_current_command}"

          set -g @catppuccin_window_text "#{window_name}"
        '';
      }
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-bind '-n M-p'
          set -g @floax-border-color 'blue'
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

      # Bind new keys for splitting and open them on the current path
      unbind %
      unbind '"'
      bind % split-window -v -c "#{pane_current_path}"
      bind '"' split-window -h -c "#{pane_current_path}"

      # Fix visual mode
      bind -T copy-mode-vi v send -X begin-selection # 'v' to begin selection as in vim
      bind -T copy-mode-vi Escape send-keys -X cancel # escape to quit visual mode

      # hotkey to create and delete sessions
      bind C new-session
      bind X confirm-before -p "Kill this session? (y/n)" kill-session

      # position the status bar on top (so  it isn't in the way of neovim's statusbar)
      set-option -g status-position top

      # Make buffer size bigger (default = 2000)
      set-option -g history-limit 5000
    '';
  };
}
