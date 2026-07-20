if vim.env.USE_MASON ~= "1" then
    return false
end

return {
    plugins = {
        "https://github.com/mason-org/mason.nvim",
        "https://github.com/mason-org/mason-lspconfig.nvim",
    },

    opts = {
        mason = {},
        ["mason-lspconfig"] = {
            ensure_installed = {
                -- Vimscript
                "vimls",
                -- Lua
                "stylua",
                -- Rust
                "rust_analyzer",
                -- Lua
                "lua_ls",
                -- Python
                "basedpyright",
                "ruff",
                -- Asm
                "asm_lsp",
                -- Web dev
                "typescript-language-server",
                "html",
                "cssls",
                "eslint",
                -- Java
                "jdtls",

                vim.env.NO_CLANGD ~= "1" and "clangd" or nil,
            },
        },
    },

    config = function()
        vim.keymap.set("n", "<leader>M", vim.cmd.Mason, { desc = "Open Mason" })
    end,
}
