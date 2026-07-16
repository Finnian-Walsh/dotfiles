{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    udev
    jdk25_headless
  ];
}
