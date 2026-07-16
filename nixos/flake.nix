{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      laptopModules = [
        ./modules/common.nix
        ./modules/neovim.nix
        ./hosts/monolithic/configuration.nix
        ./hosts/laptop/hardware-configuration.nix
      ];

      desktopModules = [
        ./modules/common.nix
        ./modules/neovim.nix
        ./hosts/monolithic/configuration.nix
        ./hosts/desktop/hardware-configuration.nix
      ];

      mini-pcModules = [
        ./modules/common.nix
        ./modules/neovim.nix
        ./hosts/mini-pc/configuration.nix
        ./hosts/mini-pc/hardware-configuration.nix
        ./modules/minecraft-server.nix
      ];
    in
    {
      nixosConfigurations."laptop" = lib.nixosSystem {
        system = "${system}";
        modules = laptopModules;
        specialArgs = { inherit inputs; };
      };

      nixosConfigurations."laptopServer" = lib.nixosSystem {
        system = "${system}";
        modules = laptopModules ++ [
          ./modules/minecraft-server.nix
        ];
        specialArgs = { inherit inputs; };
      };

      nixosConfigurations."desktop" = lib.nixosSystem {
        system = "${system}";
        modules = desktopModules;
        specialArgs = { inherit inputs; };
      };

      nixosConfigurations."mini-pc" = lib.nixosSystem {
        system = "${system}";
        modules = mini-pcModules;
        specialArgs = { inherit inputs; };
      };
    };
}
