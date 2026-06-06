local plugin_view

require("lazy_loader")
    .new(function()
        plugin_view = require("plugin-view")
        plugin_view.setup {}
    end)
    :map("n", "<leader>p", function()
        return plugin_view.open
    end, { desc = "View and manage plugins" })
