require("snacks").setup {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    picker = {
        enabled = true,
        win = {
            input = {
                keys = {
                    ["<C-x>"] = { "edit_split", mode = { "i", "n" } },
                    ["<C-s>"] = false,
                },
            },
        },
    },
    profiler = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    terminal = { enabled = true },
    words = { enabled = true },
}

------
------ Pickers
------

---- General picker

vim.keymap.set("n", "<leader>L", function()
    Snacks.picker { focus = "list" }
end, { desc = "Open Snacks picker" })

vim.keymap.set("n", "<leader>R", function()
    Snacks.picker.resume {}
end, { desc = "Resume snacks picker" })

---- File-related

vim.keymap.set("n", "<leader>e", Snacks.picker.explorer, { desc = "Open explorer" })

vim.keymap.set("n", "<leader>/", Snacks.picker.grep, { desc = "Open explorer" })

vim.keymap.set("n", "<leader>f", Snacks.picker.files, { desc = "Open explorer" })

vim.keymap.set("n", "<leader>F", function()
    Snacks.picker.files { focus = "list" }
end, { desc = "Open explorer" })

---- Colorschemes

vim.keymap.set("n", "<leader>C", function()
    Snacks.picker.colorschemes { focus = "list" }
end, { desc = "Open colorschemes picker" })

-- TODO: impl favorite colorschemes picker

---- Git

vim.keymap.set("n", "<leader>gs", function()
    Snacks.picker.git_status { focus = "list" }
end, { desc = "Open git status picker" })

vim.keymap.set("n", "<leader>gc", function()
    Snacks.picker.git_log { focus = "list" }
end, { desc = "Open git log picker" })

---- Buffers

vim.keymap.set("n", "<leader>b/", Snacks.picker.grep_buffers, { desc = "Grep buffers" })
vim.keymap.set("n", "<leader>b?", function()
    Snacks.picker.grep_buffers { focus = "list" }
end, { desc = "Grep buffers (in list)" })

---- Keymaps

vim.keymap.set("n", "<leader>k/", Snacks.picker.keymaps, { desc = "Search for keymaps with a Snacks picker" })
vim.keymap.set("n", "<leader>k?", Snacks.picker.keymaps, { desc = "View keymaps with a Snacks picker" })

---- Undo history

vim.keymap.set("n", "<leader>u", Snacks.picker.undo, { desc = "View undo history" })

---- Diagnostics

vim.keymap.set("n", "<leader>D", function()
    Snacks.picker.diagnostics { focus = "list" }
end, { desc = "View diagnostics" })

---- Notifications

vim.keymap.set("n", "<leader>`", function()
    Snacks.picker.notifications { focus = "list" }
end, { desc = "Open snacks notifications in list mode" })

---- Todo Comments

vim.keymap.set("n", "<leader>#", function()
    Snacks.picker.todo_comments { focus = "list" }
end, { desc = "View todo comments" })

---- Commands

vim.keymap.set("n", "<leader>:", function()
    Snacks.picker.commands { focus = "list" }
end, { desc = "View commands with a picker" })

---- Checks

if vim.fn.exepath("rg") == "" then
    Snacks.notify.warn("Warning: ripgrep is not available, so live grep will not work")
end

if vim.fn.exepath("fdfind") == "" and vim.fn.exepath("fd") == "" then
    Snacks.notify.warn("Warning: fdfind is not available, so file grep will be significantly slower")
end

------
------ Other snacks modules
------

vim.keymap.set("n", "<leader><CR>", function()
    Snacks.terminal()
end, { desc = "Toggle snacks terminal" })

vim.keymap.set("n", "<leader>G", function()
    Snacks.lazygit()
end, { desc = "Open Lazygit" })

vim.keymap.set("n", "<leader>gu", Snacks.gitbrowse.open, { desc = "Open the repository URL" })
