local plugins = {}

local function add(additional_plugins)
    vim.list_extend(plugins, additional_plugins)
end

-- Aesthetical plugins

add {
    "https://github.com/folke/tokyonight.nvim",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/ChaseRensberger/christmas.nvim",
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/rose-pine/neovim",
    "https://github.com/benjasper/nightfall.nvim",
    "https://github.com/edeneast/nightfox.nvim",
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

-- Functional plugins

add {
    "https://github.com/windwp/nvim-autopairs",
}

add {
    "https://github.com/saghen/blink.cmp",
    "https://github.com/saghen/blink.lib",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saghen/blink.compat",
}

add {
    "https://github.com/lewis6991/gitsigns.nvim",
}

add {
    "https://github.com/Finnian-Walsh/hooker.nvim",
}

add {
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://github.com/neovim/nvim-lspconfig",
}

add {
    "https://github.com/nvim-mini/mini.files",
    "https://github.com/nvim-mini/mini.surround",
}

add {
    "https://github.com/nvim-neorg/neorg",
}

add {
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/mfussenegger/nvim-dap-python",
}

add {
    "https://github.com/toppair/peek.nvim",
}

add {
    { src = "https://github.com/Finnian-Walsh/plugin-view.nvim", version = "feat/buffer-updation" },
    -- { src = "https://github.com/Finnian-Walsh/plugin-testing.nvim", version = "✨" },
}

local snacks_path = vim.env.HOME .. "/Dev/snacks.nvim/"

if vim.uv.fs_stat(snacks_path) then
    vim.opt.rtp:prepend(snacks_path)
else
    add {
        "https://github.com/folke/snacks.nvim",
    }
end

add {
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
}

add {
    "https://github.com/folke/which-key.nvim",
}

add {
    "https://github.com/pogyomo/winresize.nvim",
}

return plugins
