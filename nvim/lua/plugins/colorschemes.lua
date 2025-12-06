return {
    {
        "catppuccin/nvim",
        config = function()
            vim.g.catppuccin_flavour = "mocha"
            vim.cmd[[colorscheme catppuccin]]
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup()
        end,
    },
}
