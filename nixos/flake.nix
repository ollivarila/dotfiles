{
  description = "NixOs config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    metronome = {
      url = "github:ollivarila/metronome";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs =
    {
      nixpkgs,
      home-manager,
      rust-overlay,
      metronome,
      herdr,
      ...
    }:
    let
      system = "x86_64-linux";
      custom-packages = final: prev: {
        metronome = metronome.packages.${system}.default;
        herdr = herdr.packages.${system}.default;
      };
      overlays = [
        rust-overlay.overlays.default
        custom-packages
      ];
      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
      };
      unfree = true;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit unfree; };
        modules = [
          ./configuration.nix
        ];
      };
      homeConfigurations = {
        olli = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit unfree; };
          modules = [ ./home.nix ];
        };
      };
    };
}
