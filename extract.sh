#!/bin/sh

set -e

# Font
if ! [ -e ./fonts/JetBrainsMonoNerdFont-Bold.ttf ]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
    mv ./JetBrainsMono.zip ./fonts
    unzip ./fonts/JetBrainsMono.zip -d ./fonts -x README.md OFL.txt
    rm ./fonts/JetBrainsMono.zip
fi

# Icons
if ! [ -e ./icons/Colloid-pastel/index.theme ]; then
    tar -xvf ./icons/Colloid-pastel.tar.gz -C ./icons
fi

# Cursor
if ! [ -e ./icons/Posy_Cursor_Black/index.theme ]; then
    tar -xvf ./icons/posy-s-cursor-black.tar.xz -C ./icons
fi

# Theme
if ! [ -e ./themes/Gruvbox-Dark-BL/index.theme ]; then
    unzip ./themes/Gruvbox-Dark-BL.zip -d ./themes
fi

