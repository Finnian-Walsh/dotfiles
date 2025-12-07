return {
    { "EdenEast/nightfox.nvim" },
    {
        "everviolet/nvim",
        name = "evergarden",
    },
    {
        "ChaseRensberger/christmas.nvim",
        name = "christmas",
    },
    { "folke/tokyonight.nvim", },
    {
        "catppuccin/nvim",
        config = function()
            vim.g.catppuccin_flavour = "mocha"
            vim.cmd[[colorscheme catppuccin]]
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        opts = {},
    },
}
