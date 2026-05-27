require("toggleterm").setup {}

vim.keymap.set("n", "<leader>j", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
