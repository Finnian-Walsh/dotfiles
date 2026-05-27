if vim.env.NVIM_DEV == "1" then
    vim.opt.rtp:prepend("~/Dev/hooker.nvim/")
    vim.opt.rtp:prepend("~/Dev/plugin-view.nvim/")
end

require("config.functionality.blink")
require("config.functionality.editor")
require("config.functionality.gitsigns")
require("config.functionality.hooker")
require("config.functionality.lspconfig")
require("config.functionality.neorg")
require("config.functionality.nvim-dap")
require("config.functionality.oil")
require("config.functionality.plugin-view")
require("config.functionality.telescope")
require("config.functionality.toggleterm")
require("config.functionality.undotree")
require("config.functionality.which-key")
require("config.functionality.winresize")
