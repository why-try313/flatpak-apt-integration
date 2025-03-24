A simple script to check for flatpak updates when `apt update` runs
You can grab the file [flatpak-checker.sh](https://github.com/why-try313/flatpak-apt-integration/blob/b12683b72a6925cb6655ccf143d5bf773e7485d6/flatpak-checker.sh) or copy paste the code below (same content as the file)

```bash
# !/bin/bash

# Hook installation:
# file: /etc/apt/apt.conf.d/05flatpak-hook 
# contents: APT::Update::Post-Invoke {"/my/path/to/this/file/flatpak-checker.sh"};

echo "Checking Flatpak updates availible..."
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
```

### Installation
As the first comments of the file say:
1. create your `/etc/apt/apt.conf.d/05flatpak-hook` (name it at your conveninece)
2. Paste and edit the path to your flatpak-checker.sh: `APT::Update::Post-Invoke {"/my/path/to/this/file/flatpak-checker.sh"};`
3. That's pretty much it


### Usage
Just run `sudo apt update`, the hook will check for updates and display them if there's any
