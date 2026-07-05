{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      laptopModules = [
        ./modules/common.nix
        ./hosts/laptop/hardware-configuration.nix
      ];
    in
    {
      nixosConfigurations."laptop" = lib.nixosSystem {
        system = "${system}";
        modules = laptopModules;
      };

      nixosConfigurations."laptopServer" = lib.nixosSystem {
        system = "${system}";
        modules = laptopModules ++ [
          ./modules/minecraft-server.nix
        ];
      };
    };
}
