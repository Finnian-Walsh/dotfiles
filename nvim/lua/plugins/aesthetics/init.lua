local plugins = {}

vim.list_extend(plugins, require("plugins.aesthetics.alpha"))
vim.list_extend(plugins, require("plugins.aesthetics.bufferline"))
vim.list_extend(plugins, require("plugins.aesthetics.colorschemes"))
vim.list_extend(plugins, require("plugins.aesthetics.let-it-snow"))
vim.list_extend(plugins, require("plugins.aesthetics.lualine"))

return plugins
