require("telescope").setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
}

if vim.fn.executable("rg") == 0 then
    vim.schedule(function()
        vim.notify("Warning: ripgrep is not available, so live grep will not work", vim.log.levels.WARN)
    end)
end

local builtin = require("telescope.builtin")

local initial_mode_normal = { initial_mode = "normal" }

vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep with telescope" })

vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files with telescope" })
vim.keymap.set("n", "<leader>F", function()
    builtin.find_files(initial_mode_normal)
end, { desc = "Find files with telescope" })

vim.keymap.set("n", "<leader>R", function()
    builtin.resume(initial_mode_normal)
end, { desc = "Resume previous telescope action" })
vim.keymap.set("n", "<leader>D", function()
    builtin.diagnostics(initial_mode_normal)
end, { desc = "View diagnostics" })

vim.keymap.set("n", "<leader>C", function()
    builtin.colorscheme(initial_mode_normal)
end, { desc = "View colorschemes" })

vim.keymap.set("n", "<leader>b/", builtin.buffers, { desc = "Search for buffer with telescope" })
vim.keymap.set("n", "<leader>b?", function()
    builtin.buffers(initial_mode_normal)
end, { desc = "View buffers with telescope" })

vim.keymap.set("n", "<leader>k/", builtin.keymaps, { desc = "Search for keymaps with telescope" })
vim.keymap.set("n", "<leader>k?", function()
    builtin.keymaps(initial_mode_normal)
end, { desc = "Search for keymaps with telescope" })

vim.keymap.set("n", "<leader>u", "<cmd>TodoTelescope<CR>", { desc = "Search for todo comments" })
vim.keymap.set("n", "<leader>U", "<cmd>TodoTelescope initial_mode=normal<CR>", { desc = "View todo comments" })
