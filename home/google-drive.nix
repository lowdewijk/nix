{lib, pkgs, ...}: {
  home.activation.createGoogleDriveMountpoint = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/GoogleDrive/veganfuture"
  '';

  systemd.user.services.google-drive-mount = {
    Unit = {
      Description = "Mount Google Drive with rclone";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
      ConditionPathExists = "%h/.config/rclone/rclone.conf";
    };

    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive/veganfuture";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount veganfuture-gdrive: %h/GoogleDrive/veganfuture \
          --dir-cache-time 72h \
          --poll-interval 15s
      '';
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/GoogleDrive/veganfuture";
      Restart = "on-failure";
      RestartSec = 10;
    };

    Install.WantedBy = ["default.target"];
  };
}
