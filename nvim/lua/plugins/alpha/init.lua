local CycleSystem = require("plugins.alpha.cycle_system")
local ButtonCreator = require("plugins.alpha.button_creator")
local HeaderValues = require("plugins.alpha.header_values")

local alpha_config_path = vim.fn.stdpath("data") .. "/alpha_config.json"

local Themes = setmetatable({
    NORMAL = "normal",
    MINIMAL = "minimal",
}, {
    __index = function(_, index)
        error("No such variant `" .. index .. "`")
    end,
})

local function get_alpha_config()
    local file = io.open(alpha_config_path, "r")

    if not file then
        return {}
    end

    local ok, config = pcall(vim.json.decode, file:read("*a"))

    if not ok then
        vim.api.nvim_echo({ { "Failed to decode alpha config file", "WarningMsg" } }, true, {})
    end

    return config
end

local function set_alpha_config(config)
    local file = io.open(alpha_config_path, "w")

    if not file then
        vim.api.nvim_echo({ { "Failed to save theme layout", "ErrorMsg" } }, true, {})
        return
    end

    file:write(vim.json.encode(config))
end

local function uninitialized_padding()
    return { type = "padding" }
end

local function get_confirmation(message)
    vim.notify(message)

    while true do
        local response = vim.fn.getchar()

        if response_key_codes.affirmative[response] then
            return true
        elseif response_key_codes.negative[response] or response_key_codes.abortive[response] then
            return false
        end
    end
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
            vim.api.nvim_echo({
                { "Unknown option: " .. arg, "ErrorMsg" },
            }, true, {})
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

    local header_values = HeaderValues.new({
        "italics",
        {
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
        },
    }, {
        "straight",
        {
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        },
    }, {
        "spooky",
        {
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
        },
    }, {
        "one_piece",
        {
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
        },
    })

    header_values:select([[straight]])

    local header_extensions = {}

    if current_month == 9 then
        header_values:select([[spooky]])
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
                vim.cmd([[AlphaRedraw]])
            end, merge_opts { desc = "Previous header value" })

            vim.keymap.set("n", "}", function()
                header_values:select_previous()
                header.val = header_values.selected.text
                vim.cmd([[AlphaRedraw]])
            end, merge_opts { desc = "Next header value" })

            vim.keymap.set(
                "n",
                "F",
                "<cmd>Telescope find_files initial_mode=normal<CR>",
                merge_opts { desc = "Find files (start in normal)" }
            )
        end,
    })

    local minimize_alpha, maximize_alpha

    local buttons = ButtonCreator.new {
        padding = 1,
        buttons = {
            {
                "󱏒 Oil",
                "t",
                function()
                    vim.cmd("Oil")
                end,
            },
            {
                "󰭎 Live grep",
                "/",
                function()
                    vim.cmd("Telescope live_grep")
                end,
            },
            {
                " Fuzzy find",
                "f",
                function()
                    vim.cmd("Telescope find_files")
                end,
            },
            {
                " Resume telescope",
                "R",
                function()
                    vim.cmd("Telescope resume")
                end,
            },
            {
                " Header coloring",
                "h",
                function()
                    vim.cmd("HeaderColor")
                end,
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
                function()
                    vim.cmd("quit")
                end,
            },
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
                function()
                    vim.cmd("quit")
                end,
            },
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

    local maximize_button = minimal_buttons._buttons
    local minimal_layout = {
        minimal_buttons:build(
            vim.fn.strdisplaywidth(maximize_button.name)
                + vim.fn.strdisplaywidth(maximize_button.key)
                + vim.fn.strdisplaywidth("[]")
        ),
    }

    local theme = {}

    local function reset_alpha_buffers()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)

            if vim.bo[buf].filetype ~= "alpha" then
                goto continue
            end

            vim.api.nvim_win_call(win, function()
                vim.cmd("enew")
                vim.cmd("Alpha")
            end)

            ::continue::
        end
    end

    function minimize_alpha()
        if get_confirmation("Minimize alpha screen? (Y)es, (N)o ") then
            theme.layout = minimal_layout
            set_alpha_config { theme = Themes.MINIMAL }
            reset_alpha_buffers()
        end
    end

    function maximize_alpha()
        if get_confirmation("Maximize alpha screen? (Y)es, (N)o ") then
            theme.layout = layout
            set_alpha_config { theme = Themes.NORMAL }
            reset_alpha_buffers()
        end
    end

    local alpha_config = get_alpha_config()

    if alpha_config.theme == Themes.MINIMAL then
        theme.layout = minimal_layout
    elseif alpha_config.theme == Themes.NORMAL or true then
        theme.layout = layout
    end

    require("alpha").setup(theme)
end

return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = config,
}
