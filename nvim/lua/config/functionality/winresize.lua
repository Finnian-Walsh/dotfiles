local winresize, resize

require("lazy_loader")
    .new(function()
        winresize = require("winresize")
        resize = winresize.resize
    end)
    :map("n", "<C-left>", function()
        return function()
            resize(0, 5, "left")
        end
    end, { desc = "Size window left" })
    :map("n", "<C-down>", function()
        return function()
            resize(0, 5, "down")
        end
    end, { desc = "Size window down" })
    :map("n", "<C-up>", function()
        return function()
            resize(0, 5, "up")
        end
    end, { desc = "Size window up" })
    :map("n", "<C-right>", function()
        return function()
            resize(0, 5, "right")
        end
    end, { desc = "Size window right" })
    :map("n", "<C-S-left>", function()
        return function()
            resize(0, 1, "left")
        end
    end, { desc = "Size window left fine" })
    :map("n", "<C-S-down>", function()
        return function()
            resize(0, 1, "down")
        end
    end, { desc = "Size window down fine" })
    :map("n", "<C-S-up>", function()
        return function()
            resize(0, 1, "up")
        end
    end, { desc = "Size window up fine" })
    :map("n", "<C-S-right>", function()
        return function()
            resize(0, 1, "right")
        end
    end, { desc = "Size window right fine" })
