return {
    plugins = {
        "https://github.com/folke/which-key.nvim",
    },

    opts = { ["which-key"] = { preset = "helix" } },

    config = function()
        vim.keymap.set("n", "<leader>?", require("which-key").show, { desc = "Buffer Local Keymaps (which-key)" })
    end,
}
