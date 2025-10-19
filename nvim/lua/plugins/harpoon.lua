return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        "<leader>a",
        "<leader>h",
        "<leader>1",
        "<leader>2",
        "<leader>3",
        "<leader>4",
        "<leader>5",
        "<leader>6",
        "<leader>7",
        "<leader>8",
        "<leader>9",
        "<leader>0",
        "<leader>-",
        "<leader>=",
        "<leader><BS>",
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup{
            settings = {
                save_on_toggle = true,
                save_on_change = true,
                sync_on_ui_close = true,
            }
        }

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
        vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)
        vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end)
        vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end)
        vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end)
        vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end)

        vim.keymap.set("n", "<leader>-", function() harpoon:list():select(11) end)
        vim.keymap.set("n", "<leader>=", function() harpoon:list():select(12) end)
        vim.keymap.set("n", "<leader><BS>", function() harpoon:list():select(13) end)
    end,
    lazy = true,
}
