{...}: {
  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        density = "compact";
        position = "top";
        barType = "floating";
        showCapsule = true;
        widgets = {
          left = [
            {
              id = "Launcher";
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = false;
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "index";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
            }
            {
              id = "Volume";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
              icon = "noctalia"; # used when distro logo is set to false
              enableColorization = true;
            }
          ];
        };
      };

      general = {
      };

      colorSchemes.predefinedScheme = "Catppuccin-Mocha";

      location = {
        analogClockInCalendar = "true";
        name = "Amsterdam, NL";
        useFahrenheit = false;
      };

      network = {
      };
    };
  };
}
