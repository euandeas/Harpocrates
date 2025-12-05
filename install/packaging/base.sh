# Install all base packages
mapfile -t packages < <(grep -v '^#' "$HARPOCRATES_INSTALL/base.packages" | grep -v '^$')

sudo pacman -Sy --needed --noconfirm base-devel
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd -
rm -rf yay
cd ~

yay -S --noconfirm --needed "${packages[@]}"
