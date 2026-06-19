{
  lib,
  pkgs,
  ...
}: let
  prepareGoogleDriveMountpoint = pkgs.writeShellScript "prepare-google-drive-mountpoint" ''
    set -eu

    target="$HOME/GoogleDrive/veganfuture"

    ${pkgs.coreutils}/bin/mkdir -p "$HOME/GoogleDrive"
    ${pkgs.fuse3}/bin/fusermount3 -uz "$target" 2>/dev/null || true
    ${pkgs.util-linux}/bin/umount -cl "$target" 2>/dev/null || true
    ${pkgs.coreutils}/bin/rmdir "$target" 2>/dev/null || true

    ${pkgs.coreutils}/bin/mkdir -p "$target"
  '';
in {
  systemd.user.services.google-drive-mount = {
    Unit = {
      Description = "Mount Google Drive with rclone";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
      ConditionPathExists = "%h/.config/rclone/rclone.conf";
    };

    Service = {
      Type = "simple";
      ExecStartPre = "${prepareGoogleDriveMountpoint}";
      ExecStart = "${pkgs.rclone}/bin/rclone mount veganfuture-gdrive: %h/GoogleDrive/veganfuture --dir-cache-time 72h --poll-interval 15s --vfs-cache-mode full --vfs-cache-max-age 720h --vfs-cache-max-size 50G";
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/GoogleDrive/veganfuture";
      Restart = "on-failure";
      RestartSec = 10;
    };

    Install.WantedBy = ["default.target"];
  };
}
