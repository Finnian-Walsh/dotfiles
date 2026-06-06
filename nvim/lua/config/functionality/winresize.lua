local winresize, resize

require("core.lazy_keymaps")
    .new(function()
        winresize = require("winresize")
        resize = winresize.resize
    end)
    :add("n", "<C-left>", function()
        return function()
            resize(0, 5, "left")
        end
    end, { desc = "Size window left" })
    :add("n", "<C-down>", function()
        return function()
            resize(0, 5, "down")
        end
    end, { desc = "Size window down" })
    :add("n", "<C-up>", function()
        return function()
            resize(0, 5, "up")
        end
    end, { desc = "Size window up" })
    :add("n", "<C-right>", function()
        return function()
            resize(0, 5, "right")
        end
    end, { desc = "Size window right" })
    :add("n", "<C-S-left>", function()
        return function()
            resize(0, 1, "left")
        end
    end, { desc = "Size window left fine" })
    :add("n", "<C-S-down>", function()
        return function()
            resize(0, 1, "down")
        end
    end, { desc = "Size window down fine" })
    :add("n", "<C-S-up>", function()
        return function()
            resize(0, 1, "up")
        end
    end, { desc = "Size window up fine" })
    :add("n", "<C-S-right>", function()
        return function()
            resize(0, 1, "right")
        end
    end, { desc = "Size window right fine" })
