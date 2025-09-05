return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup{}
    end,
  }, {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup{
        ensure_installed = { "rust_analyzer", "lua_ls", },
      }
    end,
  }, {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.rust_analyzer.setup{
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
            check = { command = "clippy" },
          },
        }
      }

      lspconfig.lua_ls.setup{}
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show lsp documentation" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to lsp declaration" })
      vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "Lsp code actions" })
    end,
  },
}
