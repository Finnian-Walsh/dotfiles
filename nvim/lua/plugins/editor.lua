return {
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = {
                rust = { "string", "char" },
            },
        },
    },
    {
        "nvim-mini/mini.ai",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        -- TODO: add the next thing to the neovim config
        -- FIX: critical bug!
        -- PERF: yes yes yes yes we have the best performance ever
        -- WARNING: something very bad
        -- NOTE: Neovim btw
        config = function(_, opts)
            local todo_comments = require("todo-comments")
            todo_comments.setup(opts)

            vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Jump to the previous todo comment" })
            vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Jump to the next todo comment" })

            function _G.reset_todo_signs()
                todo_comments.reset()
            end

            function _G.disable_todo_signs()
                todo_comments.disable()
            end
        end,
    },
}
