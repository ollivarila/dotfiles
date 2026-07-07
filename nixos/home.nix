{
  config,
  pkgs,
  unfree,
  ...
}:
let
  username = "olli";
  font-family = "JetBrainsMono Nerd Font Mono";
  dotfilesDir = "/home/${username}/dotfiles";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  nixpkgs.config.allowUnfree = unfree;
  home.packages = with pkgs; [
    metronome
    herdr
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
      extensions = [
        "rust-analyzer"
        "rust-src"
      ];
    })
    cargo-watch
    cargo-insta
    cargo-expand
    deluge
    gcc
    signal-desktop
    uv
    python3
    gh
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

  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/herdr/config.toml";

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nvim";

  # Hyprland itself is enabled at the system level (programs.hyprland.enable
  # in configuration.nix, launched via greetd), so we deliberately don't use
  # the wayland.windowManager.hyprland home-manager module here — it wants to
  # manage the whole session/package lifecycle itself and conflicts with that.
  # Just symlink the config files straight from dotfiles instead.
  home.file.".config/hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hyprland/hyprland.conf";
  home.file.".config/hypr/monitors.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hyprland/monitors.conf";
  home.file.".config/hypr/hyprpaper.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hyprland/hyprpaper.conf";
  home.file.".config/hypr/workspaces.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hyprland/workspaces.conf";

  home.file.".config/waybar/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/waybar/config";
  home.file.".config/waybar/extra.css".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/waybar/extra.css";

  home.file.".config/dunst/dunstrc".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/dunst/dunstrc";

  programs = {
    ghostty = {
      enable = true;
      settings = {
        font-family = font-family;
        font-size = 12;
        cursor-style = "bar";
      };
    };
    zsh = {
      enable = true;
      initContent = pkgs.lib.mkMerge [
        (pkgs.lib.mkOrder 1000 "source ${dotfilesDir}/.zshrc")
        (pkgs.lib.mkOrder 1200 "source ${dotfilesDir}/.zsh_aliases")
      ];
    };
    git = {
      enable = true;
      ignores = [ "**/.claude/settings.local.json" ];
      settings.user = {
        name = "Olli Varila";
        email = "olli.varila@gmail.com";
      };
    };
    tmux = {
      enable = true;
      extraConfig = "source-file ${dotfilesDir}/.tmux.conf";
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
