local oil = require("oil")

oil.setup {
    keymaps = {
        ["<localleader>h"] = "actions.toggle_hidden",
        ["<C-l>"] = false,
        ["<localleader>r"] = "actions.refresh",
        ["<C-h>"] = false,
    },
    devicons = {
        icons = require("nvim-web-devicons").get_icons(),
    },
}

vim.keymap.set("n", "<leader>t", oil.open, { desc = "Open oil file tree" })

vim.keymap.set("n", "<leader>nt", function()
    vim.cmd("vs | wincmd l")
    oil.open()
end, { desc = "Open oil file tree in new vertical split" })

vim.keymap.set("n", "<leader>Nt", function()
    vim.cmd("sp | wincmd j")
    oil.open()
end, { desc = "Open oil file tree in new horizontal split" })
