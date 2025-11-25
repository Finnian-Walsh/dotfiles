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

        -- characters

        vim.keymap.set("n", "<leader><leader>q", function() harpoon:list():select(31) end, { desc = "Harpoon 31" })
        vim.keymap.set("n", "<leader><leader>w", function() harpoon:list():select(32) end, { desc = "Harpoon 32" })
        vim.keymap.set("n", "<leader><leader>e", function() harpoon:list():select(33) end, { desc = "Harpoon 33" })
        vim.keymap.set("n", "<leader><leader>r", function() harpoon:list():select(34) end, { desc = "Harpoon 34" })
        vim.keymap.set("n", "<leader><leader>t", function() harpoon:list():select(35) end, { desc = "Harpoon 35" })
        vim.keymap.set("n", "<leader><leader>y", function() harpoon:list():select(36) end, { desc = "Harpoon 36" })
        vim.keymap.set("n", "<leader><leader>u", function() harpoon:list():select(37) end, { desc = "Harpoon 37" })
        vim.keymap.set("n", "<leader><leader>i", function() harpoon:list():select(38) end, { desc = "Harpoon 38" })
        vim.keymap.set("n", "<leader><leader>o", function() harpoon:list():select(39) end, { desc = "Harpoon 39" })
        vim.keymap.set("n", "<leader><leader>p", function() harpoon:list():select(40) end, { desc = "Harpoon 40" })

        vim.keymap.set("n", "<leader><leader>a", function() harpoon:list():select(41) end, { desc = "Harpoon 41" })
        vim.keymap.set("n", "<leader><leader>s", function() harpoon:list():select(42) end, { desc = "Harpoon 42" })
        vim.keymap.set("n", "<leader><leader>d", function() harpoon:list():select(43) end, { desc = "Harpoon 43" })
        vim.keymap.set("n", "<leader><leader>f", function() harpoon:list():select(44) end, { desc = "Harpoon 44" })
        vim.keymap.set("n", "<leader><leader>g", function() harpoon:list():select(45) end, { desc = "Harpoon 45" })
        vim.keymap.set("n", "<leader><leader>h", function() harpoon:list():select(46) end, { desc = "Harpoon 46" })
        vim.keymap.set("n", "<leader><leader>j", function() harpoon:list():select(47) end, { desc = "Harpoon 47" })
        vim.keymap.set("n", "<leader><leader>k", function() harpoon:list():select(48) end, { desc = "Harpoon 48" })
        vim.keymap.set("n", "<leader><leader>l", function() harpoon:list():select(49) end, { desc = "Harpoon 49" })

        vim.keymap.set("n", "<leader><leader>z", function() harpoon:list():select(50) end, { desc = "Harpoon 50" })
        vim.keymap.set("n", "<leader><leader>x", function() harpoon:list():select(51) end, { desc = "Harpoon 41" })
        vim.keymap.set("n", "<leader><leader>c", function() harpoon:list():select(52) end, { desc = "Harpoon 42" })
        vim.keymap.set("n", "<leader><leader>v", function() harpoon:list():select(53) end, { desc = "Harpoon 43" })
        vim.keymap.set("n", "<leader><leader>b", function() harpoon:list():select(54) end, { desc = "Harpoon 44" })
        vim.keymap.set("n", "<leader><leader>n", function() harpoon:list():select(55) end, { desc = "Harpoon 45" })
        vim.keymap.set("n", "<leader><leader>m", function() harpoon:list():select(56) end, { desc = "Harpoon 46" })

        -- shifted

        vim.keymap.set("n", "<leader><leader>Q", function() harpoon:list():select(67) end, { desc = "Harpoon 67" })
        vim.keymap.set("n", "<leader><leader>W", function() harpoon:list():select(68) end, { desc = "Harpoon 68" })
        vim.keymap.set("n", "<leader><leader>E", function() harpoon:list():select(69) end, { desc = "Harpoon 69" })
        vim.keymap.set("n", "<leader><leader>R", function() harpoon:list():select(70) end, { desc = "Harpoon 70" })
        vim.keymap.set("n", "<leader><leader>T", function() harpoon:list():select(71) end, { desc = "Harpoon 71" })
        vim.keymap.set("n", "<leader><leader>Y", function() harpoon:list():select(72) end, { desc = "Harpoon 72" })
        vim.keymap.set("n", "<leader><leader>U", function() harpoon:list():select(73) end, { desc = "Harpoon 73" })
        vim.keymap.set("n", "<leader><leader>I", function() harpoon:list():select(74) end, { desc = "Harpoon 74" })
        vim.keymap.set("n", "<leader><leader>O", function() harpoon:list():select(75) end, { desc = "Harpoon 75" })
        vim.keymap.set("n", "<leader><leader>P", function() harpoon:list():select(76) end, { desc = "Harpoon 76" })

        vim.keymap.set("n", "<leader><leader>A", function() harpoon:list():select(77) end, { desc = "Harpoon 77" })
        vim.keymap.set("n", "<leader><leader>S", function() harpoon:list():select(78) end, { desc = "Harpoon 78" })
        vim.keymap.set("n", "<leader><leader>D", function() harpoon:list():select(79) end, { desc = "Harpoon 79" })
        vim.keymap.set("n", "<leader><leader>F", function() harpoon:list():select(80) end, { desc = "Harpoon 80" })
        vim.keymap.set("n", "<leader><leader>G", function() harpoon:list():select(81) end, { desc = "Harpoon 81" })
        vim.keymap.set("n", "<leader><leader>H", function() harpoon:list():select(82) end, { desc = "Harpoon 82" })
        vim.keymap.set("n", "<leader><leader>J", function() harpoon:list():select(83) end, { desc = "Harpoon 83" })
        vim.keymap.set("n", "<leader><leader>K", function() harpoon:list():select(84) end, { desc = "Harpoon 84" })
        vim.keymap.set("n", "<leader><leader>L", function() harpoon:list():select(85) end, { desc = "Harpoon 85" })

        vim.keymap.set("n", "<leader><leader>Z", function() harpoon:list():select(86) end, { desc = "Harpoon 86" })
        vim.keymap.set("n", "<leader><leader>X", function() harpoon:list():select(87) end, { desc = "Harpoon 77" })
        vim.keymap.set("n", "<leader><leader>C", function() harpoon:list():select(88) end, { desc = "Harpoon 78" })
        vim.keymap.set("n", "<leader><leader>V", function() harpoon:list():select(89) end, { desc = "Harpoon 79" })
        vim.keymap.set("n", "<leader><leader>B", function() harpoon:list():select(90) end, { desc = "Harpoon 80" })
        vim.keymap.set("n", "<leader><leader>N", function() harpoon:list():select(91) end, { desc = "Harpoon 81" })
        vim.keymap.set("n", "<leader><leader>M", function() harpoon:list():select(92) end, { desc = "Harpoon 82" })
    end,
}
