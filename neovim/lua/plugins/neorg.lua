if vim.env.NEORG ~= "1" then
    return false
end

return {
    plugins = { "https://github.com/nvim-neorg/neorg" },

    opts = {
        neorg = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            school = "~/Documents/notes/school",
                            literature = "~/Documents/notes/school/literature/",
                            bookwork = "~/Documents/notes/school/bookwork/",
                        },
                    },
                },
                ["core.completion"] = {
                    config = {
                        engine = "nvim-cmp",
                    },
                },
                ["core.integrations.nvim-cmp"] = {},
                ["core.integrations.treesitter"] = {
                    config = {
                        configure_parsers = true,
                        install_parsers = true,
                    },
                },
            },
        },
    },

    config = function()
        vim.keymap.set("n", "<localleader>nw", ":Neorg workspace ", { desc = "[neorg] Enter workspace" })
        vim.keymap.set("n", "<localleader>nr", "<cmd>Neorg return<CR>", { desc = "[neorg] Return" })
    end,
}
