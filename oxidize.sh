#!/bin/sh

set -e

# Install Rust
if [ -e "$HOME/.cargo" ]; then
  echo "Rust is already installed"
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Bat

if [ -e "$HOME/.cargo/bin/bat" ]; then
  echo "Bat is already installed"
else
  cargo install bat
fi

# Ripgrep

if [ -e "$HOME/.cargo/bin/rg" ]; then
  echo "Ripgrep is already installed"
else
  cargo install ripgrep
fi

# Exa

if [ -e "$HOME/.cargo/bin/exa" ]; then
  echo "Exa is already installed"
else
  cargo install exa
fi

# Sccache

if [ -e "$HOME/.cargo/bin/sccache" ]; then
  echo "Sccache is already installed"
else
  cargo install sccache
fi

# Bob-nvim

if [ -e "$HOME/.cargo/bin/bob" ]; then
  echo "Bob-nvim is already installed"
else
  cargo install bob-nvim
fi

rustup component add rust-analyzer
