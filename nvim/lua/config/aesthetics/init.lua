local safe_loader = require("config.safe_loader").new()

safe_loader:load("config.aesthetics.alpha")
safe_loader:load("config.aesthetics.bufferline")
safe_loader:load("config.aesthetics.colorschemes")
safe_loader:load("config.aesthetics.let-it-snow")
safe_loader:setup("lualine")

return safe_loader
