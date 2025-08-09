#!/bin/bash

# applications
applications=(
"fd" 
"fzf" 
"bat" 
"less"
"head"
"tree"
"zip"
"unzip"
"which"
"htop"
"man-db"
"logrotate"
"man-pages"
"docker" 
"docker-compose" 
"libreoffice-still" 
"ufw" 
"snap-pac" 
"reflector"
"mpv" 
"nmap"
"curl"
"ntfs-3g"
"distrobox" 
"playerctl"
"nm-connection-editor"
"base-devel"
"cups" 
"system-config-printer" 
"yazi" 
"chromium" 
"github-cli"
"mako"
"firefox"
"smartmontools"
"tmux"
"podman" 
"thunderbird" 
"vim"
"neovim" 
"qemu-desktop" 
"libvirt" 
"virt-manager" 
"dnsmasq" 
"iptables-nft" 
"flatpak" 
"fastfetch" 
"ttf-jetbrains-mono-nerd"
"ttf-hack-nerd" 
"ttf-cascadia-code"
"pacman-contrib"
"thunar" 
"stow" 
"libnotify" 
"thunar-volman" 
"thunar-archive-plugin" 
"tumbler" 
"xarchiver" 
"starship"
"zathura"
"zathura-pdf-poppler"
"jq"
"udisks2" 
"cliphist"
"wl-clipboard" 
"polkit" 
"polkit-gnome" 
"blueman" 
"noto-fonts" 
"xdg-user-dirs" 
"xdg-desktop-portal"
"xdg-desktop-portal-wlr" 
"papirus-icon-theme" 
"imv" 
"gcc"
"openssh"
"whois"
"inetutils"
"python"
"pyright"
"lua-language-server"
"cmake"
"make"
"ninja"
"fuzzel" 
"gvfs" 
"gvfs-afc" 
"gvfs-mtp" 
"gvfs-nfs" 
"gvfs-smb" 
"lm_sensors"
)

# Sync, update and install packages
sudo pacman -Syu "${applications[@]}"
# create user directories
sudo xdg-user-dirs-update --force

# install paru AUR helper
is_done=0
while [ $is_done != 1 ]
do
    read -p "Install paru AUR helper? y for yes or n for no: " choice
    if [ "$choice" == "y" ]
    then
        git clone https://aur.archlinux.org/paru.git && cd paru
        makepkg -si
        paru -S brave-bin
        paru -S visual-studio-code-bin
        is_done=1
    elif [ "$choice" == "n" ]
    then
        echo "--user skipped paru installation--"
        is_done=1
    else
        echo "--Not an option.--"
    fi
done

# start and enable services
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now ufw.service
sudo ufw enable
sudo systemctl enable --now systemd-resolved.service
sudo systemctl enable --now docker.service
sudo systemctl start libvirtd

# start virsh
sudo virsh net-start default
sudo virsh net-autostart default

# use reflector to sort fastest mirrors in Canada and United States
sudo reflector --country "Canada,United States" --protocol https --score 50 --fastest 20 --sort rate --save /etc/pacman.d/mirrorlist
