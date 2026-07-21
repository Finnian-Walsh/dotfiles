{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vscodium
  ];

  # put some config here later ok
}
