{ pkgs, ...}:

{
   environment.systemPackages = with pkgs; [
     gnome-tweaks
     gnomeExtensions.open-bar
     gnomeExtensions.caffeine
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides =  ''
      [org.gnome.desktop.sound]
      event-sounds=false
    ''; 
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable unclutter
  services.unclutter = {
    enable = true;
    timeout = 3;
    extraOptions = [
      "exclude-root"
      "ignore-scrolling"
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # Disable the annoying system bell
    # Every item in this attrset becomes a separate drop-in file in /etc/pipewire/pipewire.conf.d
    extraConfig = {
      pipewire."99-silent-bell.conf" = {
        "context.properties" = {
          "module.x11.bell" = false;
        }; 
      };
    };
  };
}
