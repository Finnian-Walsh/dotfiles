if vim.env.NVIM_DEV then
    vim.opt.rtp:prepend("~/Dev/hooker.nvim/")
end

require("config.functionality.blink")
require("config.functionality.editor")
require("config.functionality.gitsigns")
require("config.functionality.hooker")
require("config.functionality.lspconfig")
require("config.functionality.neo-tree")
require("config.functionality.neorg")
require("config.functionality.nvim-dap")
require("config.functionality.oil")
require("config.functionality.telescope")
require("config.functionality.undotree")
require("config.functionality.which-key")
require("config.functionality.winresize")
