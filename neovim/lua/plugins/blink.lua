local opts = {
    keymap = {
        preset = "none",
        ["<Down>"] = { "insert_next", "fallback" },
        ["<Up>"] = { "insert_prev", "fallback" },

        ["<Right>"] = { "insert_next", "fallback" },
        ["<Left>"] = { "insert_prev", "fallback" },

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
        default = { "lsp", "path", "snippets", "buffer", "emoji" },

        providers = {
            emoji = {
                name = "emoji",
                module = "blink.compat.source",
                -- overwrite kind of suggestion
                transform_items = function(_, items)
                    local kind = require("blink.cmp.types").CompletionItemKind.Text
                    for i = 1, #items do
                        items[i].kind = kind
                    end
                    return items
                end,
            },
        },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
}

return {
    plugins = {
        "https://github.com/saghen/blink.cmp",
        "https://github.com/saghen/blink.compat",
        "https://github.com/saghen/blink.lib",
        "https://github.com/rafamadriz/friendly-snippets",
    },

    config = function()
        local blink_cmp = require("blink.cmp")
        local build_task = blink_cmp.build()

        build_task:on_reject(function()
            vim.notify("Failed to build blink.cmp", vim.log.levels.ERROR)
        end)

        build_task:on_resolve(function()
            vim.schedule(function()
                blink_cmp.setup(opts)
            end)
        end)
    end,
}
