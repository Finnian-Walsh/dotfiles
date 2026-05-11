require("vim._core.ui2").enable()

local local_site = vim.fn.stdpath("data") .. "/site"
vim.opt.packpath:prepend(local_site)

require("core.options")
require("core.buffers")
require("core.tabs")
require("core.line_metadata")
require("core.keymap_inspector")

vim.pack.add(require("plugins.aesthetics"))
require("config.aesthetics")

vim.pack.add(require("plugins.functionality"))
require("config.functionality")

require("custom.snake")
require("core.after")
