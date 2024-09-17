{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./packages.nix
      ./kde-plasma6.nix
      ./1password.nix
      ./fonts.nix
      ./nvidia.nix
      ./nix-ld.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable flake support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables = {
    EDITOR = "nvim";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    extraEntries = ''
menuentry 'Ubuntu' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-44571930-b3e4-49ab-bf7d-6a2f8ec23ce6' {
  recordfail
  load_video
  gfxmode $linux_gfx_mode
  insmod gzio
  if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
  insmod part_gpt
  insmod ext2
  search --no-floppy --fs-uuid --set=root 652c86eb-e785-49cc-8c28-6aceb1a69699
  linux /vmlinuz-6.8.0-40-generic root=/dev/mapper/vgubuntu-root ro  quiet splash $vt_handoff
  initrd /initrd.img-6.8.0-40-generic
}
    '';
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lobo = {
    isNormalUser = true;
    description = "lobo";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
