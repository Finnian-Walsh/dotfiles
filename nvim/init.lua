require("vim._core.ui2").enable()

local local_site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
vim.opt.packpath:prepend(local_site)

require("core.options")
require("core.buffers")
require("core.tabs")
require("core.line_metadata")
require("core.keymap_inspector")
require("core.mount_points")

local plugin_load_start = vim.uv.hrtime()

local plugin_status = require("plugins")

_G.PluginLoadTime = (vim.uv.hrtime() - plugin_load_start) / 1e6

require("core.colorschemes")
require("custom.snake")

return plugin_status
