{...}: {
  # starship - a customizable prompt for any shell
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;

      # somehow the nix symbol messes up the spacing on my zsh
      # and this fixes it :shrug:
      nix_shell = {
        symbol = "Nix ";
        impure_msg = "";
        pure_msg = "";
      };
      aws = {
        disabled = true;
      };
    };
  };
}
