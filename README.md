# Portable Configuration Script

This repository houses my portable configuration script.

## Goals

1. **I wanted a single configuration script I could use on Arch, Debian and macOS.** 
I use all three systems on a daily basis.
It was getting annoying having to sync various things (e.g. changes to my .vimrc) across all my configuration scripts.

2. **I wanted to be able to use a one-liner to fetch the script from the web and run locally.**
I loved how certain software (e.g. Homebrew) have a simple one-liner command to fetch a script and run it.
This approach avoids the need for syncing my script across machines using e.g. `git` or `rsync`.
I can simply run the one-liner and be assured I am using the latest version of the script.

## Principles

1. **Portability:** Use plain old POSIX `sh`.
2. **Simplicity:** Use commands pre-installed by the system.
3. **Consistency:** Do the same thing on all systems.
4. **Minimality** Do only what is needed to achieve the desired state.
4. **Reliability:** Test scripts with `shellcheck`.

### Simplicity Examples

* Use `curl` on Arch/macOS as that is the command pre-installed on that system.
* Use `wget` on Debian as that is the command pre-installed on that system.
* Use `bash` on Debian/macOS as that is the shell pre-installed on that system

### Minimality Examples

* Assume 'bash' and 'sudo' is installed on Debian/macOS and don't install it.
* Assume 'vim' is installed on macOS and don't install it.
