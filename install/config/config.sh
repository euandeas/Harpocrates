# Copy over Harpocrates configs
mkdir -p ~/.config
cp -R ~/.local/share/harpocrates/config/* ~/.config/

# Use default bashrc from Harpocrates
cp ~/.local/share/harpocrates/default/bashrc ~/.bashrc
