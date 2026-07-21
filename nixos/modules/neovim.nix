{ pkgs, ... }:
{
  # programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    neovim

    asm-lsp
    basedpyright
    deno
    eslint
    fd
    gcc
    jdt-language-server
    lazygit
    lua-language-server
    nixd
    nixfmt
    nodejs
    prettierd
    ruff
    superhtml
    stylua
    typescript-language-server
    vim-language-server
    vscode-json-languageserver
  ];
}
