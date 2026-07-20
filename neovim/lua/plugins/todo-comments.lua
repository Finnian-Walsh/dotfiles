-- TODO: add the next thing to the neovim config
-- FIX: critical bug!
-- PERF: yes yes yes yes we have the best performance ever
-- WARNING: something very bad
-- NOTE: Neovim btw

return {
    plugins = {
        "https://github.com/folke/todo-comments.nvim",
        "https://github.com/nvim-lua/plenary.nvim",
    },

    opts = { ["todo-comments"] = {} },

    config = function()
        local todo_comments = require("todo-comments")
        vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Jump to the previous todo comment" })
        vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Jump to the next todo comment" })

        _G.reset_todo_signs = todo_comments.reset

        _G.disable_todo_signs = todo_comments.disable
    end,
}
