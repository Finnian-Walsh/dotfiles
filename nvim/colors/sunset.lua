vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "sunset"

local hl = vim.api.nvim_set_hl

hl(0, "Normal", { fg = "#ffd0df", bg = "#310b38" })
hl(0, "Comment", { fg = "#ff6f00" })
hl(0, "Keyword", { fg = "#c800ff" })

hl(0, "@comment", { link = "Comment" })
hl(0, "@string", { fg = "#aaff00" })
hl(0, "@variable", { fg = "#ffb0bf" })
hl(0, "@variable.parameter", { link = "@variable" })

hl(0, "@function", { fg = "#fca800" })
hl(0, "@function", { fg = "#fca800" })
hl(0, "Identifier", { fg = "#fca800" })
hl(0, "Function", { fg = "#fca800" })

hl(0, "@property", { fg = "#e69d00" })
hl(0, "@field", { fg = "#e69d00" })
