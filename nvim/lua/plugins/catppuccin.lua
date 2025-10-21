return {
    "catppuccin/nvim",
    config = function()
        vim.g.catppuccin_flavour = "mocha"
        vim.cmd[[colorscheme catppuccin]]
    end,
}
