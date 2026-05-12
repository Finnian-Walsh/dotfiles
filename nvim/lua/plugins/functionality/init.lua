local plugins = {}

vim.list_extend(plugins, require("plugins.functionality.blink"))
vim.list_extend(plugins, require("plugins.functionality.editor"))
vim.list_extend(plugins, require("plugins.functionality.gitsigns"))
vim.list_extend(plugins, require("plugins.functionality.hooker"))
vim.list_extend(plugins, require("plugins.functionality.lspconfig"))
vim.list_extend(plugins, require("plugins.functionality.neo-tree"))
vim.list_extend(plugins, require("plugins.functionality.neorg"))
vim.list_extend(plugins, require("plugins.functionality.nvim-dap"))
vim.list_extend(plugins, require("plugins.functionality.oil"))
vim.list_extend(plugins, require("plugins.functionality.telescope"))
vim.list_extend(plugins, require("plugins.functionality.which-key"))
vim.list_extend(plugins, require("plugins.functionality.winresize"))
vim.list_extend(plugins, require("plugins.functionality.undotree"))

return plugins
