local plugins = {}

local function add(additional_plugins)
    vim.list_extend(plugins, additional_plugins)
end

add {
    "https://github.com/ChaseRensberger/christmas.nvim",
    "https://github.com/folke/tokyonight.nvim",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/ellisonleao/gruvbox.nvim",
}

add {
    "https://github.com/goolord/alpha-nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
}

add {
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
}

add {
    "https://github.com/marcussimonsen/let-it-snow.nvim",
}

add {
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
}

add {
    "https://github.com/saghen/blink.cmp",
    "https://github.com/saghen/blink.lib",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saghen/blink.compat",
}

add {
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/nvim-mini/mini.files",
    "https://github.com/nvim-mini/mini.surround",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
}

add {
    "https://github.com/lewis6991/gitsigns.nvim",
}

add {
    "https://github.com/Finnian-Walsh/hooker.nvim",
}

add {
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://github.com/neovim/nvim-lspconfig",
}

add {
    "https://github.com/nvim-neorg/neorg",
}

add {
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/mfussenegger/nvim-dap-python",
}

add {
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
}

add {
    { src = "https://github.com/Finnian-Walsh/plugin-view.nvim", version = "feat/buffer-updation" },
}

add {
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
}

add {
    "https://github.com/akinsho/toggleterm.nvim",
}

add {
    "https://github.com/mbbill/undotree",
}

add {
    "https://github.com/folke/which-key.nvim",
}

add {
    "https://github.com/pogyomo/winresize.nvim",
}

-- add {
--     {
--         src = "https://github.com/Finnian-Walsh/plugin-testing.nvim",
--         version = "✨",
--     },
-- }

return plugins
