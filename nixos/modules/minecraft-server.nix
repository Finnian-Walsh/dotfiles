{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      testing = {
        enable = true;
        package = pkgs.fabricServers.fabric-26_1_2;

        serverProperties = {

        };

        # whitelist = {
        #     "R",
        # };
      };
    };
  };
}
