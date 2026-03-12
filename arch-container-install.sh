#!/bin/bash

# Exit if any code returns a non-zero exit code
set -e

source ./scripts/utils.sh

echo "Starting full system setup..."

# Check if arch-container-pkgs.conf exist
if [ ! -f "./scripts/arch-container-pkgs.conf" ]; then
  echo "Error: arch-container-pkgs.conf not found!"
  exit 1
fi
source ./scripts/arch-container-pkgs.conf

# Update system
echo "Updating System..."
sudo pacman -Syu

# Install yay AUR helper
if ! command -V yay &>/dev/null; then
  echo "Installing yay AUR helper..."
  sudo pacman -S --needed git base-devel --noconfirm
  if [[ ! -d "yay" ]]; then
    echo "Cloning yay repo..."
  else
    echo "yay directory already exists, removing it..."
    rm -rf yay
  fi
  git clone https://aur.archlinux.org/yay.git
  cd yay
  echo "building yay..."
  makepkg -si
  cd ..
  rm -rf yay
else
  echo "yay is already installed"
fi

# Install system packages
echo "Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing dev tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing system maintenance tools..."
install_packages "${MAINTENANCE[@]}"

echo "Installing programming languages..."
install_packages "${PROG_LANG[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

sudo reflector \
  --country "United States,Canada" \
  --protocol https \
  --latest 10 \
  --sort rate \
  --save /etc/pacman.d/mirrorlist
