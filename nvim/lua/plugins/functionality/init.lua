local plugins = {}

vim.list_extend(plugins, require("plugins.functionality.blink"))
vim.list_extend(plugins, require("plugins.functionality.editor"))
vim.list_extend(plugins, require("plugins.functionality.gitsigns"))
vim.list_extend(plugins, require("plugins.functionality.hooker"))
vim.list_extend(plugins, require("plugins.functionality.lspconfig"))
vim.list_extend(plugins, require("plugins.functionality.neorg"))
vim.list_extend(plugins, require("plugins.functionality.nvim-dap"))
vim.list_extend(plugins, require("plugins.functionality.oil"))
vim.list_extend(plugins, require("plugins.functionality.plugin-view"))
vim.list_extend(plugins, require("plugins.functionality.telescope"))
vim.list_extend(plugins, require("plugins.functionality.which-key"))
vim.list_extend(plugins, require("plugins.functionality.winresize"))
vim.list_extend(plugins, require("plugins.functionality.undotree"))

table.insert(plugins, {
    src = "https://github.com/Finnian-Walsh/plugin-testing.nvim",
    version = "main",
})

return plugins
