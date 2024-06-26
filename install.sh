#!/bin/sh

set -e

[ $(uname) = "Darwin" ] && echo "This script is linux only" && exit 1
[ "$USER" = "root" ] && echo "Please run as non-root user, I will prompt for sudo" && exit 1

# Create ~/.bin if it doesn't exist
[ ! -d ~/.bin ] && mkdir ~/.bin

REQUIRE_RESTART=false
UNAME=$(uname -r | awk -F '-' '{print $NF}' )

# Basic tools
echo "Installing tools"
sudo apt-get update > /dev/null
if [ $UNAME = "WSL2" ]; then 
    sudo apt install -y curl git zsh
else
    sudo apt install -y curl git xclip fzf zsh
fi
echo "Tools installed\n"

# lazygit
if [ -e /usr/local/bin/lazygit ]; then
    echo "Lazygit is already installed"
else
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
    echo "Lazygit installed"
fi

# docker
if [ -e /usr/bin/docker ]; then
    echo "Docker is already installed"
else
    if [ $UNAME = "WSL2" ]; then 
        echo "Using WSL2 skipping docker"
    else
        echo "Installing docker..."
        curl -fsSL https://get.docker.com | sh
        echo "Docker installed"

        sudo usermod -aG docker $USER
        echo "Added $USER to docker group"
        REQUIRE_RESTART=true
    fi
fi


# nvm
if [ -e ~/.nvm ]; then
    echo "nvm is already installed"
else
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    echo "nvm installed"

    echo "Configuring node..."
    nvm install 20
    nvm use 20
    echo "Node configured"
fi

# pnpm
if [ -e ~/.local/share/pnpm ]; then
    echo "pnpm is already installed"
else 
    echo "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    echo "pnpm installed"
fi

# fzf
if [ -e ~/.bin/fzf ]; then
    echo "fzf is already installed"
else
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    mv ~/.fzf/bin/fzf ~/.bin/fzf
    rm -rf ~/.fzf
    echo "fzf installed"
fi

echo "Install complete"

if [ $REQUIRE_RESTART = true ]; then
    echo "Restart is required for all changes to take effect"
fi

