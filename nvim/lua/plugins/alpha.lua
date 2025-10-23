local function create_padding(value)
    return { type = "padding", val = value or 2 }
end

local CenteredButtons = {}
CenteredButtons.__index = CenteredButtons

function CenteredButtons.new(opts)
    opts = opts or {}
    return setmetatable({
        _padding = create_padding(opts.padding),
        _buttons = {},
        _max_name_width = 0,
    }, CenteredButtons)
end

function CenteredButtons:add(name, key, fn)
    local name_width = vim.fn.strdisplaywidth(name)

    if name_width > self._max_name_width then
        self._max_name_width = name_width
    end

    table.insert(self._buttons, {
        name = name,
        name_width = name_width,
        key = key,
        fn = fn,
    })
end

function CenteredButtons:add_all(buttons)
    for _, button in ipairs(buttons) do
        self:add(table.unpack(button))
    end
end

function CenteredButtons:build()
    local value = {}
    local padding = self._padding
    local max_name_width = self._max_name_width

    for _, button in ipairs(self._buttons) do
        local fn = button.fn
        table.insert(value, {
            on_press = fn,
            opts = {
                position = "center",
                shortcut = "[" .. button.key .. "] ",
                cursor = 1,
                keymap = { "n", button.key, fn },
            },
            type = "button",
            val = button.name .. string.rep(" ", max_name_width - button.name_width),
        })
        table.insert(value, padding)
    end

    return {
        type = "group",
        val = value,
    }
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

    local buttons = CenteredButtons.new({ padding = 1 })

    buttons:add(" New file", "e", function()
        vim.cmd("enew | startinsert")
    end)

    buttons:add("󱏒 Oil", "t", function() vim.cmd("Oil") end)

    buttons:add("󰭎 Find files", "f", function() vim.cmd("Telescope live_grep") end)

    buttons:add("󰒲 Lazy", "l", function() vim.cmd("Lazy") end)

    buttons:add("󰢛 Mason", "m", function() vim.cmd("Mason") end)

    buttons:add("󱡅 Harpoon", "h", function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    buttons:add("󰈆 Quit", "q", function() vim.cmd("quit") end)

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
        buttons:build(),
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
