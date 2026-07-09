-- TODO: add the next thing to the neovim config
-- FIX: critical bug!
-- PERF: yes yes yes yes we have the best performance ever
-- WARNING: something very bad
-- NOTE: Neovim btw

local todo_comments = require("todo-comments")
todo_comments.setup {}

vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Jump to the previous todo comment" })
vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Jump to the next todo comment" })

_G.reset_todo_signs = todo_comments.reset

_G.disable_todo_signs = todo_comments.disable
