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
sudo cp -f $SCRIPT_DIR/globals.nix /etc/nixos
sudo cp -f $SCRIPT_DIR/flake.lock /etc/nixos
sudo rm -rf /etc/nixos/system
sudo cp -rf $SCRIPT_DIR/system /etc/nixos
sudo rm -rf /etc/nixos/home
sudo cp -rf $SCRIPT_DIR/home /etc/nixos

# Adding secrets to nixos from 1password
# These files will be automatically cleaned once the script finished (see cleanup)
sudo mkdir -p /etc/nixos/home/secret
sudo mkdir -p /etc/nixos/system/secret

echo "Running rebuild..."
sudo nixos-rebuild $@

echo "Copying back flake.lock file..."
cp -f /etc/nixos/flake.lock $SCRIPT_DIR
