return {
    plugins = {
        "allaman/emoji.nvim",
    },

    opts = {
        emoji = {
            -- default is false, also needed for blink.cmp integration!
            enable_cmp_integration = true,
            -- optional if your plugin installation directory
            -- is not vim.fn.stdpath("data") .. "/lazy/
            plugin_path = vim.fn.expand("$HOME/plugins/"),
        },
    },

    config = function()
        -- require("emoji")
    end,
}
