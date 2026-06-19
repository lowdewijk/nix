{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.nerd-fonts.hack
      pkgs.corefonts
      pkgs.liberation_ttf
      pkgs.carlito
      pkgs.caladea
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Hack Nerd Font" "Noto Serif"];
        sansSerif = ["Hack Nerd Font" "Noto Sans"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
