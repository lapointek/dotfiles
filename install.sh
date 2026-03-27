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


while [[ true ]]; do
  # Install yay AUR helper
  read -p "Install yay AUR helper?" choice
  case "$choice" in
    [yY])
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
      break
      ;;
    [nN])
      echo "Skipping installation of yay AUR helper"
      break
      ;;
    *)
      echo "Not a choice. Please enter Y/y or N/n"
      ;;
  esac
done


# Install Nvidia packages and enable services
while [[ true ]]; do
  read -p "Using an Nvidia GPU Y/y or N/n: " choice
  case "$choice" in
    [yY])
      echo "Installing Nvidia packages..."
      install_packages "${NVIDIA[@]}"
      echo "Configuring services..."
      for service in "${NVIDIA_SERVICES[@]}"; do
        if ! systemctl is-enabled "$service" &>/dev/null; then
          echo "Enabling $service..."
          sudo systemctl enable --now "$service"
        else
          echo "$service is already enabled"
        fi
      done
      break
      ;;
    [nN])
      echo "Skipping the installation of Nvidia packages"
      break
      ;;
    *)
      echo "Not a choice. Please enter Y/y or N/n"
      ;;
  esac
done


# Install QEMU virtual machine
while [[ true ]]; do
  read -p "Install QEMU virtual machine? Y/y or N/n: " choice
  case "$choice" in
    [yY])
      if pacman -Qi iptables &>/dev/null; then
        echo "Removing iptables (conflicts with iptables-nft)..."
        sudo pacman -Rddn iptables
      fi
      echo "Removing existing ruleset for nftables..."
      sudo nft flush ruleset
      echo "Installing virtual machine packages..."
      install_packages "${VIRT_MAN[@]}"
      echo "Starting libvirtd..."
      sudo systemctl start libvirtd
      echo "Adding user to libvirt group..."
      sudo usermod -aG libvirt $USER
      echo "Starting and enabling default NAT..."
      sudo virsh net-start default
      sudo virsh net-autostart default
      break
      ;;
    [nN])
      echo "Skipping the installation of virtual machine packages"
      break
      ;;
    *)
      echo "Not a choice. Please enter Y/y or N/n"
      ;;
  esac
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

# Check if docker group exists
if getent group docker > /dev/null 2>&1; then
  echo "Docker group already exists"
else
  echo "Creating docker group..."
  sudo groupadd docker
fi
# Check if current user is in docker group
if id -nG "$USER" | grep -qw "docker"; then
  echo "User $USER is already in docker group"
else
  echo "Adding user $USER to docker group..."
  sudo usermod -aG docker "$USER"
fi

echo "Enabling ufw on startup..."
sudo ufw enable

echo "Using reflector to get the latest Archlinux repositories..."
sudo reflector \
  --country "United States,Canada" \
  --protocol https \
  --latest 10 \
  --sort rate \
  --save /etc/pacman.d/mirrorlist

echo "*** Please Reboot Your System ***"
