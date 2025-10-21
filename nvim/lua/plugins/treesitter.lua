return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup{
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = { "rust", "lua", "python" },
        }
    end,
}
