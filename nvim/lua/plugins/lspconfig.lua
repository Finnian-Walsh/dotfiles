return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function()
            require("mason").setup{}
        end,
    }, {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function()
            require("mason-lspconfig").setup{
                ensure_installed = { "rust_analyzer", "lua_ls", },
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show lsp documentation" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to lsp declaration" })
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic" })
            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename a variable" })

            local capabilities = require("blink-cmp").get_lsp_capabilities()
            vim.lsp.config("lua_ls", { capabilities = capabilities })
        end,
    },
}
