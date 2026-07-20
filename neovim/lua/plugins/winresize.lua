local resize

return {
    plugins = {
        "https://github.com/pogyomo/winresize.nvim",
    },

    lazy = true,

    config = function()
        resize = require("winresize").resize
    end,

    keys = {
        {
            { "n", "t" },
            "<C-left>",
            function()
                return function()
                    resize(0, 5, "left")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window left" },
        },

        {
            { "n", "t" },
            "<C-down>",
            function()
                return function()
                    resize(0, 5, "down")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window down" },
        },

        {
            { "n", "t" },
            "<C-up>",
            function()
                return function()
                    resize(0, 5, "up")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window up" },
        },

        {
            { "n", "t" },
            "<C-right>",
            function()
                return function()
                    resize(0, 5, "right")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window right" },
        },

        {
            { "n", "t" },
            "<C-S-left>",
            function()
                return function()
                    resize(0, 1, "left")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window left fine" },
        },

        {
            { "n", "t" },
            "<C-S-down>",
            function()
                return function()
                    resize(0, 1, "down")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window down fine" },
        },

        {
            { "n", "t" },
            "<C-S-up>",
            function()
                return function()
                    resize(0, 1, "up")
                    vim.cmd.stopinsert()
                end
            end,
            { desc = "Size window up fine" },

            {
                { "n", "t" },
                "<C-S-right>",
                function()
                    return function()
                        resize(0, 1, "right")
                        vim.cmd.stopinsert()
                    end
                end,
                { desc = "Size window right fine" },
            },
        },
    },
}
