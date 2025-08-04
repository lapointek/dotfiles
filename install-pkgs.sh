#!/bin/bash

# applications
applications=("fd" "fzf" "bat" "docker" "docker-compose" "libreoffice-still" "ufw" "snap-pac" "reflector"
"mpv" "distrobox" "cups" "system-config-printer" "ttf-cascadia-code"
"yazi" "firefox" "podman" "thunderbird" "neovim" "qemu-desktop" "libvirt" 
"virt-manager" "dnsmasq" "iptables-nft" "flatpak" "fastfetch" "ttf-roboto-nerd-font"
"ttf-hack-nerd" "thunar" "stow" "libnotify" "thunar-volman" "thunar-archive-plugin" 
"tumbler" "network-manager-applet" "azote" "xarchiver" "udisks2" "cliphist"
"wl-clipboard" "polkit" "polkit-gnome" "nwg-look" "blueman" "xdg-user-dirs" "noto-fonts" "xdg-desktop-portal"
"xdg-desktop-portal-wlr" "swappy" "papirus-icon-theme" "imv" "fuzzel" "gvfs" 
"gvfs-afc" "gvfs-mtp" "gvfs-nfs" "gvfs-smb" "gparted")

# update archlinux
sudo pacman -Syu 
# install packages
sudo pacman -S "${applications[@]}"
# create user directories
sudo xdg-user-dirs-update --force

# install paru AUR helper
cont=0
while [ $cont != 1 ]
do
    read -p "Install paru AUR helper? y for yes or n for no: " choice
    if [ "$choice" == "y" ]
    then
        sudo pacman -S --needed base-devel
        git clone https://aur.archlinux.org/paru.git && cd paru
        makepkg -si
        paru -S brave-bin
        paru -S visual-studio-code-bin
        cont=1
    elif [ "$choice" == "n" ]
    then
        echo "---user skipped paru installation---"
        cont=1
    else
        echo "Not an option."
    fi
done

# start and enable services
echo "---starting services---"
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now ufw.service
sudo ufw enable
sudo systemctl enable --now systemd-resolved.service
sudo systemctl enable --now docker.service
sudo systemctl start libvirtd
echo "---done enabling services---"

# start virsh
sudo virsh net-start default
sudo virsh net-autostart default

# use reflector to sort fastest mirrors in Canada and United States
echo "---sorting mirrorlist in Canada and United States, fastest 20, https, sorted by rate---"
sudo reflector --country "Canada,United States" --protocol https --score 50 --fastest 20 --sort rate --save /etc/pacman.d/mirrorlist
