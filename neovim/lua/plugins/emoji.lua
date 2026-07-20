return {
    plugins = {
        "https://github.com/allaman/emoji.nvim",
    },

    opts = {
        emoji = {
            -- default is false, also needed for blink.cmp integration!
            enable_cmp_integration = true,
            -- optional if your plugin installation directory
            -- is not vim.fn.stdpath("data") .. "/lazy/
            plugin_path = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt"),
        },
    },

    config = function()
        -- require("emoji")
    end,
}
