{ pkgs, ... }:
let
  unfree = true;
in
{
  home.username = "olli";
  home.homeDirectory = "/home/olli";
  nixpkgs.config.allowUnfree = unfree;
  home.packages = with pkgs; [
    firefox
    fastfetch
    nodejs_22
    discord
    pnpm
    hyprpaper
    google-chrome
    spotify
    playerctl
    rustup
    awscli2
    lazygit
    clojure
    deno
    tor
    tor-browser
  ];

  home.pointerCursor = {
    name = "Posy_Cursor";
    package = pkgs.posy-cursors;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };
    iconTheme = {
      name = "kora";
      package = pkgs.kora-icon-theme;
    };
  };

  home.file.".config/alacritty/theme.toml".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/gruvbox_dark.toml";
    sha256 = "85da5eac732cb89ba0a1d334232b9e255e901f4978d3e5eb5512a71d14116ea7";
  };
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font.normal.family = "Ubuntu Mono Nerd Font Mono";
        # font.normal.family = "Hack Nerd Font Mono Regular"; # broken :(
        # font.normal.style = "Regular";
        font.size = 12;
        general.import = [ "~/.config/alacritty/theme.toml" ];
      };

    };
    zsh = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Olli Varila";
      userEmail = "olli.varila@gmail.com";
    };
    waybar = {
      enable = true;
      style = ''
        @import url("extra.css");
      '';
    };
    fuzzel = {
      enable = true;
      settings = {
        colors = {
          background = "282828ff";
          border = "fe8019ff";
        };
        main = {
          font = "Ubuntu Mono Nerd Font Mono:size=16";
          lines = 5;
          inner-pad = 8;
          icon-theme = "kora";
        };
        border = {
          width = 1;
          radius = 4;
        };
      };
    };
    gpg = {
      enable = true;
    };
  };

  home.file.".tmux.conf".source = ../.tmux.conf;
  home.file.".zshrc".text = builtins.readFile ../.zshrc + ''
    alias reload='hyprctl reload && pkill waybar; hyprctl dispatch exec waybar'
    alias xclip=wl-copy
    export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}"
  '';

  home.stateVersion = "24.05";
}
