# Install all other packages
mapfile -t packages < <(grep -v '^#' "$HARPOCRATES_INSTALL/other.packages" | grep -v '^$')
sudo yay -S --noconfirm --needed "${packages[@]}"
