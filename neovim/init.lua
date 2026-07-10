print("RUnning init")

local local_site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
vim.opt.packpath:prepend(local_site)

require("core")

local plugin_load_start = vim.uv.hrtime()

vim.pack.add(require("plugins.spec"))

local plugin_status = require("plugins")

_G.PluginLoadTime = (vim.uv.hrtime() - plugin_load_start) / 1e6

require("after")
require("custom")

return plugin_status
