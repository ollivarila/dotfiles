{
  pkgs,
  unfree,
  ...
}:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  environment.systemPackages = with pkgs; [
    curl
    unzip
    docker
    nwg-displays
    hyprpaper
    greetd.tuigreet
    waybar
    openrgb-with-all-plugins
    dunst # notification daemon
    libnotify # library for sending notifications
    feh # image viewer
    wl-clipboard
    grim # grab images from wayland compositor
    slurp # select region in wayland compositor
    pwvucontrol # volume control
    lm_sensors # TODO: not sure if needed
    file # show file types
  ];

  services.hardware.openrgb.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true; # TODO: not available in home-manager somehow?
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = unfree;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

  environment.etc."greetd/environments".text = "hyprland";

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
  ];

  virtualisation.docker.enable = true;
  networking.firewall.enable = true;

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

  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

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
