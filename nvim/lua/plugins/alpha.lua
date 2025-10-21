local function create_padding(padding)
    return { type = "padding", val = padding or 2 }
end

local function fit_text(text_objects)
    local max_width = 0
    for _, text in pairs(text_objects) do
        local width = vim.fn.strdisplaywidth(text)

        if width > max_width then
            max_width = width
        end
    end

    for k, text in pairs(text_objects) do
        local extended_text = text .. string.rep(' ', max_width - vim.fn.strdisplaywidth(text))
        text_objects[k] = extended_text
    end
end

return {
    "goolord/alpha-nvim",
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local button_values = {
            new_file = " New file",
            find_files = "󰭎 Find files",
            harpoon = "󱡅 Harpoon",
            config = " Config",
            quit = "󰈆 Quit",
        }

        fit_text(button_values)

        local actions = {
            find_files = function() vim.cmd("Telescope live_grep") end,
            harpoon = function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            new_file = function()
                vim.cmd("enew")
                vim.cmd("startinsert")
            end,
            config = function()
                vim.api.nvim_set_current_dir(vim.fn.stdpath("config"))
                vim.cmd("edit .")
            end,
            quit = function() vim.cmd("quit") end
        }

        local header = {
            type = "text",
            val = {
                [[        The best code editor of all time!        ]],
                [[                               __                ]],
                [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
                [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
                [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
                [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
                [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
            },
            opts = {
                position = "center",
                hl = "Type",
            },
        }

        local buttons_val = { {
            on_press = actions.new_file,
            opts = {
                position = "center",
                shortcut = "[e] ",
                cursor = 1,
                keymap = { "n", "e", actions.new_file },
            },
            type = "button",
            val = button_values.new_file,
        }, create_padding(1), {
                on_press = actions.find_files,
                opts = {
                    position = "center",
                    shortcut = "[f] ",
                    cursor = 1,
                    keymap = { "n", "f", actions.find_files },
                },
                type = "button",
                val = button_values.find_files,
            }, create_padding(1), {
                on_press = actions.harpoon,
                opts = {
                    position = "center",
                    shortcut = "[h] ",
                    cursor = 1,
                    keymap = { "n", "h", actions.harpoon }
                },
                type = "button",
                val = button_values.harpoon,
            }, create_padding(1), {
                on_press = actions.config,
                opts = {
                    position = "center",
                    shortcut = "[c] ",
                    cursor = 1,
                    keymap = { "n", "c", actions.config },
                },
                type = "button",
                val = button_values.config,
            }, create_padding(1), {
                on_press = actions.quit,
                opts = {
                    position = "center",
                    shortcut = "[q] ",
                    cursor = 1,
                    keymap = { "n", "q", actions.quit },
                },
                type = "button",
                val = button_values.quit,
            }
        }

        local layout = {
            create_padding(5),
            header,
            create_padding(),
            {
                type = "group",
                val = buttons_val,
            },
            create_padding(),
        }

        local theme = { layout = layout }
        require("alpha").setup(theme)
    end,
}
