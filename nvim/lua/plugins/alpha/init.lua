if vim.env.DISABLE_ALPHA == "1" then
    return
end

local CycleSystem = require("plugins.alpha.cycle_system")
local ButtonCreator = require("plugins.alpha.button_creator")
local HeaderValues = require("plugins.alpha.header_values")
local EventProcessor = require("plugins.alpha.event_processor")

local alpha_config_path = vim.fs.joinpath(vim.fn.stdpath("data"), "alpha_config.json")

local Themes = {
    NORMAL = "normal",
    MINIMAL = "minimal",
}

setmetatable(Themes, {
    __index = function(_, index)
        error("No such variant `" .. index .. "`")
    end,
    __newindex = function()
        error("Illegal operation")
    end,
})

local function get_alpha_config()
    local file = io.open(alpha_config_path, "r")

    if not file then
        return {}
    end

    local ok, config = pcall(vim.json.decode, file:read("*a"))
    file:close()

    if not ok then
        vim.notify("Failed to decode alpha config file", vim.log.levels.ERROR)
    end

    return config
end

local function get_deep_changes(updated, base)
    local changes = {}

    for key, value in pairs(updated) do
        if type(value) == "table" then
            local value_changes = get_deep_changes(value, base[key])

            if #value_changes > 0 then
                changes[key] = value_changes
            end
        elseif base[key] ~= value then
            changes[key] = value
        end
    end

    return changes
end

---@param config table The final configuration
---@param base table The initial configuration
local function sync_alpha_config(config, base)
    if type(config) ~= "table" then
        vim.notify("Config is not a table", vim.log.levels.ERROR)
        return
    elseif type(base) ~= "table" then
        vim.notify("Base is not a table", vim.log.levels.ERROR)
        return
    end

    local config_updates = get_deep_changes(config, base)

    local no_updates = true

    for _ in pairs(config_updates) do
        no_updates = false
        break
    end

    if no_updates then
        return
    end

    local current_config = get_alpha_config()
    local updated_config = vim.tbl_deep_extend("force", current_config, config_updates)

    local file = assert(io.open(alpha_config_path, "w"), "Failed to open alpha configuration file")
    file:write(vim.json.encode(updated_config))
    file:close()
end

local function uninitialized_padding()
    return { type = "padding" }
end

local theme = {}
local build_layout

-- "#33D5C1" very neon
-- "#33D5C1" too dark
-- "#33D7BE" lighter
-- "#33D0C3" pretty nice

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

local header_cycle_system = CycleSystem.new(header_colors, 350, reset_header, function(color)
    current_header_color = color
    set_header_color(color)
end)

vim.api.nvim_create_user_command("HeaderColor", function(opts)
    local arg = opts.args

    if arg == "" then
        header_cycle_system:toggle()
    elseif arg == "?" then
        vim.notify(header_cycle_system:is_running() and "active" or "inactive", vim.log.levels.INFO)
    else
        vim.notify("Unknown option: " .. arg, vim.log.levels.ERROR)
    end
end, { desc = "Toggle the header color changing", nargs = "?" })

vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "alpha" then
                    return
                end
            end

            header_cycle_system:stop()
        end)
    end,
})

local alpha_config = get_alpha_config()
local immutable_alpha_config_copy = vim.deepcopy(alpha_config)

local function save_config()
    sync_alpha_config(alpha_config, immutable_alpha_config_copy)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save_config,
})

vim.api.nvim_create_user_command("AlphaSave", save_config, {})

local header_values = HeaderValues.new(require("plugins.alpha.headers"))

header_values:select(alpha_config.header_value or "ansi_shadow")

local header_extensions = {}

local upcoming_event = alpha_config.upcoming_event

if upcoming_event then
    local displayed_event = EventProcessor.new(upcoming_event.date, upcoming_event.text):display()
    vim.list_extend(header_extensions, displayed_event)
end

if current_month == 9 then
    table.insert(header_extensions, { "" })
    table.insert(header_extensions, {
        days_until_halloween <= 0 and "Happy Halloween!" or days_until_halloween .. " days until Halloween!",
        center = true,
    })
