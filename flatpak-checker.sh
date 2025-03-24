# !/bin/bash

# Hook installation:
# file: /etc/apt/apt.conf.d/05flatpak-hook 
# contents: APT::Update::Post-Invoke {"/my/path/to/this/file/flatpak-checker.sh"};

echo "Checking Flatpak updates available..."
USR="$USER" # Switch  back to curent user instead of sudo:root
if [ $USER = "root" ]; then USR="$SUDO_USER"; fi

# Get updates
UPDATES=$(sudo -u "$USR" 'n\n' 2>/dev/null | flatpak update | grep -Eo "^[\ ]*[0-9]+\..*" --color=none)
UPDATES_NB=$(echo "$UPDATES" | sed -z '$ s/\n$//' | wc -l)

if [ $UPDATES_NB = "0" ]; then
	echo "Flatpak: No Updates found, skipping..."
	exit
fi

echo "[i] $UPDATES_NB FlatPak updates found"
echo "$UPDATES"
echo '[i] To udpdate, make sure you run "flatpak update"'
