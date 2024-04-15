# Dotfiles

## Stuff to remember

### Clean setup

- install [mage](https://github.com/ollivarila/mage) (need cargo for this)
- clone repo with `mage clone ollivarila/dotfiles` (ssh-keys need to be set)
- run `mage link`
- run `./oxidize.sh`
- run `./install.sh`
- install gnome-shell extensions
  - [user-themes](https://extensions.gnome.org/extension/19/user-themes/)
  - [tophat](https://extensions.gnome.org/extension/5219/tophat/)
- configure gnome with gnome tweaks
  - icons
  - theme
  - cursor
  - tophat

Quick copy paste:
```sh
mage clone ollivarila/dotfiles
mage link
~/.mage/oxidize.sh
~/.mage/install.sh
```

## Plans

- create and host an quick setup script (similiar how you install rust)
