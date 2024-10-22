{pkgs, ...}: {
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["Hack"];})
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
