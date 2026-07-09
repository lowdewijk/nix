{
  programs.mpv = {
    enable = true;
    config = {
      autocreate-playlist = "filter";
      keep-open = "always";
      loop-file = "inf";
      osd-font-size = 14;
    };
    bindings = {
      h = "playlist-prev";
      l = "playlist-next";
      "f" = ''show-text "''${osd-ass-cc/0}{\\an8}''${filename}"'';
    };
  };
}
