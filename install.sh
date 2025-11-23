#!/bin/bash

sudo pacman -Syu --noconfirm --needed git

rm -rf ~/.local/share/harpocrates/
git clone "https://github.com/euandeas/harpocrates.git" ~/.local/share/harpocrates/ >/dev/null

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Harpocrates locations
export HARPOCRATES_PATH="$HOME/.local/share/harpocrates"
export HARPOCRATES_INSTALL="$HARPOCRATES_PATH/install"
export HARPOCRATES_INSTALL_LOG_FILE="/var/log/harpocrates-install.log"
export PATH="$HARPOCRATES_PATH/bin:$PATH"

# Install
source "$HARPOCRATES_INSTALL/helpers/all.sh"
source "$HARPOCRATES_INSTALL/preflight/all.sh"
source "$HARPOCRATES_INSTALL/packaging/all.sh"
source "$HARPOCRATES_INSTALL/config/all.sh"
source "$HARPOCRATES_INSTALL/login/all.sh"
source "$HARPOCRATES_INSTALL/post-install/all.sh"