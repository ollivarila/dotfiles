{
  pkgs,
  unfree,
  ...
}:
let
  font-family = "JetBrainsMono Nerd Font Mono";
in
{
  home.username = "olli";
  home.homeDirectory = "/home/olli";
  nixpkgs.config.allowUnfree = unfree;
  home.packages = with pkgs; [
    metronome
    nodejs_22
    discord
    pnpm
    google-chrome
    spotify
    playerctl
    awscli2
    lazygit
    clojure
    tor
    tor-browser
    btop
    bat
    alacritty
    neovim
    eza
    fzf
    git
    ripgrep
    tmux
    jq
    tree-sitter
    fd
    # nixfmt-rfc-style not sure what this is
    nixfmt
    vlc
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" ];
    })
    cargo-watch
    cargo-insta
    cargo-expand
    deluge
  ];
  programs.home-manager.enable = true;

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
        font.normal.family = font-family;
        font.size = 12;
        general.import = [ "~/.config/alacritty/theme.toml" ];
      };
    };
    zsh = {
      enable = true;
      initContent =
        let
          content = builtins.readFile ../.zshrc;
          conf = pkgs.lib.mkOrder 1000 content;
          extra = pkgs.lib.mkOrder 1200 ''
            alias reload='hyprctl reload && pkill waybar; hyprctl dispatch exec waybar'
            alias xclip=wl-copy
            alias hm='home-manager switch --flake ~/dotfiles/nixos'
            alias rb='sudo nixos-rebuild switch --flake ~/dotfiles/nixos'
          '';
        in
        pkgs.lib.mkMerge [
          conf
          extra
        ];
    };
    git = {
      enable = true;
      settings.user = {
        name = "Olli Varila";
        email = "olli.varila@gmail.com";
      };
    };
    tmux = {
      enable = true;
      extraConfig = builtins.readFile ../.tmux.conf;
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
          font = "${font-family}:size=16";
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

  home.stateVersion = "24.05";
}
