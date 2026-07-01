require("vim._core.ui2").enable()

local local_site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
vim.opt.packpath:prepend(local_site)

require("core.options")
require("core.buffers")
require("core.tabs")
require("core.line_metadata")
require("core.keymap_inspector")
require("core.mount_points")

local plugin_status = require("plugins")

require("core.colorschemes")
require("custom.snake")

return plugin_status
