local safe_loader = require("plugins.safe_loader").new()

safe_loader:load("plugins.aesthetics.alpha")
safe_loader:load("plugins.aesthetics.bufferline")
safe_loader:load("plugins.aesthetics.colorschemes")
safe_loader:load("plugins.aesthetics.let-it-snow")
safe_loader:setup("lualine")
safe_loader:load("plugins.aesthetics.tohtml")

return safe_loader
