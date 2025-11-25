return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    event = "VeryLazy",

    config = function()
        local harpoon = require("harpoon")
        harpoon:setup{
            settings = {
                save_on_toggle = true,
                save_on_change = true,
                sync_on_ui_close = true,
            }
        }

        vim.keymap.set("n", "<leader>a", function()
            local file = vim.fn.expand("%")
            local cwd = vim.uv.cwd()

            if file:sub(1, #cwd) == cwd then
                file = file:sub(#cwd + 2)
            end

            vim.fn.setreg('"', file)
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open Harpoon" })

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
        vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon 5" })
        vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "Harpoon 6" })
        vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { desc = "Harpoon 7" })
        vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { desc = "Harpoon 8" })
        vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { desc = "Harpoon 9" })
        vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end, { desc = "Harpoon 10" })

        vim.keymap.set("n", "<leader>!", function() harpoon:list():select(11) end, { desc = "Harpoon 11" })
        vim.keymap.set("n", "<leader>\"", function() harpoon:list():select(12) end, { desc = "Harpoon 12" })
        vim.keymap.set("n", "<leader>£", function() harpoon:list():select(13) end, { desc = "Harpoon 13" })
        vim.keymap.set("n", "<leader>$", function() harpoon:list():select(14) end, { desc = "Harpoon 14" })
        vim.keymap.set("n", "<leader>%", function() harpoon:list():select(15) end, { desc = "Harpoon 15" })
        vim.keymap.set("n", "<leader>^", function() harpoon:list():select(16) end, { desc = "Harpoon 16" })
        vim.keymap.set("n", "<leader>&", function() harpoon:list():select(17) end, { desc = "Harpoon 17" })
        vim.keymap.set("n", "<leader>*", function() harpoon:list():select(18) end, { desc = "Harpoon 18" })
        vim.keymap.set("n", "<leader>(", function() harpoon:list():select(19) end, { desc = "Harpoon 19" })
        vim.keymap.set("n", "<leader>)", function() harpoon:list():select(20) end, { desc = "Harpoon 20" })
    end,
}
