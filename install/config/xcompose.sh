# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
include "%H/.local/share/harpocrates/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$HARPOCRATES_USER_NAME"
<Multi_key> <space> <e> : "$HARPOCRATES_USER_EMAIL"
EOF
