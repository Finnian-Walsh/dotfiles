return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup{}
    require("mason-lspconfig").setup{
      ensure_installed = { "rust_analyzer" },
    }
  end,
  dependencies = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig" },
}
