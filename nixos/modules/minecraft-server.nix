{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jdk25_headless
    udev
  ];
}
