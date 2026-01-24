{
  pkgs,
  ...
}:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  unfree = true;
in
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  programs.nix-ld.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      cores = 0;
      max-jobs = "auto";
    };
  };

  nixpkgs.config.allowUnfree = unfree;

  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
    };
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.windowManager.i3.enable = true;
  services.hardware.openrgb.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.sessionVariables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  # Keyboard stuff
  # NOTE: This is not used in XWayland because WM/DE controls input
  services.xserver = {
    xkb.layout = "us";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.etc."greetd/environments".text = ''hyprland'';

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.root = {
    initialHashedPassword = "";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.olli = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs.steam.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = "google-chrome.desktop";
    "image/png" = "feh";
    "image/jpg" = "feh";
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/about" = "google-chrome.desktop";
    "x-scheme-handler/unknown" = "google-chrome.desktop";
  };
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    mixxx
    vim
    neovim
    wget
    curl
    unzip
    alacritty
    docker
    nwg-displays
    btop
    bat
    eza
    fzf
    git
    greetd.tuigreet
    gcc
    ripgrep
    tmux
    waybar
    openrgb-with-all-plugins
    dunst
    libnotify
    jq
    openssl
    pkg-config
    feh
    yazi
    tree-sitter
    python3
    wl-clipboard
    fd
    nixfmt-rfc-style
    grim
    slurp
    inotify-tools
    pwvucontrol
    lm_sensors
    file
    vlc
    gnumake
    alsa-lib.dev
  ];

  virtualisation.docker.enable = true;

  networking.firewall.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
