require("vim._core.ui2").enable()

local local_site = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
vim.opt.packpath:prepend(local_site)

require("core.options")
require("core.buffers")
require("core.tabs")
require("core.line_metadata")
require("core.keymap_inspector")
require("core.mount_points")

vim.pack.add(require("plugins.spec"))

local aesthetics = require("plugins.aesthetics")

require("core.colorschemes")

local functionality = require("plugins.functionality")

require("custom.snake")

return {
    aesthetics = aesthetics,
    functionality = functionality,
}
