#!/bin/sh
#
# On systems with wget (e.g. Debian) run the following command:
#  /bin/sh -c "$(wget -q -O - -- https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#
# On systems with curl (e.g. Arch, macOS) run the following command:
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#

if [ "$(id -u)" -eq 0 ]; then
    echo 'ERROR: Do not execute this script as root.' && exit 1
fi

if [ "$(uname)" = 'Darwin' ]; then
    echo 'INFO: Assuming macOS.'
    brew update
    brew upgrade
    for brew_package in bash borgbackup ffmpeg shellcheck vim; do
        if brew list "$brew_package" > /dev/null 2>&1; then
            echo "INFO: Homebrew package <${brew_package}> already installed. Skipping."
        else
            echo "ACTION: Installing Homebrew package <${brew_package}>."
            brew install "$brew_package"
        fi
    done
elif [ -f '/etc/debian_version' ]; then
    echo 'INFO: Assuming Debian.'
    sudo apt update
    sudo apt upgrade
else
    echo 'ERROR: Could not detect operating system.' && exit 1
fi
