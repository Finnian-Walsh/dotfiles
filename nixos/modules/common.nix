{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    appimage-run
    cowsay
    curl
    ed
    fastfetch
    git
    htop
    lolcat
    openssl
    pkg-config
    python3
    ripgrep
    rustup
    tailscale
    tokei
    unzip
    vim
    wget
    zellij
  ];
}
