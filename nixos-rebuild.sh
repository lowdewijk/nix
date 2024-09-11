#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Check if no arguments were provided
if [ $# -eq 0 ]; then
  echo "No arguments provided. Run 'nixos-rebuild --help' for a full listing."
  exit 1
fi

echo "Copying nix files from $SCRIPT_DIR to /etc/nixos"
sudo cp -f $SCRIPT_DIR/flake.nix /etc/nixos
sudo cp -f $SCRIPT_DIR/flake.lock /etc/nixos
sudo cp -rf $SCRIPT_DIR/system /etc/nixos

sudo nixos-rebuild $@
