#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function cleanup {
  sudo rm -rf /etc/nixos/home/secret
  sudo rm -rf /etc/nixos/system/secret
}
trap cleanup EXIT


# Check if no arguments were provided
if [ $# -eq 0 ]; then
  echo "No arguments provided. Run 'nixos-rebuild --help' for a full listing."
  exit 1
fi

echo "Copying nix files from $SCRIPT_DIR to /etc/nixos..."
sudo cp -f $SCRIPT_DIR/flake.nix /etc/nixos
sudo cp -f $SCRIPT_DIR/flake.lock /etc/nixos
sudo cp -rf $SCRIPT_DIR/system /etc/nixos
sudo cp -rf $SCRIPT_DIR/home /etc/nixos

# Adding secrets to nixos from 1password
# These files will be automatically cleaned once the script finished (see cleanup)
sudo mkdir -p /etc/nixos/home/secret
sudo mkdir -p /etc/nixos/system/secret
op read op://Personal/wireguard.nix/notesPlain | sudo tee /etc/nixos/system/secret/wireguard.nix > /dev/null
op read op://Personal/extra_ssh_config.secret/notesPlain | sudo tee /etc/nixos/home/secret/extra_ssh_config.secret > /dev/null

echo "Running rebuild..."
sudo nixos-rebuild $@

echo "Copying back flake.lock file..."
cp -f /etc/nixos/flake.lock $SCRIPT_DIR
