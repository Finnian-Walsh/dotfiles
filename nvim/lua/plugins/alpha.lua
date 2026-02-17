local function create_padding(value)
    return { type = "padding", val = value or 2 }
end

local function uninitialized_padding()
    return { type = "padding" }
end

local function center_text(text, required_width)
    local text_width = vim.fn.strdisplaywidth(text)
    local missing_width = required_width - text_width
    local first_half = math.floor(missing_width / 2)
    local second_half = math.ceil(missing_width / 2)

    return string.rep(" ", first_half) .. text .. string.rep(" ", second_half)
end

local HeaderValues = {}

function HeaderValues.__index(self, key)
    if key == "selected" then
        return self._headers[rawget(self, "_selected_index")]
    else
        return HeaderValues[key]
    end
end

function HeaderValues.new(...)
    local raw_values = {...}
    local ordered_values = {}

    for _, value in ipairs(raw_values) do
        table.insert(ordered_values, {
            name = value[1],
            text = value[2],
            width = vim.fn.strdisplaywidth(value[2][1]),
        })
    end

    return setmetatable({
        _headers = ordered_values,
    }, HeaderValues)
end

function HeaderValues:select(name)
    for index, header in ipairs(self._headers) do
        if header.name == name then
            self._selected_index = index
        end
    end
end

function HeaderValues:select_next()
    local new_index = self._selected_index + 1

    if new_index > #self._headers then
        new_index = 1
    end

    self._selected_index = new_index
end

function HeaderValues:select_previous()
    local new_index = self._selected_index - 1

    if new_index <= 0 then
        new_index = #self._headers
    end

    self._selected_index = new_index
end

function HeaderValues:add_extensions(extensions)
    for _, header in ipairs(self._headers) do
        local text = header.text
        local header_width = vim.fn.strdisplaywidth(text[1])

        for _, addition in ipairs(extensions) do
            if addition.center then
                table.insert(text, center_text(addition[1], header_width))
            else
                table.insert(text, addition[1])
            end
        end
    end
end

local ButtonCreator = {}
ButtonCreator.__index = ButtonCreator

function ButtonCreator.new(opts)
    opts = opts or {}

    local self = setmetatable({
        _padding = create_padding(opts.padding),
        _buttons = {},
    }, ButtonCreator)

    if opts.buttons then
        self:add_all(opts.buttons)
    end

    return self
end

function ButtonCreator:add(name, key, fn)
    table.insert(self._buttons, {
        name = name,
        key = key,
        fn = fn,
    })
end

function ButtonCreator:add_all(buttons)
    for _, button in ipairs(buttons) do
        self:add(unpack(button))
    end
end

