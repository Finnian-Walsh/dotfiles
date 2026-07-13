{ pkgs, ... }:
{
  # programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    neovim

    asm-lsp
    deno
    eslint
    fd
    gcc
    jdt-language-server
    lua-language-server
    nixd
    nixfmt
    nodejs
    prettierd
    superhtml
    stylua
    vim-language-server
  ];
}
