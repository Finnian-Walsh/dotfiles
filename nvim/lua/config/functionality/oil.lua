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
