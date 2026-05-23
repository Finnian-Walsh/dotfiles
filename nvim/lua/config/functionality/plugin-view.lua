local plugin_view = require("plugin-view")
plugin_view.setup {}
vim.keymap.set("n", "<leader>p", plugin_view.open, { desc = "View and manage plugins" })
