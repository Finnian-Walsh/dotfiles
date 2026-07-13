vim.lsp.enable {
    "asm_lsp",
    "basedpyright",
    "cssls",
    "eslint",
    "jdtls",
    "lua_ls",
    "nixd",
    "rust_analyzer",
    "vim-language-server",
}

-- local capabilities = require("blink-cmp").get_lsp_capabilities()
-- vim.lsp.config("*", { capabilities = capabilities })

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

-- local lua_library = vim.api.nvim_get_runtime_file("", true)
--
-- table.insert(lua_library, "${3rd}/luv/library")
-- table.insert(lua_library, "${3rd}/luassert/library")
-- table.insert(lua_library, "${3rd}/busted/library")

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            -- workspace = {
            --     library = lua_library,
            -- },
            format = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("pyright", {})

vim.filetype.add {
    extension = {
        asm = "nasm",
    },
}

vim.lsp.config("asm_lsp", {
    cmd = { "asm-lsp" },
    filetypes = { "asm", "nasm", "gas" },
    root_markers = { ".git" },
})

vim.api.nvim_create_user_command("NasmConfig", function()
    print([[[default_config]
version = "0.10.0"
assembler = "nasm"
instruction_set = "x86"

[default_config.opts]
compiler = "nasm"
compile_flags_txt = []
diagnostics = true
default_diagnostics = true]])
end, { nargs = 0 })

vim.lsp.config("vim-language-server", {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    root_markers = { ".git", "init.vim" },
    init_options = {
        diagnostic = { enable = true },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { ".git", "autoload", "plugin" },
            runtimepath = true,
        },
        isNeovim = true,
        isKeyword = "@,48-57,_,192-255,#",
        suggest = { fromRuntimepath = true },
    },
})