elseif current_month == 12 then
    table.insert(header_extensions, { "" })
    table.insert(header_extensions, {
        days_until_xmas < 0 and "Merry Christmas!"
            or days_until_xmas == 1 and "1 day until Christmas!"
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

local function update_header()
    local selected = header_values.selected
    header.val = selected.text
    alpha_config.header_value = selected.name
    theme.layout = build_layout()
    vim.cmd.AlphaRedraw()
end

vim.api.nvim_create_user_command("SetHeader", function(args)
    if #args.fargs == 0 then
        vim.notify("The `" .. alpha_config.header_value .. "` header is currently in use", vim.log.levels.INFO)
    else
        header_values:select(args.args)
        update_header()
    end
end, { nargs = "?" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function(event)
        local buf = event.buf
        local opts = { buffer = buf, silent = true }

        local function merge_opts(t)
            for k, v in pairs(opts) do
                if not t[k] then
                    t[k] = v
                end
            end

            return t
        end

        vim.keymap.set("n", "{", function()
            header_values:select_previous()
            update_header()
        end, merge_opts { desc = "Previous header value" })

        vim.keymap.set("n", "}", function()
            header_values:select_next()
            update_header()
        end, merge_opts { desc = "Next header value" })

        vim.keymap.set("n", "/", "<leader>/", merge_opts { remap = true, desc = "Live grep with telescope" })

        vim.keymap.set("n", "f", "<leader>f", merge_opts { remap = true, desc = "Find files with telescope" })

        vim.keymap.set("n", "F", "<leader>F", merge_opts { remap = true, desc = "Find files (start in normal)" })

        vim.keymap.set("n", "e", "<leader>e", merge_opts { remap = true, desc = "Open oil file tree" })

        vim.keymap.set("n", "E", "<leader>E", merge_opts { remap = true, desc = "Open oil file tree at cwd" })

        vim.keymap.set("n", "T", "<leader>T", merge_opts { remap = true, desc = "Mini files" })
    end,
})

local minimize_alpha, maximize_alpha

local buttons = ButtonCreator.new {
    padding = 1,
    buttons = {
        {
            "󱏒 Mini Files",
            "t",
            function()
                require("mini.files").open() -- don't reference the function directly, since it is likely to be loaded after alpha
            end,
        },
        {
            " New buffer",
            "w",
            vim.cmd.enew,
        },
        {
            " View Directory",
            "d",
            function()
                Snacks.explorer()
            end,
        },
        {
            " Config",
            "c",
            function()
                local dir = vim.fs.normalize(
                    vim.fn.resolve(
                        vim.fs.joinpath(
                            vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(vim.env.HOME, ".config"),
                            vim.env.NVIM_APPNAME or "nvim"
                        )
                    )
                )

                vim.cmd.ChangeHookerDirectory(dir)
                vim.cmd.edit(".")
            end,
        },
        {
            " Header coloring",
            "h",
            vim.cmd.HeaderColor,
        },
        {
            " Minimize",
            "m",
            function()
                minimize_alpha()
            end,
        },
        {
            "󰈆 Quit",
            "q",
            vim.cmd.quit,
        },
    },
}

local ferris = {
    type = "text",
    val = {
        [[█ █           █ █]],
        [[▀█  ▄███████▄  █▀]],
        [[ ▀▄████▀█▀████▄▀ ]],
        [[ ▄▀████▀▀▀████▀▄ ]],
        [[ █ ▄▀▀▀▀▀▀▀▀▀▄ █ ]],
    },
    opts = {
        position = "center",
        hl = "Ferris",
    },
}

local minimal_buttons = ButtonCreator.new {
    padding = 0,
    buttons = {
        {
            " Maximize",
            "m",
            function()
                maximize_alpha()
            end,
        },
        {
            "󰈆 Quit",
            "q",
            vim.cmd.quit,
        },
    },
}

local function set_highlights()
    set_header_color(current_header_color)
    vim.api.nvim_set_hl(0, "Ferris", { fg = "#ba0c2f", bold = true })
    vim.api.nvim_set_hl(0, "AlphaText", { fg = "#f4c430" })
    vim.api.nvim_set_hl(0, "AlphaBracket", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ff966C" })
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

local maximize_button = minimal_buttons._buttons
local minimal_layout = {
    { type = "padding", val = 1 },
    minimal_buttons:build(
        vim.fn.strdisplaywidth(maximize_button.name)
            + vim.fn.strdisplaywidth(maximize_button.key)
            + vim.fn.strdisplaywidth("[]")
    ),
}

function build_layout()
    if alpha_config.theme == Themes.MINIMAL then
        return minimal_layout -- static layout, so can be built once
    else
        return {
            padding_values.top,
            header,
            padding_values.header,
            buttons:build(header_values.selected.width),
            padding_values.buttons,
            ferris,
            padding_values.bottom,
        }
    end
end

local function reset_alpha_buffers()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype ~= "alpha" then
            goto continue
        end

        vim.api.nvim_win_call(win, function()
            vim.cmd("enew | Alpha")
        end)

        ::continue::
    end
end

function minimize_alpha()
    if vim.fn.confirm("Minimize alpha screen?", "&Yes\n&No") == 1 then
        alpha_config.theme = Themes.MINIMAL
        theme.layout = minimal_layout
        reset_alpha_buffers()
    end
end

function maximize_alpha()
    if vim.fn.confirm("Maximize alpha screen?", "&Yes\n&No") == 1 then
        alpha_config.theme = Themes.NORMAL
        theme.layout = build_layout()
        reset_alpha_buffers()
    end
end

theme.layout = build_layout()

require("alpha").setup(theme)

vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        update_padding_values()
        vim.cmd.AlphaRedraw()
    end,
})

vim.api.nvim_create_autocmd("WinNew", {
    callback = function()
        if vim.api.nvim_win_get_config(0).relative == "" then
            vim.cmd.AlphaRedraw()
        end
    end,
})

vim.keymap.set("n", "<leader>A", vim.cmd.Alpha, { desc = "Toggle Alpha" })

vim.keymap.set("n", "<leader>nA", function()
    vim.cmd("vs | wincmd l")
    if vim.bo.filetype ~= "alpha" then
        vim.cmd.Alpha()
    end
end, { desc = "Toggle Alpha in a new vertical split" })

vim.keymap.set("n", "<leader>NA", function()
    vim.cmd("sp | wincmd j")
    if vim.bo.filetype ~= "alpha" then
        vim.cmd.Alpha()
    end
end, { desc = "Toggle Alpha in a new horizontal split" })
