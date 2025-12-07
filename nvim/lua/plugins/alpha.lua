local function create_padding(value)
    return { type = "padding", val = value or 2 }
end

local function uninitialized_padding()
    return { type = "padding" }
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

local CycleSystem = {}
CycleSystem.__index = CycleSystem

function CycleSystem.new(items, interval, reset, fn)
    return setmetatable({
        items = items,
        reset = reset,
        fn = fn,
        _running = false,
        _index = 1,
        _last_used = 0,
        _interval = interval,
        _extended_interval = interval + 1,
    }, CycleSystem)
end

function CycleSystem:is_running()
    return self._running
end

function CycleSystem:start()
    if self._running or self._last_used + self._extended_interval > os.time() * 1000 then
        return
    end

    self._running = true
    self:_next()
end

function CycleSystem:_next()
    if not self._running then
        return
    end

    local new_index = self._index % #self.items + 1
    self._index = new_index
    self.fn(self.items[new_index])

    vim.defer_fn(function()
        self:_next()
    end, self._interval)
end

function CycleSystem:stop()
    if not self._running then
        return
    end

    self._running = false
    self._last_used = os.time() * 1000

    vim.defer_fn(function()
        self.reset()
    end, self._extended_interval)
end

function CycleSystem:toggle()
    if self._running then
        self:stop()
    else
        self:start()
    end
end

local function loaded_alpha_buffers()
    return coroutine.wrap(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf)
                and vim.bo[buf].filetype == "alpha" then
                coroutine.yield(buf)
            end
        end
    end)
end

local function config()
    -- #33D5C1 very neon
    -- #33D5C1 too dark
    -- #33D7BE lighter
    -- #33D0C3 pretty nice

    local header_colors = {
        "#33D0C3",
        "#250ECF",
        "#FFA0A0",
        "#CF0E0E",
        "#FCBA03",
        "#14FC03",
        "#DB34EB",
        "#D60DA7",
    }

    local default_color = header_colors[1]
    local current_header_color = default_color

    local function set_header_color(color)
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = color, bold = true })
    end

    local function reset_header()
        set_header_color(default_color)
    end

    local header_cycle_system = CycleSystem.new(
        header_colors,
        350,
        reset_header,
        function(color)
            current_header_color = color
            set_header_color(color)
        end
    )

    vim.api.nvim_create_user_command("HeaderColor", function(opts)
        local arg = opts.args

        if arg == "" then
            header_cycle_system:toggle()
        elseif arg == "?" then
            vim.notify(header_cycle_system:is_running() and "active" or "inactive", vim.log.levels.INFO)
        else
            vim.api.nvim_echo({
                { "Unknown option: " .. arg, "ErrorMsg" },
            }, true, {})
        end
    end, { desc = "Toggle the header color changing", nargs = "?" })

    vim.api.nvim_create_autocmd("BufLeave", {
        callback = function()
            vim.schedule(function()
                if not loaded_alpha_buffers() then
                    header_cycle_system:stop()
                end
            end)
        end
    })

    local header = {
        type = "text",
        val = {
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

    buttons:add("󱏒 Oil", "t", function() vim.cmd("Oil") end)

    buttons:add(" Bufferline", "B", function() vim.cmd("ToggleBufferline") end)

    buttons:add("󰭎 Live grep", "/", function() vim.cmd("Telescope live_grep") end)

    buttons:add(" Fuzzy find", "f", function() vim.cmd("Telescope find_files") end)

    buttons:add(" Resume telescope", "R", function() vim.cmd("Telescope resume") end)

    buttons:add(" Header coloring", "c", function() vim.cmd("HeaderColor") end)

    buttons:add("󰒲 Lazy", "L", function() vim.cmd("Lazy") end)

    buttons:add("󰢛 Mason", "M", function() vim.cmd("Mason") end)

    local harpoon
    buttons:add("󱡅 Harpoon", "h", function()
        harpoon = harpoon or require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    buttons:add("󰈆 Quit", "q", function() vim.cmd("quit") end)

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

    local function set_highlights()
        set_header_color(current_header_color)
        vim.api.nvim_set_hl(0, "Ferris", { fg = "#BA0C2F", bold = true })
    end

    set_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_highlights,
    })

    local padding_values = {
        top = uninitialized_padding(),
        header = uninitialized_padding(),
        buttons = uninitialized_padding(),
    }

    local function update_padding_values()
        local screen_lines = vim.o.lines -- vim.fn.line('w$') - vim.fn.line('w0') + 1

        if screen_lines > 44 then
            padding_values.top.val = 3
            padding_values.header.val = 3
            padding_values.buttons.val = 3
        elseif screen_lines >= 40 then
            padding_values.top.val = 1
            padding_values.header.val = 2
            padding_values.buttons.val = 2
        elseif screen_lines >= 36 then
            padding_values.top.val = 0
            padding_values.header.val = 2
            padding_values.buttons.val = 1
        else
            padding_values.top.val = 0
            padding_values.header.val = 1
            padding_values.buttons.val = 0
        end
    end

    update_padding_values()

    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            update_padding_values()
            vim.cmd("AlphaRedraw")
        end,
    })

    local layout = {
        padding_values.top,
        header,
        padding_values.header,
        buttons:build(),
        padding_values.buttons,
        ferris,
    }

    local theme = { layout = layout }
    require("alpha").setup(theme)
end

return {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = config,
}
