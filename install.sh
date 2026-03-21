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
      echo "Installing virtual machine packages..."
      install_packages "${VIRT_MAN[@]}"
      echo "Adding user to libvirt and kvm groups..."
      sudo usermod -aG libvirt,kvm $USER
      # flush nftwables ruleset
      echo "Removing existing ruleset for nftables..."
      sudo nft flush ruleset
      # Enable NAT
      echo "Enabling NAT for libvirt..."
      sudo virsh net-start default
      sudo virsh net-autostart default
      echo "Configuring services..."
      for service in "${VIRT_SERVICES[@]}"; do
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

echo "Adding user to docker group..."
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Enabling ufw on startup..."
sudo ufw enable

echo "Using reflector to get the latest Archlinux repositories..."
sudo reflector \
  --country "United States,Canada" \
  --protocol https \
  --latest 10 \
  --sort rate \
  --save /etc/pacman.d/mirrorlist

echo "PLEASE REBOOT YOUR SYSTEM!"
