#!/bin/bash

# Exit if any code returns a non-zero exit code
set -e

source ./scripts/utils.sh

echo "Starting full system setup..."

# Check if packages.conf exist
if [ ! -f "./scripts/packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi
source ./scripts/packages.conf

# Update system
echo "Updating System..."
sudo dnf update

# Install system packages
echo "Installing dev tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing desktop applications..."
install_packages "${DESKTOP[@]}"

echo "*** Please Reboot Your System ***"
