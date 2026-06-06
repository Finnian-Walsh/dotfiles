local which_key = require("which-key")

which_key.setup {
    preset = "helix",
}

vim.keymap.set("n", "<leader>?", which_key.show, { desc = "Buffer Local Keymaps (which-key)" })
