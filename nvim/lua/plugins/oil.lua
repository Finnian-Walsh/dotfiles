return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup{
            keymaps = {
                ["<localleader>h"] = "actions.toggle_hidden",
                ["<C-l>"] = false,
                ["<localleader>r"] = "actions.refresh",
            },
            devicons = {
                icons = require("nvim-web-devicons").get_icons(),
            },
        }

        vim.keymap.set("n", "<leader>t", require("oil").open, { desc = "Open oil file tree" })
    end,
    lazy = false,
}
