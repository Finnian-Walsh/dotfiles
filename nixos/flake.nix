{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-utils.url = "github:numtide/flake-utils";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nvf,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      nvfModules = [
        nvf.nixosModules.default
        ./modules/nvf.nix
      ];

      laptopModules = nvfModules ++ [
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
