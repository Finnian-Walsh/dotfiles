local oil = require("oil")

oil.setup {
    keymaps = {
        ["<leader>."] = "actions.toggle_hidden",
        ["<C-l>"] = false,
        ["<leader>r"] = "actions.refresh",
        ["<C-h>"] = false,
    },
    devicons = {
        icons = require("nvim-web-devicons").get_icons(),
    },
}

vim.keymap.set("n", "<leader>e", oil.open, { desc = "Open oil file tree" })

vim.keymap.set("n", "<leader>ne", function()
    vim.cmd("vs | wincmd l")
    oil.open()
end, { desc = "Open oil file tree in new vertical split" })

vim.keymap.set("n", "<leader>Ne", function()
    vim.cmd("sp | wincmd j")
    oil.open()
end, { desc = "Open oil file tree in new horizontal split" })

local function open_at_cwd()
    oil.open(vim.uv.cwd())
end
vim.keymap.set("n", "<leader>E", open_at_cwd, { desc = "Open oil file tree" })

vim.keymap.set("n", "<leader>nE", function()
    vim.cmd("sp | wincmd j")
    open_at_cwd()
end)

vim.keymap.set("n", "<leader>NE", function()
    vim.cmd("vs | wincmd l")
    open_at_cwd()
end)
