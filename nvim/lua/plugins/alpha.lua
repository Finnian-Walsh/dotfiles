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
                if not loaded_alpha_buffers() then
                    header_cycle_system:stop()
                end
            end)
        end
    })

    local header_values = {
        {{
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
        }, name = "italics"},
        {{
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        }, name = "straight"},
        {{
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
        }, name = "spooky"},
        {{
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
        }, name = "one_piece"},
    }

    local desired_header_val = setmetatable({
        next = function(self)
            local index = self._index

            if index >= #header_values then
                index = 1
            else
                index = index + 1
            end

            self._index = index
        end,
        prev = function(self)
            local index = self._index

            if index <= 1 then
                index = #header_values
            else
                index = index - 1
            end

            self._index = index
        end,
        use = function(self, key)
            for index, header_val in pairs(header_values) do
                if header_val.name == key then
                    rawset(self, "_index", index)
                    return
                end
            end
        end,
    }, {
        __index = function(self, index)
            if index == "value" then
                return header_values[self._index][1]
            else
                return rawget(self, index)
            end
        end,
        __newindex = function()
            error("Cannot assign new index")
        end,
    })

    desired_header_val:use("straight")

    local header_additions = {}

    if current_month == 9 then
        desired_header_val:use("spooky")
        table.insert(header_additions, {""})
        table.insert(header_additions, {
            days_until_halloween .. " days until Halloween!",
            center = true,
        })
    elseif current_month == 12 then
        table.insert(header_additions, {""})
        table.insert(header_additions, {
            days_until_xmas .. " days until Christmas!",
            center = true,
        })
    end

    local header_width = vim.fn.strdisplaywidth(desired_header_val.value[1])

    for _, header in pairs(header_values) do
        local value = header[1]
        for _, addition in ipairs(header_additions) do
            if addition.center then
                table.insert(value, center_text(addition[1], header_width))
            else
                table.insert(value, addition[1])
            end
        end
    end

    local header = {
        type = "text",
        val = desired_header_val.value,
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
                desired_header_val:prev()
                header.val = desired_header_val.value
                vim.cmd[[AlphaRedraw]]
            end, merge_opts{ desc = "Previous header value" })

            vim.keymap.set("n", "}", function()
                desired_header_val:next()
                header.val = desired_header_val.value
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
            { " Header coloring", "C", function() vim.cmd("HeaderColor") end },
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

    set_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_highlights,
    })

    local padding_values = {
        top = uninitialized_padding(),
        header = uninitialized_padding(),
        buttons = uninitialized_padding(),
        bottom = uninitialized_padding(),
    }

    local function update_padding_values()
        local screen_lines = vim.o.lines -- vim.fn.line('w$') - vim.fn.line('w0') + 1
        padding_values.bottom.val = screen_lines

        if screen_lines > 44 then
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
        buttons:build(header_width),
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
