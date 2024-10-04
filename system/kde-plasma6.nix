{pkgs, ...}: {
  # configure x11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # https://www.reddit.com/r/NixOS/comments/1d4l6ak/plasma_6_stuck_on_black_screen_wayland_and_nvidia/
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];

  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [];
}
