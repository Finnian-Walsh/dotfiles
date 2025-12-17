return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local oil = require("oil")
        oil.setup{
            keymaps = {
                ["<localleader>h"] = "actions.toggle_hidden",
                ["<C-l>"] = false,
                ["<localleader>r"] = "actions.refresh",
                ["<C-h>"] = false,
            },
            devicons = {
                icons = require("nvim-web-devicons").get_icons(),
            },
        }

        local function open_at_cwd()
            oil.open(vim.uv.cwd())
        end

        vim.keymap.set("n", "<leader>t", oil.open, { desc = "Open oil file tree" })
        vim.keymap.set("n", "<leader>T", open_at_cwd, { desc = "Open oil file tree at cwd" })

        vim.keymap.set("n", "<leader>nt", function()
            vim.cmd("vs | wincmd l")
            oil.open()
        end, { desc = "Open oil file tree in new vertical split" })

        vim.keymap.set("n", "<leader>Nt", function()
            vim.cmd("sp | wincmd j")
            oil.open()
        end, { desc = "Open oil file tree in new horizontal split" })

        vim.keymap.set("n", "<leader>nT", function()
            vim.cmd("vs | wincmd l")
            open_at_cwd()
        end, { desc = "Open oil file tree at cwd in new vertical split" })

        vim.keymap.set("n", "<leader>NT", function()
            vim.cmd("sp | wincmd j")
            open_at_cwd()
        end, { desc = "Open oil file tree at cwd in new horizontal split" })
    end,
    lazy = false,
}
