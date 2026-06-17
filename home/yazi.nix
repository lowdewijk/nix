{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        show_symlink = true;
        scrolloff = 8;
      };

      preview = {
        wrap = "yes";
        tab_size = 2;
        max_width = 1800;
        max_height = 2400;
        image_delay = 100;
      };

      opener = {
        edit = [
          {
            run = ''nvim "$@"'';
            block = true;
            desc = "Edit in Neovim";
          }
        ];
        open = [
          {
            run = ''xdg-open "$1"'';
            orphan = true;
            desc = "Open";
          }
        ];
        reveal = [
          {
            run = ''xdg-open "$(dirname "$1")"'';
            orphan = true;
            desc = "Reveal";
          }
        ];
        extract = [
          {
            run = ''unar "$1"'';
            desc = "Extract here";
          }
        ];
        play = [
          {
            run = ''mpv "$@"'';
            orphan = true;
            desc = "Play with mpv";
          }
        ];
      };

      open = {
        rules = [
          {
            mime = "text/*";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            name = "*.{nix,md,txt,json,toml,yaml,yml,lua,py,rs,js,ts,tsx,jsx,sh,zsh}";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "image/*";
            use = [
              "open"
              "reveal"
            ];
          }
          {
            mime = "video/*";
            use = [
              "open"
              "reveal"
            ];
          }
          {
            mime = "application/pdf";
            use = [
              "open"
              "reveal"
            ];
          }
          {
            mime = "application/{,g}zip";
            use = [
              "extract"
              "reveal"
            ];
          }
        ];
      };

      tasks = {
        micro_workers = 20;
        macro_workers = 10;
        bizarre_retry = 5;
      };
    };
  };

  xdg.configFile."yazi/keymap.toml".text = ''
    [mgr]

    [[mgr.prepend_keymap]]
    on = "i"
    run = "spot"
    desc = "Show file information"
  '';

  home.packages = with pkgs; [
    ffmpegthumbnailer
    unar
    poppler
    jq
    file
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
    chafa
    mediainfo
    mpv
    wl-clipboard
  ];
}
