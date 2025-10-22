return {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
        vim.g.catppuccin_flavour = "mocha"
        vim.cmd[[colorscheme catppuccin]]
    end,
}
