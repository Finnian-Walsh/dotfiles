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
            local cwd = vim.loop.cwd()

            if file:sub(1, #cwd) == cwd then
                file = file:sub(#cwd + 2)
            end

            vim.fn.setreg('"', file)
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)
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

        vim.keymap.set("n", "<leader>!", function() harpoon:list():select(14) end)
        vim.keymap.set("n", "<leader>\"", function() harpoon:list():select(15) end)
        vim.keymap.set("n", "<leader>£", function() harpoon:list():select(16) end)
        vim.keymap.set("n", "<leader>$", function() harpoon:list():select(17) end)
        vim.keymap.set("n", "<leader>%", function() harpoon:list():select(18) end)
        vim.keymap.set("n", "<leader>^", function() harpoon:list():select(19) end)
        vim.keymap.set("n", "<leader>&", function() harpoon:list():select(20) end)
        vim.keymap.set("n", "<leader>*", function() harpoon:list():select(21) end)
        vim.keymap.set("n", "<leader>(", function() harpoon:list():select(22) end)
        vim.keymap.set("n", "<leader>)", function() harpoon:list():select(23) end)
        vim.keymap.set("n", "<leader>_", function() harpoon:list():select(24) end)
        vim.keymap.set("n", "<leader>+", function() harpoon:list():select(25) end)
        vim.keymap.set("n", "<leader><S-BS>", function() harpoon:list():select(26) end)
    end,
}
