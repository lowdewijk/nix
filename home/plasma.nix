{pkgs, ...}:
{
  programs.zsh.shellAliases = {
    logout = "qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout";
  };

  programs.plasma = {
      enable = true;

      workspace = {
        lookAndFeel = "Scratchy";
        cursor = {
          theme = "WhiteSur Cursors";
          size = 30;
        };
        iconTheme = "McMojave-circle";
        wallpaper = ../wallpapers/nixos-wallpaper-catppuccin.png;
      };

      fonts = {
        general = {
          family = "Hack";
          pointSize = 12;
        };
      };

     startup.startupScript = {
       # start 1password to tray, so it can connect with the 1password cli and ssh agent
       _1password.text = ''1password --silent'';
      };

      panels = [
        {
          location = "left";
          floating = false;
          hiding = "autohide";
          widgets = [
            {
              iconTasks = {};
            }
            "org.kde.plasma.marginsseparator"
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.networkmanagement"
                ];
                hidden = [
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "monday";
                time.format = "24h";
              };
            }
          ];
        }
      ];

      window-rules = [
        {
          description = "Dolphin";
          match = {
            window-class = {
              value = "dolphin";
              type = "substring";
            };
            window-types = [ "normal" ];
          };
          apply = {
            noborder = {
              value = true;
              apply = "force";
            };
            # `apply` defaults to "apply-initially"
            maximizehoriz = true;
            maximizevert = true;
          };
        }
      ];

      powerdevil = {
        AC = {
          powerButtonAction = "lockScreen";
          autoSuspend = {
            action = "shutDown";
            idleTimeout = 1000;
          };
          turnOffDisplay = {
            idleTimeout = 1000;
            idleTimeoutWhenLocked = "immediately";
          };
        };
        battery = {
          powerButtonAction = "sleep";
          whenSleepingEnter = "standbyThenHibernate";
        };
        lowBattery = {
          whenLaptopLidClosed = "hibernate";
        };
      };

      kwin = {
        edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
        cornerBarrier = false;

        # auto-tiling
        scripts.polonium.enable = false;
        
        nightLight = {
          enable = true;
          mode = "times";
          temperature = {
            day = 6500;
            night = 4500;
          };
          time = {
            morning = "07:00";
            evening = "20:00";
          };
        };
      };

      kscreenlocker = {
        lockOnResume = true;
        timeout = 10;
      };

      shortcuts = {
        ksmserver = {
          "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
        };
      };


      #
      # Some low-level settings:
      #
      configFile = {
        baloofilerc."Basic Settings"."Indexing-Enabled" = false;
        kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
        kwinrc.Desktops.Number = {
          value = 8;
          # Forces kde to not change this value (even through the settings app).
          immutable = true;
        };
        kscreenlockerrc = {
          Greeter.WallpaperPlugin = "org.kde.potd";
          # To use nested groups use / as a separator. In the below example,
          # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
          "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
        };
      };
    };
}
