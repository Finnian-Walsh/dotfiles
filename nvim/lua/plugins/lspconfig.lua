return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function()
            if vim.uv.os_getenv("TERMUX_VERSION") then
                return
            end

            require("mason").setup {}

            local ensure_installed = {
                "stylua",
                "rust_analyzer",
                "lua_ls",
                "pyright",
                "asm_lsp",
            }

            if not vim.uv.os_getenv("NO_CLANGD") then
                table.insert(ensure_installed, "clangd")
            end

            require("mason-lspconfig").setup {
                ensure_installed = ensure_installed,
            }
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

            vim.g.rustaceanvim = {
                server = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            checkOnSave = { command = "clippy" },
                            check = { command = "clippy" },
                            diagnostics = {
                                enable = true,
                                experimental = { enable = true },
                            },
                        },
                    },
                },
            }

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = {
                                "vim",
                            },
                        },
                    },
                },
            })

            vim.lsp.config("pyright", {})
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        priority = 49,
        version = "*",
        lazy = false,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = { "rustfmt" },
            },
            format_on_save = {
                timeout_ms = 5000,
            },
        },
    },
}
