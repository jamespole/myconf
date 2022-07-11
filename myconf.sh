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
# Remove unneeded packages
#

unneeded_packages='jdupes rclone rmlint'

if [ "${system}" = 'Debian' ]; then
    # shellcheck disable=SC2086
    sudo apt remove ${unneeded_packages} || exit 2
elif [ "${system}" = 'macOS' ]; then
    for unneeded_package in ${unneeded_packages}; do
        if brew list "${unneeded_package}" > /dev/null 2>&1; then
            # shellcheck disable=SC2086
            brew uninstall ${unneeded_package} || exit 2
        else
            echo "INFO: Homebrew package <${unneeded_package}> not installed. Skipping."
        fi
    done
elif [ "${system}" = 'Arch' ]; then
    # shellcheck disable=SC2086
    sudo pacman -Rs ${unneeded_packages} || exit 2
fi

#
# Upgrade packages
#

if [ "${system}" = 'Debian' ]; then
    sudo apt update || exit 2
    sudo apt upgrade || exit 2
elif [ "${system}" = 'macOS' ]; then
    brew update || exit 2
    brew upgrade || exit 2
elif [ "${system}" = 'Arch' ]; then
    sudo pacman -Syu || exit 2
fi

#
# Install packages
#

if [ "${system}" = 'Debian' ]; then
    sudo apt install -y \
        rsync \
        shellcheck \
        vim \
        || exit 2
    sudo apt autoremove -y || exit 2
elif [ "${system}" = 'macOS' ]; then
    for brew_package in bash-completion borgbackup fdupes ffmpeg jhead rsync shellcheck; do
        if brew list "$brew_package" > /dev/null 2>&1; then
            echo "INFO: Homebrew package <${brew_package}> already installed. Skipping."
        else
            echo "ACTION: Installing Homebrew package <${brew_package}>."
            brew install "$brew_package" || exit 2
        fi
    done
elif [ "${system}" = 'Arch' ]; then
    # NOTE: Do not install {ffmpeg,shellcheck} on Arch. It installs too many dependencies.
    sudo pacman -S --needed \
        bash \
        borg \
        fdupes \
        jhead \
        rsync \
        sudo \
        vim \
        || exit 2
fi

#
# Install bash configuration
#

rm ~/.bash_login ~/.profile

cat > ~/.bash_profile << 'EOF'
[[ -f ~/.bashrc ]] && . ~/.bashrc
EOF

cat > ~/.bashrc << 'EOF'
[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s histappend

export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=vim
export PAGER=less

alias ls="ls -GF"
alias more="less"
alias vi="vim"
alias view="vim"

if [ "x${BASH_COMPLETION_VERSINFO-}" = x ]; then
    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
fi

PS1="\[\e[0;1;31m\] [\u@\H] \[\e[34m\]{\w} \[\e[0m\]\n\$ "
EOF

#
# Install VIM configuration
#

cat > ~/.vimrc << 'EOF'
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
