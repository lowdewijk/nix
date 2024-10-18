{config, ...}: {
  boot = {
    initrd.kernelModules = ["nvidia"];
    extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    # https://www.reddit.com/r/NixOS/comments/1d4l6ak/plasma_6_stuck_on_black_screen_wayland_and_nvidia/
    kernelParams = [
      "nvidia-drm.fbdev=1"
    ];
  };

  hardware.opengl.enable = true;

  hardware = {
    graphics.enable = true;

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
}
