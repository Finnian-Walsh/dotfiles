local show_hidden_files = false
local previous_window = 0

require("mini.files").setup {
    content = {
        filter = function(file)
            return show_hidden_files or not vim.startswith(file.name, ".")
        end,
    },
}

vim.keymap.set("n", "<leader>t", function()
    previous_window = vim.api.nvim_get_current_win()
    MiniFiles.open()
end, { desc = "Mini files" })

local mini_actions = {
    new_left = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd.vsplit(path)
    end,

    new_below = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd.split()
        vim.cmd.wincmd("j")
        vim.cmd.edit(path)
    end,

    new_above = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd.split(path)
    end,

    new_right = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd.vsplit()
        vim.cmd.wincmd("l")
        vim.cmd.edit(path)
    end,
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "minifiles",
    callback = function(event)
        local buf = event.buf
        vim.b[buf].completion = false

        vim.keymap.set("n", "<leader>.", function()
            show_hidden_files = not show_hidden_files
            MiniFiles.close()
            MiniFiles.open()
        end, { desc = "Toggle hidden files", buffer = buf })

        vim.keymap.set("n", "<leader>r", function()
            MiniFiles.close()
            MiniFiles.open()
        end, { desc = "Refresh mini.files", buffer = buf })

        vim.keymap.set("n", "<C-h>", mini_actions.new_left, { desc = "Open in a new window left", buffer = buf })
        vim.keymap.set("n", "<C-j>", mini_actions.new_below, { desc = "Open in a new window below", buffer = buf })
        vim.keymap.set("n", "<C-k>", mini_actions.new_above, { desc = "Open in a new window above", buffer = buf })
        vim.keymap.set("n", "<C-l>", mini_actions.new_right, { desc = "Open in a new window right", buffer = buf })
    end,
})

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
