vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        require("nvim-autopairs").setup {
            check_ts = true,
            ts_config = {
                rust = { "string", "char" },
            },
        }
    end,
})

-- TODO: add the next thing to the neovim config
-- FIX: critical bug!
-- PERF: yes yes yes yes we have the best performance ever
-- WARNING: something very bad
-- NOTE: Neovim btw

local todo_comments = require("todo-comments")
todo_comments.setup {}

vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Jump to the previous todo comment" })
vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Jump to the next todo comment" })

function _G.reset_todo_signs()
    todo_comments.reset()
end

function _G.disable_todo_signs()
    todo_comments.disable()
end
