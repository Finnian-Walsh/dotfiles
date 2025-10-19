return {
    "nvim-telescope/telescope.nvim", tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>/" },
    config = function()
        require("telescope").setup{
            defaults = {

            }
        }

        if vim.fn.executable("rg") == 0 then
            print("Warning: ripgrep is not available, so live grep will not work")
        end

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep with telescope" })
    end,
    lazy = true,
}
