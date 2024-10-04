{
  config,
  pkgs,
  ...
}: {
  # starship - a customizable prompt for any shell
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    catppuccin.enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };
}
