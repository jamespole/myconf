#!/bin/sh
#
# myconf.sh: Portable configuration script.
#
# Copyright (c) 2022 James Anderson-Pole <james@pole.net.nz>
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
#
# On systems with wget (e.g. Debian) run the following command:
#  /bin/sh -c "$(wget -q -O - -- https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#
# On systems with curl (e.g. Arch, macOS) run the following command:
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#

if [ "$(id -u)" -eq 0 ]; then echo 'ERROR: Do not execute this script as root.' && exit 1; fi

#
# Detect system
#

if [ "$(uname)" = 'Darwin' ]; then system='macOS'
elif [ -f '/etc/debian_version' ]; then system='Debian'
elif [ -f '/etc/arch-release' ]; then system='Arch'
else echo 'ERROR: Could not detect operating system.' && exit 1; fi

echo "INFO: Detected system is <${system}>."

#
# Upgrade and install packages
#

if [ "${system}" = 'Debian' ]; then
    sudo apt update || exit 2
    sudo apt upgrade || exit 2
    sudo apt install -y \
        rsync \
        shellcheck \
        vim \
        || exit 2
    sudo apt autoremove -y || exit 2
elif [ "${system}" = 'macOS' ]; then
    brew update || exit 2
    brew upgrade || exit 2
    for brew_package in bash borgbackup fdupes ffmpeg jhead rsync shellcheck vim; do
        if brew list "$brew_package" > /dev/null 2>&1; then
            echo "INFO: Homebrew package <${brew_package}> already installed. Skipping."
        else
            echo "ACTION: Installing Homebrew package <${brew_package}>."
            brew install "$brew_package" || exit 2
        fi
    done
elif [ "${system}" = 'Arch' ]; then
    sudo pacman -Syu || exit 2
    # NOTE: Do not install {ffmpeg,shellcheck} on Arch. It installs too many dependencies.
    sudo pacman -S --needed \
        bash \
        borg \
        fdupes \
        jhead \
        rsync \
        vim \
        || exit 2
fi

#
# Install VIM configuration
#

cat > ~/.vimrc << EOF
filetype plugin indent on
set expandtab
set ruler
set scrolloff=5
set shiftwidth=4
set showcmd
set softtabstop=4
set tabstop=4
syntax on
EOF

#
# Install SSH keys
#

keys_source='https://github.com/jamespole.keys'
keys_target="$HOME/.ssh/authorized_keys"
if command -v wget > /dev/null 2>&1 ; then
    wget -O "${keys_target}" -- "${keys_source}" || exit 2
elif command -v curl > /dev/null 2>&1 ; then
    curl "${keys_source}" -o "${keys_target}" || exit 2
else
    echo 'ERROR: Could not detect wget or curl commands.' && exit 1
fi

#
# Finished
#

echo 'INFO: Finished.'
