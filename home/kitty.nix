{...}: {
  programs.kitty = {
    enable = true;
    extraConfig = ''

      # vim:ft=kitty

      enable_audio_bell no
      font_family Hack Nerd Font
      hide_window_decorations yes
      term xterm-256color

      ## Reattach to tmux (or create a new tmux session) if tmux exists
      shell zsh --login -c "if command -v tmux >/dev/null 2>&1; then tmux attach || tmux; else zsh; fi"

      ## Keyboard shortcuts
      clear_all_shortcuts yes
      map ctrl+shift+equal change_font_size all +1.0
      map ctrl+shift+plus change_font_size all +1.0
      map ctrl+shift+minus change_font_size all -1.0
      map ctrl+shift+0 change_font_size all 0
      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+h open_url_with_hints

      background_image ${./wallpapers/terminal-wallpaper.png}
      background_image_layout scaled

      confirm_os_window_close 0

      ## name:     Catppuccin-Mocha
      ## author:   Pocco81 (https://github.com/Pocco81)
      ## license:  MIT
      ## upstream: https://github.com/catppuccin/kitty/blob/main/mocha.conf
      ## blurb:    Soothing pastel theme for the high-spirited!

      # The basic colors
      foreground              #CDD6F4
      background              #1E1E2E
      selection_foreground    #1E1E2E
      selection_background    #F5E0DC

      # Cursor colors
      cursor                  #F5E0DC
      cursor_text_color       #1E1E2E

      # URL underline color when hovering with mouse
      url_color               #F5E0DC

      # Kitty window border colors
      active_border_color     #B4BEFE
      inactive_border_color   #6C7086
      bell_border_color       #F9E2AF

      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system

      # Tab bar colors
      active_tab_foreground   #11111B
      active_tab_background   #CBA6F7
      inactive_tab_foreground #CDD6F4
      inactive_tab_background #181825
      tab_bar_background      #11111B

      # Colors for marks (marked text in the terminal)
      mark1_foreground #1E1E2E
      mark1_background #B4BEFE
      mark2_foreground #1E1E2E
      mark2_background #CBA6F7
      mark3_foreground #1E1E2E
      mark3_background #74C7EC

      # The 16 terminal colors

      # black
      color0 #45475A
      color8 #585B70

      # red
      color1 #F38BA8
      color9 #F38BA8

      # green
      color2  #A6E3A1
      color10 #A6E3A1

      # yellow
      color3  #F9E2AF
      color11 #F9E2AF

      # blue
      color4  #89B4FA
      color12 #89B4FA

      # magenta
      color5  #F5C2E7
      color13 #F5C2E7

      # cyan
      color6  #94E2D5
      color14 #94E2D5

      # white
      color7  #BAC2DE
      color15 #A6ADC8
    '';
  };
}
