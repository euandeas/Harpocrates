# Install all base packages
mapfile -t packages < <(grep -v '^#' "$HARPOCRATES_INSTALL/base.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"
sudo pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm
