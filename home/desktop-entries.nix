{pkgs, ...}: {
  xdg.desktopEntries.reboot = {
    name = "Reboot";
    comment = "Restart the machine";
    exec = "${pkgs.systemd}/bin/systemctl reboot";
    terminal = false;
    categories = ["System"];
  };

  xdg.desktopEntries.shutdown = {
    name = "Shutdown";
    comment = "Shut down the machine now";
    exec = "${pkgs.systemd}/bin/systemctl poweroff";
    terminal = false;
    categories = ["System"];
  };

  xdg.desktopEntries.logout = {
    name = "Logout";
    comment = "Exit the Niri session";
    exec = "${pkgs.niri}/bin/niri msg action quit";
    terminal = false;
    categories = ["System"];
  };

  xdg.desktopEntries.lock-screen = {
    name = "Lock screen";
    comment = "Lock the current session";
    exec = "noctalia msg session lock";
    terminal = false;
    categories = ["System"];
  };

  xdg.desktopEntries.idle-displays = {
    name = "idle displays";
    genericName = "Power off displays";
    comment = "Turn off all monitors with niri";
    exec = "${pkgs.niri}/bin/niri msg action power-off-monitors";
    terminal = false;
    categories = ["System"];
    settings = {
      Keywords = "idle;displays;monitors;screen;sleep;";
    };
  };
}
