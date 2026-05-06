{...}: {
  # configure x11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.desktopManager.plasma6.enable = true;

  programs.xwayland.enable = true;
}
