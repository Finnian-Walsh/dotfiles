local safe_loader = require("config.safe_loader").new()

safe_loader:load("config.functionality.autopairs")
safe_loader:load("config.functionality.blink")
safe_loader:load("config.functionality.gitsigns")
safe_loader:load("config.functionality.hooker")
safe_loader:load("config.functionality.lspconfig")
safe_loader:load("config.functionality.mini")
safe_loader:load("config.functionality.neorg")
safe_loader:load("config.functionality.nvim-dap")
safe_loader:load("config.functionality.oil")
safe_loader:load("config.functionality.peek")
safe_loader:load("config.functionality.plugin-view")
safe_loader:load("config.functionality.snacks")
safe_loader:load("config.functionality.todo-comments")
safe_loader:load("config.functionality.which-key")
safe_loader:load("config.functionality.winresize")

return safe_loader
