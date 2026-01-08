return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        opts = {},
    }, {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function()
            if vim.uv.os_getenv("TERMUX_VERSION") then
                return
            end

            require("mason").setup{
                ensure_installed = { "clang-format", },
            }

            local mason_lspconfig_ensure_installed = {
                "rust_analyzer", "lua_ls", "pyright", "asm_lsp",
            }

            if not vim.uv.os_getenv("NO_CLANGD") then
                table.insert(mason_lspconfig_ensure_installed, "clangd")
            end

            require("mason-lspconfig").setup{ ensure_installed = mason_lspconfig_ensure_installed }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        ft = { "lua", "rust", "c", "cpp", "python" },
        config = function()
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show lsp documentation" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to lsp definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to lsp declaration" })
            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename a variable" })
            vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { desc = "Code actions" })

            local capabilities = require("blink-cmp").get_lsp_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })

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
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = {
                                "vim",
                            }
                        },
                    }
                }
            })

            vim.lsp.config("pyright", {})
        end,
    },
}
