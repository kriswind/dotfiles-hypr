#!/bin/bash

# Update system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install dependencies
echo "Installing required dependencies..."
paru -S --needed --noconfirm hyprland wayland wlroots xorg-xwayland alacritty rofi waybar wlogout swaybg swaylock mako dunst \
    networkmanager network-manager-applet pipewire pipewire-pulse wireplumber pipewire-alsa pavucontrol brightnessctl \
    playerctl grim slurp swappy wlsunset xdg-desktop-portal-wlr xdg-desktop-portal wtype wlr-randr wdisplays \
    light pamixer zsh starship ttf-font-awesome ttf-jetbrains-mono noto-fonts noto-fonts-emoji \
    ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono polkit-gnome git feh btop exa bat neovim pacman-contrib jq unzip zip rsync

# Clone the repository
echo "Cloning configuration repository..."
git clone https://github.com/kriswind/dotfiles-hypr.git ~/dotfiles-hypr || {
    echo "Repository already exists, skipping clone."
}

# Backup existing configs
echo "Backing up existing configurations..."
mkdir -p ~/config-backup
cp -r ~/.config/hypr ~/.config/waybar ~/.config/alacritty ~/.config/rofi ~/.config/{other-configs} ~/config-backup 2>/dev/null || true

# Symlink configuration files
echo "Symlinking configuration files..."
ln -sf ~/dotfiles-hypr/hypr ~/.config/hypr
ln -sf ~/dotfiles-hypr/waybar ~/.config/waybar
ln -sf ~/dotfiles-hypr/alacritty ~/.config/alacritty
ln -sf ~/dotfiles-hypr/rofi ~/.config/rofi
ln -sf ~/dotfiles-hypr/{other-configs} ~/.config/{other-configs}

# Enable necessary services
echo "Enabling necessary services..."
sudo systemctl enable --now NetworkManager
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Create Hyprland session file
echo "Creating Hyprland session file..."
sudo bash -c 'cat > /usr/share/wayland-sessions/Hyprland.desktop' <<EOF
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland Session
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF

# Success message
echo "Installation completed successfully! Please log out and select Hyprland from your session menu."

