local plugins = {}

vim.list_extend(plugins, {
    "https://github.com/saghen/blink.lib",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/Finnian-Walsh/blink.cmp",
    "https://github.com/saghen/blink.compat",
})

vim.list_extend(plugins, {
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/nvim-mini/mini.files",
    "https://github.com/nvim-mini/mini.surround",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/lewis6991/gitsigns.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/Finnian-Walsh/hooker.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://github.com/neovim/nvim-lspconfig",
})

vim.list_extend(plugins, {
    "https://github.com/nvim-neorg/neorg",
})

vim.list_extend(plugins, {
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/mfussenegger/nvim-dap-python",
})

vim.list_extend(plugins, {
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.list_extend(plugins, {
    "https://github.com/Finnian-Walsh/plugin-view.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/akinsho/toggleterm.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/mbbill/undotree",
})

vim.list_extend(plugins, {
    "https://github.com/folke/which-key.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/pogyomo/winresize.nvim",
})

-- vim.list_extend(plugins, {
--     {
--         src = "https://github.com/Finnian-Walsh/plugin-testing.nvim",
--         version = "✨",
--     },
-- })

return plugins
