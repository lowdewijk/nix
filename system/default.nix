{
  pkgs,
  globals,
  hostName,
  ...
}: {
  imports = [
    globals.hardwareConfig
    ./packages.nix
    ./kde-plasma6.nix
    ./1password.nix
    ./nvidia.nix
    ./nix-ld.nix
    ./docker.nix
    ./tailscale.nix
  ];

  # Which linux kernel to use
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable flake support
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.variables = {
    EDITOR = "nvim";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 8;
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    firewall.enable = true;
  };

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
  users.users.${globals.username} = {
    isNormalUser = true;
    description = globals.username;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # sets the defaul shell to zsh
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # add myself as a trusted-user so devenv can manage its cache
  nix.extraOptions = ''
    trusted-users = root ${globals.username}
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
