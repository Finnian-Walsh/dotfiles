local blink_cmp = require('blink.cmp')
local build_task = blink_cmp.build()

build_task:on_reject(function()
vim.notify("Failed to build blink-cmp", vim.log.levels.ERROR)
end)

build_task:on_resolve(function()
blink_cmp.setup{
    keymap = {
	["<Right>"] = { "insert_next", "fallback" },
	["<Left>"] = { "insert_prev", "fallback" },
	["<Tab>"] = { "select_next", "fallback" },
	["<S-Tab>"] = { "select_prev", "fallback" },
	["<CR>"] = { "select_and_accept", "fallback" },
	["<C-e>"] = { "hide", "fallback" },
	-- <C-space> for documentation
	    },

    completion = { documentation = { auto_show = false } },

    sources = {
	default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
}
end)
