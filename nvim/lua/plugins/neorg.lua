return {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/notes",
                            school = "~/notes/school",
                            sparx = "~/notes/school/sparx",
                        },
                    },
                },
            }
        }

        vim.keymap.set("n", "<localleader>nw", ":Neorg workspace ")
        vim.keymap.set("n", "<localleader>nr", ":Neorg return<CR>", { silent = true })
    end,
}
