local plugin_view

return {
    plugins = {
        { src = "https://github.com/Finnian-Walsh/plugin-view.nvim", version = "feat/buffer-updation" },
        -- { src = "https://github.com/Finnian-Walsh/plugin-testing.nvim", version = "✨" },
    },

    lazy = true,

    opts = { plugin_view = {} },

    keys = {
        {
            "n",
            "<leader>p",
            function()
                return plugin_view.open
            end,
            { desc = "View and manage plugins" },
        },
    },
}
