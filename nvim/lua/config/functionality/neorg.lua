if not vim.env.NEORG then
    return
end

require("neorg").setup {
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
}

vim.keymap.set("n", "<localleader>nw", ":Neorg workspace ", { desc = "[neorg] Enter workspace" })
vim.keymap.set("n", "<localleader>nr", "<cmd>Neorg return<CR>", { desc = "[neorg] Return" })
