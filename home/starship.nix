{...}: {
  # starship - a customizable prompt for any shell
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      # somehow the nix symbol messes up the spacing on my zsh
      # and this fixes it :shrug:
      nix_shell = {
        disabled = true;
        impure_msg = "";
        pure_msg = "";
      };
      aws = {
        disabled = true;
      };
      package = {
        disabled = true;
      };
      python = {
        disabled = true;
      };
    };
  };
}
