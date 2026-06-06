local plugin_view

require("core.lazy_keymaps")
    .new(function()
        plugin_view = require("plugin-view")
        plugin_view.setup {}
    end)
    :add("n", "<leader>p", function()
        return plugin_view.open
    end, { desc = "View and manage plugins" })
