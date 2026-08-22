{config, pkgs, ...}: {
  home.file.media.source = config.lib.file.mkOutOfStoreSymlink "/run/media/${config.home.username}";
  home.packages = [pkgs.udiskie];

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
    settings = {
      program_options.file_manager = "${pkgs.ghostty}/bin/ghostty -e ${pkgs.yazi}/bin/yazi";
      notifications.device_mounted = ["browse"];
    };
  };
}
