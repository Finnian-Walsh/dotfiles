require("toggleterm").setup {}

vim.keymap.set("n", "<leader><CR>", vim.cmd.ToggleTerm, { desc = "Toggle terminal" })
