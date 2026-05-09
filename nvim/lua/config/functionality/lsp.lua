require("mason").setup {}

local ensure_installed = {
    "stylua",
    "rust_analyzer",
    "lua_ls",
    "pyright",
    "asm_lsp",
    "ruff",
}

if not vim.uv.os_getenv("NO_CLANGD") then
    table.insert(ensure_installed, "clangd")
end

require("mason-lspconfig").setup {
    ensure_installed = ensure_installed,
    automatic_enable = { exclude = { "rust_analyzer" } },
    -- ignore_install = { "rust_analyzer" },
}

require("conform").setup {
    options = {
        formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "ruff_format" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt" },
        },
        format_on_save = {
            timeout_ms = 5000,
        },
    },
}

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
