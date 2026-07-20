return {
    plugins = {
        "https://github.com/marcussimonsen/let-it-snow.nvim",
    },

    lazy = true,

    opts = {
        ["let-it-snow"] = { delay = 150 },
    },

    config = function()
        if current_month ~= 12 then -- automatic functionality only considered necessary during December
            return
        end

        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function(_)
                vim.cmd.LetItSnow()
            end,
        })
    end,

    keymaps = {
        {
            "n",
            "<leader>S",
            function()
                return vim.cmd.LetItSnow
            end,
            { desc = "Let it snow!" },
        },
    },

    cmds = { "LetItSnow" },
}