function ButtonCreator:build(text_width)
    local value = {}
    local padding = self._padding

    for _, button in ipairs(self._buttons) do
        local button_name = button.name
        local button_key = button.key
        local button_fn = button.fn

        local spaces = text_width
            - (vim.fn.strdisplaywidth(button_name)
            + vim.fn.strdisplaywidth(button_key)
            + 2)

        local button_val = button_name
            .. string.rep(" ", spaces)
            .. "["
            .. button.key
            .. "]"

        table.insert(value, {
            on_press = button_fn,
            opts = {
                position = "center",
                cursor = vim.fn.strdisplaywidth(button_val) - 2,
                keymap = { "n", button.key, button_fn },
                hl = {
                    { "AlphaText", 0, #button_name, },
                    { "AlphaBracket", #button_val - 3, #button_val - 2, },
                    { "AlphaShortcut", #button_val - 2, #button_val - 1, },
                    { "AlphaBracket", #button_val - 1, #button_val, },
                },
            },
            type = "button",
            val = button_val,
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
                local iter = loaded_alpha_buffers()

                if iter() then
                    return
                end

                header_cycle_system:stop()
            end)
        end
    })

    local header_values = HeaderValues.new(
        {"italics", {
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
        }},
        {"straight", {
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        }},
        {"spooky", {
            " ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓",
            " ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒",
            "▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░",
            "▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ",
            "▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒",
            "░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░",
            "░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░",
            "   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ",
            "         ░    ░  ░    ░ ░        ░   ░         ░   ",
            "                                ░                  ",
        }},
        {"one_piece", {
            "    ▄▄▄██▀▀▀▒█████ ▓██   ██▓ ▄▄▄▄    ▒█████ ▓██   ██▓ ",
            "      ▒██  ▒██▒  ██▒▒██  ██▒▓█████▄ ▒██▒  ██▒▒██  ██▒ ",
            "      ░██  ▒██░  ██▒ ▒██ ██░▒██▒ ▄██▒██░  ██▒ ▒██ ██░ ",
            "   ▓██▄██▓ ▒██   ██░ ░ ▐██▓░▒██░█▀  ▒██   ██░ ░ ▐██▓░ ",
            "    ▓███▒  ░ ████▓▒░ ░ ██▒▓░░▓█  ▀█▓░ ████▓▒░ ░ ██▒▓░ ",
            "    ▒▓▒▒░  ░ ▒░▒░▒░   ██▒▒▒ ░▒▓███▀▒░ ▒░▒░▒░   ██▒▒▒  ",
            "    ▒ ░▒░    ░ ▒ ▒░ ▓██ ░▒░ ▒░▒   ░   ░ ▒ ▒░ ▓██ ░▒░  ",
            "    ░ ░ ░  ░ ░ ░ ▒  ▒ ▒ ░░   ░    ░ ░ ░ ░ ▒  ▒ ▒ ░░   ",
            "    ░   ░      ░ ░  ░ ░      ░          ░ ░  ░ ░      ",
            "                    ░ ░           ░          ░ ░      ",
        }}
    )

    header_values:select[[straight]]

    local header_extensions = {}

    if current_month == 9 then
        header_values:select[[spooky]]
        table.insert(header_extensions, {""})
        table.insert(header_extensions, {
            days_until_halloween <= 0
                and "Happy Halloween!"
                or days_until_halloween .. " days until Halloween!",
            center = true,
        })
    elseif current_month == 12 then
        table.insert(header_extensions, {""})
        table.insert(header_extensions, {
            days_until_xmas < 0
                and "Merry Christmas!"
                or days_until_xmas == 1
                and "1 day until Christmas!"
                or days_until_xmas .. " days until Christmas!",
            center = true,
        })
    end

    header_values:add_extensions(header_extensions)

    local header = {
        type = "text",
        val = header_values.selected.text,
        opts = {
            position = "center",
            hl = "AlphaHeader",
        },
    }

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function(event)
            local opts = { buffer = event.buf, silent = true, noremap = true }

            local function merge_opts(t)
                for k, v in pairs(opts) do
                    if not t[k] then
                        t[k] = v
                    end
                end

                return t
            end

            vim.keymap.set("n", "{", function()
                header_values:select_next()
                header.val = header_values.selected.text
                vim.cmd[[AlphaRedraw]]
            end, merge_opts{ desc = "Previous header value" })

            vim.keymap.set("n", "}", function()
                header_values:select_previous()
                header.val = header_values.selected.text
                vim.cmd[[AlphaRedraw]]
            end, merge_opts{ desc = "Next header value" })

            vim.keymap.set("n", "F", "<cmd>Telescope find_files initial_mode=normal<CR>", merge_opts{ desc = "Find files (start in normal)" })
        end
    })

    local buttons = ButtonCreator.new{
        padding = 1,
        buttons = {
            { "󱏒 Oil", "t", function() vim.cmd("Oil") end },
            { "󰭎 Live grep", "/", function() vim.cmd("Telescope live_grep") end },
            { " Fuzzy find", "f", function() vim.cmd("Telescope find_files") end },
            { " Resume telescope", "R", function() vim.cmd("Telescope resume") end },
            { " Header coloring", "h", function() vim.cmd("HeaderColor") end },
            { "󰈆 Quit", "q", function() vim.cmd("quit") end },
        },
    }

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
        vim.api.nvim_set_hl(0, "Ferris", { fg = "#ba0c2f", bold = true })
        vim.api.nvim_set_hl(0, "AlphaText", { fg = "#f4c430"})
        vim.api.nvim_set_hl(0, "AlphaBracket", { fg = "#7aa2f7"})
        vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ff966C"})
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_highlights,
    })

    if vim.g.colors_name then
        set_highlights()
    end

    local padding_values = {
        top = uninitialized_padding(),
        header = uninitialized_padding(),
        buttons = uninitialized_padding(),
        bottom = uninitialized_padding(),
    }

    local function update_padding_values()
        local screen_lines = vim.o.lines -- vim.fn.line('w$') - vim.fn.line('w0') + 1
        padding_values.bottom.val = screen_lines

        if screen_lines > 55 then
            padding_values.top.val = 4
            padding_values.header.val = 5
            padding_values.buttons.val = 6
        elseif screen_lines >= 45 then
            padding_values.top.val = 3
            padding_values.header.val = 3
            padding_values.buttons.val = 3
        elseif screen_lines >= 40 then
            padding_values.top.val = 2
            padding_values.header.val = 3
            padding_values.buttons.val = 3
        elseif screen_lines >= 36 then
            padding_values.top.val = 2
            padding_values.header.val = 2
            padding_values.buttons.val = 0
        else
            padding_values.top.val = 1
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
        buttons:build(header_values.selected.width),
        padding_values.buttons,
        ferris,
        padding_values.bottom,
    }

    local theme = { layout = layout }
    require("alpha").setup(theme)
end

return {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = config,
}
