{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    catppuccin.enable = true;
    settings = {
      font_family = "Hack Nerd Font";
      enable_audio_bell = false;
      hide_window_decorations = true;
      shell = "tmux";
    };
  };
}
