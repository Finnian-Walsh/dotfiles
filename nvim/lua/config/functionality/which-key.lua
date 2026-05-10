vim.keymap.set("n", "<leader>?", function()
    require("which-key").show()
end, { desc = "Buffer Local Keymaps (which-key)" })

require("which-key").setup {
    preset = "helix",
}
