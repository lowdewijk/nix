{pkgs, ...}: {
  programs.zsh.shellAliases = {
    logout = "qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout";
    toclip = "wl-copy";
    fromclip = "wl-paste";
  };

  home.packages = [
    pkgs.wl-clipboard
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "Scratchy";
      cursor = {
        theme = "WhiteSur Cursors";
        size = 30;
      };
      iconTheme = "McMojave-circle";
      wallpaper = ./wallpapers/wp1.png;
    };

    fonts = {
      general = {
        family = "Hack";
        pointSize = 12;
      };
    };

    startup.startupScript = {
      # start 1password to tray, so it can connect with the 1password cli and ssh agent
      _1password = {
        text = ''setsid 1password --silent > /dev/null 2>&1'';
        # we run this script last, because somehow it messes up the other startup scripts
        # this solution works, but it is not ideal
        priority = 8;
      };
    };

    input = {
      keyboard = {
        model = "pc105";
        numlockOnStartup = "on";
        options = [
          "altwin:meta_win"
          "caps:escape"
        ];
      };
    };

    panels = [
      {
        location = "top";
        floating = true;
        height = 38;
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config.General.icon = "nix-snowflake-white";
          }
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:kitty.desktop"
                "applications:firefox.desktop"
              ];
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemmonitor.memory"
          {
            name = "org.kde.plasma.systemmonitor.cpucore";
            config.Appearance.chartFace = "org.kde.ksysguard.linechart";
            config.Appearance.title = "cpu does zoom";
          }
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
          window-types = ["normal"];
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
      {
        description = "Kitty always fullscreen";
        match = {
          window-class = {
            value = "kitty";
            type = "exact";
            match-whole = false;
          };
          window-types = ["normal"];
        };
        apply = {
          fullscreen = {
            value = true;
            apply = "force";
          };
        };
      }
    ];

    powerdevil = {
      AC = {
        powerButtonAction = "lockScreen";
        turnOffDisplay = {
          idleTimeout = 1000;
          idleTimeoutWhenLocked = "immediately";
        };
      };
      battery = {
        powerButtonAction = "sleep";
        whenSleepingEnter = "standby";
      };
      lowBattery = {
        whenLaptopLidClosed = "sleep";
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
          night = 3200;
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
      "ActivityManager"."switch-to-activity-a9f95f7e-135b-4834-b607-4bc9b54bde91" = [];
      "ActivityManager"."switch-to-activity-db1e246a-f31e-4135-9a62-569deab0c016" = [];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to English (US)" = [];
      "KDE Keyboard Layout Switcher"."Switch keyboard layout to Turkish" = [];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "";
      "firefox.desktop"."_launch" = "";
      "firefox.desktop"."new-private-window" = [];
      "firefox.desktop"."new-window" = [];
      "firefox.desktop"."profile-manager-window" = [];
      "kaccess"."Toggle Screen Reader On and Off" = "";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = "Touchpad Toggle";
      "kded5"."Show System Activity" = [];
      "kded5"."display" = [];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = [];
      "ksmserver"."Lock Session" = ["Meta+Ctrl+l" "Screensaver"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = [];
      "ksmserver"."Reboot" = [];
      "ksmserver"."Reboot Without Confirmation`" = [];
      "ksmserver"."Shut Down" = [];
      "kwin"."Activate Window Demanding Attention" = "";
      "kwin"."Cycle Overview" = [];
      "kwin"."Cycle Overview Opposite" = [];
      "kwin"."Decrease Opacity" = [];
      "kwin"."Edit Tiles" = [];
      "kwin"."Expose" = "";
      "kwin"."ExposeAll" = [];
      "kwin"."ExposeClass" = "";
      "kwin"."ExposeClassCurrentDesktop" = [];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = [];
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [];
      "kwin"."MoveMouseToCenter" = "";
      "kwin"."MoveMouseToFocus" = "";
      "kwin"."MoveZoomDown" = [];
      "kwin"."MoveZoomLeft" = [];
      "kwin"."MoveZoomRight" = [];
      "kwin"."MoveZoomUp" = [];
      "kwin"."Overview" = "Meta+W";
      "kwin"."Setup Window Shortcut" = [];
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."ShowDesktopGrid" = "";
      "kwin"."Suspend Compositing" = "";
      "kwin"."Switch One Desktop Down" = [];
      "kwin"."Switch One Desktop Up" = [];
      "kwin"."Switch One Desktop to the Left" = [];
      "kwin"."Switch One Desktop to the Right" = [];
      "kwin"."Switch Window Down" = "Meta+j";
      "kwin"."Switch Window Left" = "Meta+h";
      "kwin"."Switch Window Right" = "Meta+l";
      "kwin"."Switch Window Up" = "Meta+k";
      "kwin"."Switch to Desktop 1" = [];
      "kwin"."Switch to Desktop 10" = [];
      "kwin"."Switch to Desktop 11" = [];
      "kwin"."Switch to Desktop 12" = [];
      "kwin"."Switch to Desktop 13" = [];
      "kwin"."Switch to Desktop 14" = [];
      "kwin"."Switch to Desktop 15" = [];
      "kwin"."Switch to Desktop 16" = [];
      "kwin"."Switch to Desktop 17" = [];
      "kwin"."Switch to Desktop 18" = [];
      "kwin"."Switch to Desktop 19" = [];
      "kwin"."Switch to Desktop 2" = [];
      "kwin"."Switch to Desktop 20" = [];
      "kwin"."Switch to Desktop 3" = [];
      "kwin"."Switch to Desktop 4" = [];
      "kwin"."Switch to Desktop 5" = [];
      "kwin"."Switch to Desktop 6" = [];
      "kwin"."Switch to Desktop 7" = [];
      "kwin"."Switch to Desktop 8" = [];
      "kwin"."Switch to Desktop 9" = [];
      "kwin"."Switch to Next Desktop" = [];
      "kwin"."Switch to Next Screen" = [];
      "kwin"."Switch to Previous Desktop" = [];
      "kwin"."Switch to Previous Screen" = [];
      "kwin"."Switch to Screen 0" = [];
      "kwin"."Switch to Screen 1" = [];
      "kwin"."Switch to Screen 2" = [];
      "kwin"."Switch to Screen 3" = [];
      "kwin"."Switch to Screen 4" = [];
      "kwin"."Switch to Screen 5" = [];
      "kwin"."Switch to Screen 6" = [];
      "kwin"."Switch to Screen 7" = [];
      "kwin"."Switch to Screen Above" = [];
      "kwin"."Switch to Screen Below" = [];
      "kwin"."Switch to Screen to the Left" = [];
      "kwin"."Switch to Screen to the Right" = [];
      "kwin"."Toggle Night Color" = [];
      "kwin"."Toggle Window Raise/Lower" = [];
      "kwin"."Walk Through Desktop List" = [];
      "kwin"."Walk Through Desktop List (Reverse)" = [];
      "kwin"."Walk Through Desktops" = [];
      "kwin"."Walk Through Desktops (Reverse)" = [];
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Backtab";
      "kwin"."Walk Through Windows Alternative" = [];
      "kwin"."Walk Through Windows Alternative (Reverse)" = [];
      "kwin"."Walk Through Windows of Current Application" = "";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "";
      "kwin"."Walk Through Windows of Current Application Alternative" = [];
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = [];
      "kwin"."Window Above Other Windows" = [];
      "kwin"."Window Below Other Windows" = [];
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Fullscreen" = "Meta+Enter";
      "kwin"."Window Grow Horizontal" = [];
      "kwin"."Window Grow Vertical" = [];
      "kwin"."Window Lower" = [];
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = [];
      "kwin"."Window Maximize Vertical" = [];
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = [];
      "kwin"."Window Move Center" = [];
      "kwin"."Window No Border" = "";
      "kwin"."Window On All Desktops" = [];
      "kwin"."Window One Desktop Down" = "";
      "kwin"."Window One Desktop Up" = "";
      "kwin"."Window One Desktop to the Left" = "";
      "kwin"."Window One Desktop to the Right" = "";
      "kwin"."Window One Screen Down" = [];
      "kwin"."Window One Screen Up" = [];
      "kwin"."Window One Screen to the Left" = [];
      "kwin"."Window One Screen to the Right" = [];
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = "";
      "kwin"."Window Pack Left" = "";
      "kwin"."Window Pack Right" = "";
      "kwin"."Window Pack Up" = "";
      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Bottom Left" = "Meta+Left+Down";
      "kwin"."Window Quick Tile Bottom Right" = "Meta+Right+Down";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Top Left" = "Meta+Left+Up";
      "kwin"."Window Quick Tile Top Right" = "Meta+Right+Up";
      "kwin"."Window Raise" = [];
      "kwin"."Window Resize" = [];
      "kwin"."Window Shade" = [];
      "kwin"."Window Shrink Horizontal" = [];
      "kwin"."Window Shrink Vertical" = [];
      "kwin"."Window to Desktop 1" = "";
      "kwin"."Window to Desktop 10" = [];
      "kwin"."Window to Desktop 11" = [];
      "kwin"."Window to Desktop 12" = [];
      "kwin"."Window to Desktop 13" = [];
      "kwin"."Window to Desktop 14" = [];
      "kwin"."Window to Desktop 15" = [];
      "kwin"."Window to Desktop 16" = [];
      "kwin"."Window to Desktop 17" = [];
      "kwin"."Window to Desktop 18" = [];
      "kwin"."Window to Desktop 19" = [];
      "kwin"."Window to Desktop 2" = "";
      "kwin"."Window to Desktop 20" = [];
      "kwin"."Window to Desktop 3" = "";
      "kwin"."Window to Desktop 4" = "";
      "kwin"."Window to Desktop 5" = "";
      "kwin"."Window to Desktop 6" = [];
      "kwin"."Window to Desktop 7" = [];
      "kwin"."Window to Desktop 8" = [];
      "kwin"."Window to Desktop 9" = [];
      "kwin"."Window to Next Desktop" = [];
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = [];
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."Window to Screen 0" = [];
      "kwin"."Window to Screen 1" = [];
      "kwin"."Window to Screen 2" = [];
      "kwin"."Window to Screen 3" = [];
      "kwin"."Window to Screen 4" = [];
      "kwin"."Window to Screen 5" = [];
      "kwin"."Window to Screen 6" = [];
      "kwin"."Window to Screen 7" = [];
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = "Meta+=";
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = [];
      "mediacontrol"."mediavolumeup" = [];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = [];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org.kde.dolphin.desktop"."_launch" = "Meta+E";
      "org.kde.konsole.desktop"."NewTab" = [];
      "org.kde.konsole.desktop"."NewWindow" = [];
      "org.kde.konsole.desktop"."_launch" = "";
      "org.kde.krunner.desktop"."RunClipboard" = "";
      "org.kde.krunner.desktop"."_launch" = "Alt+Space";
      "org.kde.plasma.emojier.desktop"."_launch" = "";
      "org.kde.spectacle.desktop"."ActiveWindowScreenShot" = "Meta+Print";
      "org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = [];
      "org.kde.spectacle.desktop"."FullScreenScreenShot" = ["Print" "Shift+Print"];
      "org.kde.spectacle.desktop"."OpenWithoutScreenshot" = [];
      "org.kde.spectacle.desktop"."RectangularRegionScreenShot" = ["Alt+Print"];
      "org.kde.spectacle.desktop"."WindowUnderCursorScreenShot" = "";
      "org.kde.spectacle.desktop"."_launch" = [];
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [];
      "org_kde_powerdevil"."powerProfile" = ["Battery" "Meta+B"];
      "plasmashell"."activate task manager entry 1" = [];
      "plasmashell"."activate task manager entry 10" = [];
      "plasmashell"."activate task manager entry 2" = [];
      "plasmashell"."activate task manager entry 3" = [];
      "plasmashell"."activate task manager entry 4" = [];
      "plasmashell"."activate task manager entry 5" = [];
      "plasmashell"."activate task manager entry 6" = [];
      "plasmashell"."activate task manager entry 7" = [];
      "plasmashell"."activate task manager entry 8" = [];
      "plasmashell"."activate task manager entry 9" = [];
      "plasmashell"."clear-history" = [];
      "plasmashell"."clipboard_action" = "";
      "plasmashell"."cycle-panels" = "";
      "plasmashell"."cycleNextAction" = [];
      "plasmashell"."cyclePrevAction" = [];
      "plasmashell"."edit_clipboard" = [];
      "plasmashell"."manage activities" = [];
      "plasmashell"."next activity" = "Meta+Tab";
      "plasmashell"."previous activity" = "Meta+Shift+Tab";
      "plasmashell"."repeat_action" = "";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = [];
      "plasmashell"."show-on-mouse-pos" = "";
      "plasmashell"."stop current activity" = "";
      "plasmashell"."switch to next activity" = [];
      "plasmashell"."switch to previous activity" = [];
      "plasmashell"."toggle do not disturb" = [];
      "systemsettings.desktop"."_launch" = "Tools";
      "systemsettings.desktop"."kcm-kscreen" = [];
      "systemsettings.desktop"."kcm-lookandfeel" = [];
      "systemsettings.desktop"."kcm-users" = [];
      "systemsettings.desktop"."powerdevilprofilesconfig" = [];
      "systemsettings.desktop"."screenlocker" = [];
    };

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;

      # these can be found in ~/.config/kdeglobals
      kdeglobals = {
        Sounds.Enable = false;
      };
    };
  };
}
