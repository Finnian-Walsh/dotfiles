return {
    "pogyomo/winresize.nvim",
    event = "VeryLazy",
    config = function()
        local winresize = require("winresize")
        local resize = winresize.resize
        vim.keymap.set("n", "<C-left>", function() resize(0, 5, "left") end, { desc = "Size window left" })
        vim.keymap.set("n", "<C-down>", function() resize(0, 5, "down") end, { desc = "Size window down" })
        vim.keymap.set("n", "<C-up>", function() resize(0, 5, "up") end, { desc = "Size window up" })
        vim.keymap.set("n", "<C-right>", function() resize(0, 5, "right") end, { desc = "Size window right" })

        vim.keymap.set("n", "<C-S-left>", function() resize(0, 1, "left") end, { desc = "Size window left fine" })
        vim.keymap.set("n", "<C-S-down>", function() resize(0, 1, "down") end, { desc = "Size window down fine" })
        vim.keymap.set("n", "<C-S-up>", function() resize(0, 1, "up") end, { desc = "Size window up fine" })
        vim.keymap.set("n", "<C-S-right>", function() resize(0, 1, "right") end, { desc = "Size window right fine" })
    end,
}
