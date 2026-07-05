{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-utils.url = "github:numtide/flake-utils";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix-minecraft,
    }:
    let
      lib = nixpkgs.lib;
      laptopModules = [
        ./modules/common.nix
        ./hosts/laptop/hardware-configuration.nix
      ];
    in
    {
      nixosConfigurations.laptop = lib.nixosSystem {
        system = "x86_64-linux";
        modules = laptopModules;
      };

      nixosConfigurations.laptopServer = lib.nixosSystem {
        system = "x86_64-linux";
        modules = laptopModules ++ [
          ./modules/mc-server.nix
        ];
      };
    };
}
