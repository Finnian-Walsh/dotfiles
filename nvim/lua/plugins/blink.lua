return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = "VeryLazy",

    version = '*',

    opts = {
        keymap = {
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },
            ["<C-e>"] = { "hide", "fallback" },
            -- <C-space> for documentation
        },

        completion = { documentation = { auto_show = false } },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
    },

    opts_extend = { "sources.default" },
}
