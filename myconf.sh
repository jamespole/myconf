#!/bin/sh
#
# On macOS (Darwin) run the following command:
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#

if [ "$(uname)" = 'Darwin' ]; then
    echo 'INFO: Assuming macOS.'
    brew update
    brew upgrade
elif [ -f '/etc/debian_version' ]; then
    echo 'INFO: Assuming Debian.'
    sudo apt update
    sudo apt upgrade
else
    echo 'ERROR: Could not detect operating system.'
fi
