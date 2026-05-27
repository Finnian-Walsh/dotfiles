local plugins = {}

vim.list_extend(plugins, {
    "https://github.com/ChaseRensberger/christmas.nvim",
    "https://github.com/folke/tokyonight.nvim",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/ellisonleao/gruvbox.nvim",
})

vim.list_extend(plugins, {
    "https://github.com/goolord/alpha-nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.list_extend(plugins, {
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
})

if current_month == 12 then
    vim.list_extend(plugins, {
        "marcussimonsen/let-it-snow.nvim",
    })
end

vim.list_extend(plugins, {
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
})

return plugins
