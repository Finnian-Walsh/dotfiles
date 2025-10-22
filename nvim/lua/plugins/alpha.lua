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

local function config()
    -- #33D5C1 very neon
    -- #33D5C1 too dark
    -- #33D7BE lighter
    -- #33D0C3 pretty nice
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#33D0C3", bold = true })

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
            hl = "AlphaHeader",
        },
    }

    local button_values = {
        new_file = " New file",
        oil = "󱏒 Oil",
        harpoon = "󱡅 Harpoon",
        find_files = "󰭎 Find files",
        quit = "󰈆 Quit",
    }

    fit_text(button_values)

    local actions = {
        new_file_fn = function()
            vim.cmd("enew")
            vim.cmd("startinsert")
        end,
        new_file_cmd = "<cmd>enew | startinsert<CR>",
        oil = function() vim.cmd("Oil") end,
        oil_cmd = "<cmd>Oil<CR>",
        harpoon = function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        find_files_fn = function() vim.cmd("Telescope live_grep") end,
        find_files_cmd = "<cmd>Telescope live_grep<CR>",
        quit_fn = function() vim.cmd("quit") end,
        quit_cmd = "<cmd>quit<CR>",
    }

    local buttons_val = {
        {
            on_press = actions.new_file_fn,
            opts = {
                position = "center",
                shortcut = "[e] ",
                cursor = 1,
                keymap = { "n", "e", actions.new_file_cmd },
            },
            type = "button",
            val = button_values.new_file,
        }, create_padding(1), {
            on_press = actions.oil,
            opts = {
                position = "center",
                shortcut = "[t] ",
                cursor = 1,
                keymap = { "n", "t", actions.oil_cmd },
            },
            type = "button",
            val = button_values.oil,
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
            on_press = actions.find_files_fn,
            opts = {
                position = "center",
                shortcut = "[f] ",
                cursor = 1,
                keymap = { "n", "f", actions.find_files_cmd },
            },
            type = "button",
            val = button_values.find_files,
        }, create_padding(1), {
            on_press = actions.quit_fn,
            opts = {
                position = "center",
                shortcut = "[q] ",
                cursor = 1,
                keymap = { "n", "q", actions.quit_cmd },
            },
            type = "button",
            val = button_values.quit,
        }
    }

    vim.api.nvim_set_hl(0, "Ferris", { fg = "#BA0C2F", bold = true })

    local ferris = {
        type = "text",
        val = {
            [[█ █         █ █]],
            [[▀█  ▄█████▄  █▀]],
            [[ ▀▄███▀█▀███▄▀ ]],
            [[ ▄▀███▀▀▀███▀▄ ]],
            [[ █ ▄▀▀▀▀▀▀▀▄ █ ]],
        },
        opts = {
            position = "center",
            hl = "Ferris",
        }
    }

    local layout = {
        create_padding(5),
        header,
        create_padding(3),
        {
            type = "group",
            val = buttons_val,
        },
        create_padding(3),
        ferris,
    }

    local theme = { layout = layout }
    require("alpha").setup(theme)
end

return {
    "goolord/alpha-nvim",
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = config,
}
