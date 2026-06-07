require("vim._core.ui2").enable()

local local_site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
vim.opt.packpath:prepend(local_site)

require("core.options")
require("core.buffers")
require("core.tabs")
require("core.line_metadata")
require("core.keymap_inspector")

vim.pack.add(require("plugins"))
require("config.aesthetics")

require("core.colorschemes")

require("config.functionality")

require("custom.snake")
