local blink_cmp = require("blink.cmp")

local build_task = blink_cmp.build()

build_task:on_reject(function()
    vim.notify("Failed to build blink-cmp", vim.log.levels.ERROR)
end)

build_task:on_resolve(function()
    vim.schedule(function()
        blink_cmp.setup {
            keymap = {
                preset = "enter",
            },

            completion = { documentation = { auto_show = false } },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },
        }
    end)
end)
