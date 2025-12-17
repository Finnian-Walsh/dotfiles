return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        require("telescope").setup{ defaults = { } }

        if vim.fn.executable("rg") == 0 then
            vim.schedule(function()
                vim.api.nvim_echo({{"Warning: ripgrep is not available, so live grep will not work", "WarningMsg"}}, true, {})
            end)
        end

        local builtin = require("telescope.builtin")

        local initial_mode_normal = { initial_mode = "normal" }
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep with telescope" })

        vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files with telescope"})
        vim.keymap.set("n", "<leader>F", function() builtin.find_files(initial_mode_normal) end, { desc = "Find files with telescope"})

        vim.keymap.set("n", "<leader>R", builtin.resume, { desc = "Resume previous telescope action" })
        vim.keymap.set("n", "<leader>D", builtin.diagnostics, { desc = "View diagnostics" })

        vim.keymap.set("n", "<leader>C/", builtin.colorscheme, { desc = "Search for colorschemes" })
        vim.keymap.set("n", "<leader>C?", function() builtin.colorscheme(initial_mode_normal) end, { desc = "View colorschemes" })

        vim.keymap.set("n", "<leader>b/", builtin.buffers, { desc = "Search for buffer with telescope" })
        vim.keymap.set("n", "<leader>b?", function() builtin.buffers(initial_mode_normal) end, { desc = "View buffers with telescope" })
    end,
}
