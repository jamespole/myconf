#!/bin/sh
#
# On systems with wget (e.g. Debian) run the following command:
#  /bin/sh -c "$(wget -q -O - -- https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#
# On systems with curl (e.g. macOS) run the following command:
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#

if [ "$(uname)" = 'Darwin' ]; then
    echo 'INFO: Assuming macOS.'
    brew update
    brew upgrade
    brew install \
        bash \
        borgbackup \
        ffmpeg \
        shellcheck \
        vim
elif [ -f '/etc/debian_version' ]; then
    echo 'INFO: Assuming Debian.'
    sudo apt update
    sudo apt upgrade
else
    echo 'ERROR: Could not detect operating system.' && exit 1
fi
