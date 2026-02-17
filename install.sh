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
sudo pacman -Syu

# Install paru AUR helper
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

# Install Nvidia package and enable service
is_true=0
while [ $is_true -eq 0 ]; do
  echo "Using an Nvidia GPU? Y/y or N/n"
  read choice
  if [ "$choice" = "y" -o "$choice" = "Y" ]; then
    echo "Installing Nvidia packages..."
    install_packages "${NVIDIA[@]}"

    echo "Configuring service..."
    for service in "${NVIDIA_SERVICES[@]}"; do
      if ! systemctl is-enabled "$service" &>/dev/null; then
        echo "Enabling $service..."
        sudo systemctl enable --now "$service"
      else
        echo "$service is already enabled"
      fi
    done
    is_true=1
  elif [ "$choice" = "n" -o "$choice" = "N" ]; then
    echo "Skipping the installation of Nvidia packages"
    is_true=1
  else
    echo "Not a choice."
  fi
done

# Install system packages
echo "Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing dev tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing system maintenance tools..."
install_packages "${MAINTENANCE[@]}"

echo "Installing desktop applications..."
install_packages "${DESKTOP[@]}"

echo "Installing media applications..."
install_packages "${MEDIA[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

# Start and enable system services
echo "Configuring services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    echo "Enabling $service..."
    sudo systemctl enable --now "$service"
  else
    echo "$service is already enabled"
  fi
done

echo "Rebuilding man pages database..."
sudo mandb --create --quiet

echo "Enabling ufw on startup..."
sudo ufw enable

sudo reflector \
  --country "United States,Canada" \
  --protocol https \
  --latest 10 \
  --sort rate \
  --save /etc/pacman.d/mirrorlist
