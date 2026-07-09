if vim.env.AUTO_MASON_INSTALL ~= "1" then
    return
end

require("mason").setup {}

vim.keymap.set("n", "<leader>M", vim.cmd.Mason, { desc = "Open Mason" })

local ensure_installed = {
    -- Vimscript
    "vimls",
    -- Lua
    "stylua",
    -- Rust
    "rust_analyzer",
    -- Lua
    "lua_ls",
    -- Python
    "pyright",
    "ruff",
    -- Asm
    "asm_lsp",
    -- Web dev
    "ts_ls",
    "html",
    "cssls",
    "eslint",
    -- Java
    "jdtls",
}

if vim.uv.os_getenv("NO_CLANGD") ~= "1" then
    table.insert(ensure_installed, "clangd")
end

vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        require("mason-lspconfig").setup {
            ensure_installed = ensure_installed,
        }
    end,
})
