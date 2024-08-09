#!/bin/sh

set -e

what=$1

[ -z "$what" ] && echo "Usage: $0 <what>" && exit 1

case "$what" in
    "nvim")
        rm -rf ~/.config/nvim && cp -r ./nvim ~/.config/
        ;;
    *)
        echo "Invalid option: $what"
        exit 1
        ;;
esac

echo "Done syncing $what."
