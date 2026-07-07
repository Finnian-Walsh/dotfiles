{ config, pkgs, ... }:

{
  config.programs.nvf = {
    enable = true;
  };

  config.vim = {
    theme.enable = true;

    lsp = {
    enable = true;
    servers = {
        lua = "lua-ls";
    };
    startPlugins = {
      "snacks-nvim" = {
        package = "snacks-nvim";

        setupModule = "snacks";
        setupOpts = { };
        after = "print('snacks loaded')";
      };
    };
  };
}
