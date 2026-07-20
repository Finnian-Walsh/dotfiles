return {
    plugins = {
        "https://github.com/neovim/nvim-lspconfig",
        "https://github.com/mrcjkb/rustaceanvim",
    },

    modules = {
        "format",
        "mason",
    },

    config = function()
        require("plugins.lsp.language_servers")
        require("plugins.lsp.actions")
    end,
}
