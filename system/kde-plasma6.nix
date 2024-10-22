{...}: {
  # configure x11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.xwayland.enable = true;

  environment.variables = {
    KWIN_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";
    KWIN_DRM_USE_EGL_STREAMS = "1";
    GBM_BACKEND = "nvidia-drm";
  };
}
