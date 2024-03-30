#!/bin/sh

set -e

if [ "$USER" = "root" ]; then
    echo "Please run as non-root user, I will prompt for sudo"
    exit 1
fi

# Basic tools
echo "Installing tools"
sudo apt-get update > /dev/null
sudo apt install -y curl git xclip
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
    echo "Installing docker..."
    curl -fsSL https://get.docker.com | sh
    echo "Docker installed"
fi

sudo usermod -aG docker $USER
echo "Added $USER to docker group"

echo "Install complete"
echo "You might want to restart your computer for changes to take effect"
