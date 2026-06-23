local resize

require("lazy_loader")
    .new({
        callback = function()
            resize = require("winresize").resize
        end,
    })
    :map("n", "<C-left>", function()
        return function()
            resize(0, 5, "left")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window left" })
    :map("n", "<C-down>", function()
        return function()
            resize(0, 5, "down")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window down" })
    :map("n", "<C-up>", function()
        return function()
            resize(0, 5, "up")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window up" })
    :map("n", "<C-right>", function()
        return function()
            resize(0, 5, "right")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window right" })
    :map("n", "<C-S-left>", function()
        return function()
            resize(0, 1, "left")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window left fine" })
    :map("n", "<C-S-down>", function()
        return function()
            resize(0, 1, "down")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window down fine" })
    :map("n", "<C-S-up>", function()
        return function()
            resize(0, 1, "up")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window up fine" })
    :map("n", "<C-S-right>", function()
        return function()
            resize(0, 1, "right")
            vim.cmd.stopinsert()
        end
    end, { desc = "Size window right fine" })
