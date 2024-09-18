{ config, pkgs, ... }:
{
  # Load all dotfiles in the `extra_dotfiles` directory into `$USER/.config`
  home.file.".config" = {
    source = ./extra-dotfiles;
    recursive = true;
  };
}
