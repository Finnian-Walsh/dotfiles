local plugin_view

require("lazy_loader").new {
    callback = function()
        plugin_view = require("plugin-view")
        plugin_view.setup {}
    end,
    keymaps = {
        {
            "n",
            "<leader>P",
            function()
                return plugin_view.open
            end,
            { desc = "View and manage plugins" },
        },
    },
}
