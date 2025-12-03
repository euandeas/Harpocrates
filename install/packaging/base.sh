# Install all base packages
mapfile -t packages < <(grep -v '^#' "$HARPOCRATES_INSTALL/base.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"

sudo pacman -Sy --needed --noconfirm base-devel
cd /tmp
rm -rf yay-bin
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd -
rm -rf yay-bin
cd ~
