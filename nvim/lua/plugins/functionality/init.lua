local safe_loader = require("plugins.safe_loader").new()

safe_loader:load("plugins.functionality.autopairs")
safe_loader:load("plugins.functionality.blink")
safe_loader:load("plugins.functionality.gitsigns")
safe_loader:load("plugins.functionality.hooker")
safe_loader:load("plugins.functionality.lspconfig")
safe_loader:load("plugins.functionality.mini")
safe_loader:load("plugins.functionality.neorg")
safe_loader:load("plugins.functionality.nvim-dap")
safe_loader:load("plugins.functionality.peek")
safe_loader:load("plugins.functionality.plugin-view")
safe_loader:load("plugins.functionality.snacks")
safe_loader:load("plugins.functionality.todo-comments")
safe_loader:load("plugins.functionality.which-key")
safe_loader:load("plugins.functionality.winresize")

return safe_loader
