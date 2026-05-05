{pkgs, ...}: {
  home.packages = [
    pkgs.nerd-fonts.hack
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Hack Nerd Font" "Noto Serif"];
      sansSerif = ["Hack Nerd Font" "Noto Sans"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
