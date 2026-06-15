{pkgs, ...}: {
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
