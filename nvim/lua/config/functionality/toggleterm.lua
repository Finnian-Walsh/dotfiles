local toggleterm_keymap = "<leader><CR>"
local toggleterm_opts = { desc = "Toggle terminal" }

vim.keymap.set("n", toggleterm_keymap, function()
    require("toggleterm").setup {}
    vim.keymap.set("n", toggleterm_keymap, vim.cmd.ToggleTerm, toggleterm_opts)
    vim.cmd.ToggleTerm()
end, toggleterm_opts)
