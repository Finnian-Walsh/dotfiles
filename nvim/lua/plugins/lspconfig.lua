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
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = true,
                        check = { command = "clippy" },
                    },
                }
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                "vim",
                            }
                        }
                    }
                }
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show lsp documentation" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to lsp declaration" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp code actions" })
            vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end)
        end,
    },
}
