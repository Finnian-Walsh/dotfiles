require("toggleterm").setup {}

vim.keymap.set("n", "<leader><leader>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
