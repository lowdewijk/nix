{ pkgs, ...}:

{
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    theme = {
      name = "Obsidian-2";
      package = pkgs.theme-obsidian2;
    };
    iconTheme = {
      name = "Obsidian";
      package = pkgs.iconpack-obsidian;
    };
  };
}
