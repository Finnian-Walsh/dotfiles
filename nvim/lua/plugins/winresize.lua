return {
    "pogyomo/winresize.nvim",
    config = function()
        local winresize = require("winresize")
        local resize = winresize.resize
        vim.keymap.set("n", "<C-left>", function() resize(0, 5, "left") end)
        vim.keymap.set("n", "<C-down>", function() resize(0, 5, "down") end)
        vim.keymap.set("n", "<C-up>", function() resize(0, 5, "up") end)
        vim.keymap.set("n", "<C-right>", function() resize(0, 5, "right") end)

        vim.keymap.set("n", "<C-S-left>", function() resize(0, 1, "left") end)
        vim.keymap.set("n", "<C-S-down>", function() resize(0, 1, "down") end)
        vim.keymap.set("n", "<C-S-up>", function() resize(0, 1, "up") end)
        vim.keymap.set("n", "<C-S-right>", function() resize(0, 1, "right") end)
    end,
}
