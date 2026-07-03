vim.lsp.enable {
    "lua_ls",
    "vimls",
    "rust_analyzer",
    "pyright",
    "asm_lsp",
    "jdtls",
}

local capabilities = require("blink-cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

vim.g.rustaceanvim = {
    server = {
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
                check = { command = "clippy" },
                diagnostics = {
                    enable = true,
                    experimental = { enable = true },
                },
            },
        },
    },
}

local lua_library = vim.api.nvim_get_runtime_file("", true)

table.insert(lua_library, "${3rd}/luv/library")
table.insert(lua_library, "${3rd}/luassert/library")
table.insert(lua_library, "${3rd}/busted/library")

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                -- globals = {
                --     "vim",
                -- },
            },
            workspace = {
                library = lua_library,
                -- checkThirdParty = true,
            },
        },
    },
})

vim.lsp.config("pyright", {})

vim.lsp.config('asm_lsp', {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'nasm', 'gas' },
    root_markers = { '.git' },
})

vim.lsp.enable('asm_lsp')
