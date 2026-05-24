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

require("mini.files").setup {}

vim.keymap.set("n", "<leader>t", MiniFiles.open, { desc = "Mini files" })

require("mini.surround").setup {
    -- Add custom surroundings to be used on top of builtin ones. For more
    -- information with examples, see `:h MiniSurround.config`.
    custom_surroundings = nil,

    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
    highlight_duration = 500,

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
    },

    -- Number of lines within which surrounding is searched
    n_lines = 20,

    -- Whether to respect selection type:
    -- - Place surroundings on separate lines in linewise mode.
    -- - Place surroundings on each line in blockwise mode.
    respect_selection_type = false,

    -- How to search for surrounding (first inside current line, then inside
    -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
    -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
    -- see `:h MiniSurround.config`.
    search_method = "cover",

    -- Whether to disable showing non-error feedback
    -- This also affects (purely informational) helper messages shown after
    -- idle time if user input is required.
    silent = false,
}

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
