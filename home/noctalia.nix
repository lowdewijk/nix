{...}: let
  palette = import ./catppuccin-mocha-palette.nix;
in {
  home.file.".config/noctalia/colorschemes/Catppuccin-Mocha/Catppuccin-Mocha.json".text = builtins.toJSON {
    mPrimary = palette.mauve;
    mOnPrimary = palette.crust;
    mSecondary = palette.peach;
    mOnSecondary = palette.crust;
    mTertiary = palette.teal;
    mOnTertiary = palette.crust;
    mError = palette.red;
    mOnError = palette.crust;
    mSurface = palette.base;
    mOnSurface = palette.text;
    mSurfaceVariant = palette.surface0;
    mOnSurfaceVariant = palette.subtext0;
    mOutline = palette.surface2;
    mShadow = palette.crust;
    mHover = palette.teal;
    mOnHover = palette.crust;
    terminal = {
      normal = {
        black = palette.surface1;
        red = palette.red;
        green = palette.green;
        yellow = palette.yellow;
        blue = palette.blue;
        magenta = palette.pink;
        cyan = palette.teal;
        white = palette.subtext1;
      };
      bright = {
        black = palette.surface2;
        red = palette.red;
        green = palette.green;
        yellow = palette.yellow;
        blue = palette.blue;
        magenta = palette.pink;
        cyan = palette.teal;
        white = palette.subtext0;
      };
      foreground = palette.text;
      background = palette.base;
      selectionFg = palette.text;
      selectionBg = palette.surface2;
      cursorText = palette.base;
      cursor = palette.rosewater;
    };
  };

  programs.noctalia-shell = {
    enable = true;

    settings = {
      templates = {
        activeTemplates = [
          {
            id = "pywalfox";
            enabled = true;
          }
          {
            id = "qt";
            enabled = true;
          }
        ];
        enableUserTheming = false;
      };
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
              id = "Network";
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
        nightLight = {
          enabled = false;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
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
