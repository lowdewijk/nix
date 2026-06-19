# NixOS 

This is my personal NixOS setup. 

Current setup:

 - Niri + Noctalia
 - Ghosttyy
 - Neovim, Yazi
 - 1Password for secrets

Everything styled with Catppuccin-Mocha.

## After a fresh GUI install

1) Clone this repo to `~/nixos` (or update `globals.nix` if you use a different path).
2) Copy the new machine's hardware config:

```bash
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos/hardware/mynewshiny-laptop.nix
```

3) Update host details in `globals.nix` to match the hardware and other config to the current hostname.
4) Rebuild from the repo:

```bash
sudo nixos-rebuild switch --flake /home/lobo/nix
```

5) Reboot.
6) Change the remote of this repo to ssh.
6) Enable SSH agent on 1Password
7) Install 1Password on Firefox manually

## Google Drive mount

This config includes a user service that mounts Google Drive at `~/GoogleDrive/veganfuture` with `rclone`.

After rebuilding, authenticate `rclone` once:

```bash
rclone config
```

Create a remote named `veganfuture-gdrive`, pick `drive` as the storage type, and complete the Google login flow.

Then start the mount without waiting for the next login:

```bash
systemctl --user daemon-reload
systemctl --user start google-drive-mount.service
```

Check status with:

```bash
systemctl --user status google-drive-mount.service
```


## What to do when /boot is full

Remove all generations except the latest:

```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +1
```

You can run nix GC, but this probably won't clean `/boot`:

```bash
sudo nix-collect-garbage -d
```

If it doesn't (it won't) you can manually and safely remove all tmp files:

```bash
sudo rm -f /boot/kernels/*-initrd-*.tmp
```

You can also remove kernels that are not in use. Check what is in use:

```bash
ls -l /nix/var/nix/profiles/system/kernel
ls -l /nix/var/nix/profiles/system/initrd
``

You can freely remove everything else in `/boot/kernels`.

You should not have the maximum space available in /boot.
