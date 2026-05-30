require("toggleterm").setup {}

vim.keymap.set("n", "<leader><CR>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
