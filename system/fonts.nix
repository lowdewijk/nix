{pkgs, ...}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerdfonts.hack
  ];
}
