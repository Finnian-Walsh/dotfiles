local oil

local keymaps = require("core.lazy_keymaps").new(function()
    oil = require("oil")
    oil.setup {
        keymaps = {
            ["<leader>."] = "actions.toggle_hidden",
            ["<C-l>"] = false,
            ["<leader>r"] = "actions.refresh",
            ["<C-h>"] = false,
        },
        devicons = {
            icons = require("nvim-web-devicons").get_icons(),
        },
    }
end)

keymaps:cmd("Oil")

keymaps
    :add("n", "<leader>e", function()
        return oil.open
    end, { desc = "Open file tree" })
    :add("n", "<leader>ne", function()
        return function()
            vim.cmd("vs | wincmd l")
            oil.open()
        end
    end, { desc = "Open oil file tree in new vertical split" })
    :add("n", "<leader>Ne", function()
        return function()
            vim.cmd("sp | wincmd j")
            oil.open()
        end
    end, { desc = "Open oil file tree in new horizontal split" })

keymaps
    :add("n", "<leader>E", function()
        return function()
            oil.open(vim.uv.cwd())
        end
    end, { desc = "Open oil file tree at cwd" })
    :add("n", "<leader>nE", function()
        return function()
            vim.cmd("vs | wincmd l")
            oil.open(vim.uv.cwd())
        end
    end, { desc = "Open oil file tree at cwd in new vertical split" })
    :add("n", "<leader>NE", function()
        return function()
            vim.cmd("sp | wincmd j")
            oil.open(vim.uv.cwd())
        end
    end, { desc = "Open oil file tree at cwd in new horizontal split" })
