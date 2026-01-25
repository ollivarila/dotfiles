{
  description = "NixOs config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      rust-overlay,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [ rust-overlay.overlays.default ];
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
