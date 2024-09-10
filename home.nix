{ config, pkgs, ... }:

{
  home.username = "lobo";
  home.homeDirectory = "/home/lobo";

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    firefox

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # misc
    cowsay
    file
    which
    tree

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    lsof # list open files

    # system tools
    sysstat
  ];

  programs.ssh = {
    enable = true;

    # Keep SSH sessions alive by sending, every minute, a keep-alive signal to hosts
    serverAliveInterval = 60;

    # Use the 1Password SSH agent for all hosts
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '';
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Lodewijk Bogaards";
    userEmail = "lodewijk.bogaards@gmail.com";

    package = pkgs.gitFull;

    # Install and setup delta (https://github.com/dandavison/delta)
    delta = {
      enable = true;
      options = {
        # See available themes with `delta --list-syntax-themes`
        syntax-theme = "Solarized (light)";
      };
    };

    # List of paths that should be globally ignored
    # While those files are usually never tracked, adding them is still possible with `git add --force filename`
    ignores = [
      "*.swp"
    ];
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      v = "nvim";
      l = "eza -l";
      ll = "eza -l";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
