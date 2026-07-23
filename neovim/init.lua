require("core")

local plugin_load_start = vim.uv.hrtime()

local plugin_status = require("plugins")

_G.PluginLoadTime = (vim.uv.hrtime() - plugin_load_start) / 1e6

require("after")
require("custom")

return plugin_status
