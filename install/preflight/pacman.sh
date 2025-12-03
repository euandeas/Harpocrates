# Configure pacman
sudo cp -f ~/.local/share/harpocrates/default/pacman/pacman.conf /etc/pacman.conf

# Refresh all repos
sudo pacman -Syu --noconfirm

