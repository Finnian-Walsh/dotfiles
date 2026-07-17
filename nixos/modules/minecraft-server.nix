{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jdk25_headless
    udev
  ];

  networking.firewall.allowedTCPPorts = [
    25565
    19132
  ];

  services.udev.enable = true;
}
