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
    openssl.dev
    pkg-config
    python3
    ripgrep
    rustup
    tokei
    tree
    unzip
    vim
    wget
    zellij
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      view = "nvim -RO";
    };

    interactiveShellInit = ''
      export EDITOR=nvim
      set -o vi
      export PATH=$PATH:/usr/local/
    '';
  };

  services.tailscale.enable = true;
}
