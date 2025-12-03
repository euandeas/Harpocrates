if [ "$(plymouth-set-default-theme)" != "harpocrates" ]; then
  sudo cp -r "$HOME/.local/share/harpocrates/default/plymouth" /usr/share/plymouth/themes/harpocrates/
  sudo plymouth-set-default-theme harpocrates
fi
