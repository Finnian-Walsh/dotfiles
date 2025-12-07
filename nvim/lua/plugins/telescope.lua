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
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep with telescope" })
        vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", { desc = "Find files with telescope"})
        vim.keymap.set("n", "<leader>R", builtin.resume, { desc = "Resume previous telescope action" })
        vim.keymap.set("n", "<leader>D", builtin.diagnostics, { desc = "View diagnostics" })
    end,
}
