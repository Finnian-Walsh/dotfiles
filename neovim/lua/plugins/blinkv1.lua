local blink_cmp = require("blink.cmp")

blink_cmp.setup {
    keymap = {
        preset = "none",
        ["<Down>"] = { "insert_next", "fallback" },
        ["<Up>"] = { "insert_prev", "fallback" },

        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

        ["<CR>"] = { "select_and_accept", "fallback" },

        ["<C-space>"] = { "show", "show_documentation", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    cmdline = {
        keymap = {
            preset = "none",
            ["<Tab>"] = { "show_and_insert_or_accept_single", "insert_next", "fallback" },
            ["<S-Tab>"] = { "show_and_insert_or_accept_single", "insert_prev", "fallback" },

            ["<C-space>"] = { "show", "show_documentation", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },

            ["<C-e>"] = { "cancel" },
        },

        completion = {
            list = { selection = { preselect = false, auto_insert = true } },
        },
    },

    term = {
        enabled = true,
        keymap = {
            preset = "inherit",
        },
    },

    completion = {
        documentation = { auto_show = false },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
}
