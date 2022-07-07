#!/bin/sh
#
# On macOS (Darwin) run the following command:
#   /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamespole/myconf/main/myconf.sh)"
#

if [ "$(uname)" == 'Darwin' ]; then
    echo 'INFO: Assuming macOS installation.'
fi
