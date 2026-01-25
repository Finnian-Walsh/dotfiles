vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#00BFA5", bg = "NONE", bold = true })
vim.opt.showtabline = 0

--[[
--------------------------------------------------------
    Colorscheme functionality
--------------------------------------------------------
--]]

local COLORSCHEME_MODE = {
    Default = "default",
    ModifiedDay = "modified_day",
    Festive = "festive",
    Custom = "custom",
}

setmetatable(COLORSCHEME_MODE, {
    __index = function(_, index)
        error("No such index: " .. index)
    end
})

local daily_colorschemes = {
    "catppuccin-mocha", -- Sunday
    "tokyonight", -- Monday
    "habamax", -- Tuesday
    "unokai", -- Wednesday
    "sorbet", -- Thursday
    "catppuccin-frappe", -- Friday
    "catppuccin-macchiato", -- Saturday
}

local days_of_week = {
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
}

local UPDATION_HIGHLIGHT = "ColorschemeUpdation"
local QUERY_HIGHLIGHT = "ColorschemeQuery"

local JsonFields = setmetatable(
    {
        LAST_COLORSCHEME = "last_colorscheme",
        FAVORITES = "favorites",
    }, {
        __index = function(_, key)
            error(string.format("No such json field `%s`", key))
        end,

        __newindex = function()
            error("Keys should not be added to this table")
        end,
    }
)

local current_colorscheme_name = vim.g.colors_name

local current_colorscheme, favorite_colorschemes
local colorscheme_path = vim.fn.stdpath("data") .. "/colorschemes.json"

local ColorschemeState = {}
ColorschemeState.__index = ColorschemeState

function ColorschemeState.default()
    return setmetatable({ colorscheme = daily_colorschemes[current_week_day], mode = COLORSCHEME_MODE.Default }, ColorschemeState)
end

function ColorschemeState.from_colorscheme_data(colorscheme_data)
    if colorscheme_data then
        return setmetatable(colorscheme_data, ColorschemeState)
    end

    return ColorschemeState.default()
end

function ColorschemeState:switch(mode)
    if self.mode == mode then
        return
    end

    for key, _ in pairs(self) do
        self[key] = nil
    end

    self.mode = mode
end

local colorscheme_undo_stack = {}
local colorscheme_redo_stack = {}

local function undo_colorscheme_action()
    -- vim.print(colorscheme_undo_stack)
    local undo_stack_length = #colorscheme_undo_stack

    if undo_stack_length <= 1 then
        return
    end

    local action = colorscheme_undo_stack[undo_stack_length]
    table.remove(colorscheme_undo_stack, undo_stack_length)

    colorscheme_undo_stack[#colorscheme_undo_stack]:apply()

    table.insert(colorscheme_redo_stack, action)
end

local function redo_colorscheme_action()
    -- vim.print(colorscheme_redo_stack)
    local redo_stack_length = #colorscheme_redo_stack

    if redo_stack_length < 1 then
        return
    end

    local action = colorscheme_redo_stack[redo_stack_length]
    action:apply()
    table.remove(colorscheme_redo_stack, redo_stack_length)
    table.insert(colorscheme_undo_stack, action)
end

local ColorschemeAction = {}
ColorschemeAction.__index = ColorschemeAction

function ColorschemeAction.from_current()
    local state = {}

    for key, value in pairs(current_colorscheme) do
        state[key] = value
    end

    return setmetatable(state, ColorschemeAction)
end

function ColorschemeAction:append()
    for i, _ in ipairs(colorscheme_redo_stack) do
        table.remove(colorscheme_redo_stack, i)
    end

    table.insert(colorscheme_undo_stack, self)
end

function ColorschemeAction:apply()
    for key, value in pairs(self) do
        current_colorscheme[key] = value
    end

    vim.cmd("colorscheme " .. self.colorscheme)
end

function ColorschemeAction:append_and_apply()
    self:apply()
    self:append()
end

local function on_colorscheme_changed(event)
    current_colorscheme_name = event.match
    vim.api.nvim_set_hl(0, UPDATION_HIGHLIGHT, { fg = "#5fafff" })
    vim.api.nvim_set_hl(0, QUERY_HIGHLIGHT, { fg = "#fcae1e" })

    if current_colorscheme_name == current_colorscheme.colorscheme then
        return
    end

    current_colorscheme:switch(COLORSCHEME_MODE.Custom)
    current_colorscheme.colorscheme = current_colorscheme_name

    ColorschemeAction.from_current():append()
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = on_colorscheme_changed,
})

local function save_colorscheme_data()
    local file = io.open(colorscheme_path, "w")

    if not file then
        return
    end

    file:write(vim.json.encode({
        [JsonFields.LAST_COLORSCHEME] = current_colorscheme,
        [JsonFields.FAVORITES] = favorite_colorschemes,
    }))
    file:close()
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save_colorscheme_data,
})

local function enable_modified_day_colorscheme(silent, delta)
    delta = delta or 0

    if current_colorscheme.mode == COLORSCHEME_MODE.ModifiedDay then
        current_colorscheme.day = (current_colorscheme.day + delta - 1) % 7 + 1
    else
        current_colorscheme:switch(COLORSCHEME_MODE.ModifiedDay)
        current_colorscheme.day = (current_day + delta - 1) % 7 + 1
    end

    current_colorscheme.colorscheme = daily_colorschemes[current_colorscheme.day]
    ColorschemeAction.from_current():append_and_apply()

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            {
                string.format(
                    "Displaying %s colorscheme for %s (day %d)",
                    current_colorscheme_name,
                    days_of_week[current_colorscheme.day],
                    current_colorscheme.day),
                UPDATION_HIGHLIGHT
            },
        }, true, {})
    end)
end

local function enable_default_colorscheme(silent)
    update_date()

    current_colorscheme:switch(COLORSCHEME_MODE.Default)
    current_colorscheme.colorscheme = daily_colorschemes[current_week_day]

    ColorschemeAction.from_current():append_and_apply()

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Displaying %s colorscheme for current day (%s, day %d)", current_colorscheme_name, days_of_week[current_week_day], current_week_day), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function enable_festive_colorscheme(silent)
    local colorscheme

    if current_month == 12 then
        -- christmas
        colorscheme = "christmas"
    elseif current_month == 10 then
        -- halloween
        colorscheme = "nightfall"
    else
        vim.api.nvim_echo({{"Currently, there are no festive colorschemes", "WarningMsg"}}, true, {})
        return
    end

    assert(type(colorscheme) == "string", "Expected a colorscheme")

    current_colorscheme:switch(COLORSCHEME_MODE.Festive)
    current_colorscheme.colorscheme = colorscheme

    ColorschemeAction.from_current():append_and_apply()

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Displaying %s colorscheme for month %s", colorscheme, current_month), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function query_colorscheme_name()
    vim.api.nvim_echo({{"Colorscheme in use: " .. current_colorscheme_name, QUERY_HIGHLIGHT}}, true, {})
end

local function query_synced_colorscheme()
    local message = {}

    for key, value in pairs(current_colorscheme) do
        table.insert(message, {key .. ": " .. value .. "\n", QUERY_HIGHLIGHT})
    end

    vim.api.nvim_echo(message, true, {})
end

local function get_colorscheme_data()
    local file = io.open(colorscheme_path, "r")

    if not file then
        return ColorschemeState.default()
    end

    local ok, parsed_contents = pcall(vim.json.decode, file:read("*a"))

    if not ok then
        vim.api.nvim_echo({{"Failed to decode contents", "WarningMsg"}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end

    return parsed_contents
end

-- favorites functionality

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require "telescope.config" .values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function open_favorites(opts)
    opts = opts or {}

    pickers.new(opts, {
        finder = finders.new_table {
            results = favorite_colorschemes,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, _)
            actions.select_default:replace(function()
                actions.close(bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd("colorscheme " .. selection[1])
            end)
            return true
        end
    }):find()
end

local function add_to_favorites()
    for _, colorscheme in ipairs(favorite_colorschemes) do
        if current_colorscheme_name == colorscheme then
            vim.api.nvim_echo({{string.format("Colorscheme `%s` is already in your favorites", colorscheme), "WarningMsg"}}, true, {})
            return
        end
    end

    vim.api.nvim_echo({{string.format("Added colorscheme `%s` to favorites", current_colorscheme_name), UPDATION_HIGHLIGHT}}, true, {})
    table.insert(favorite_colorschemes, current_colorscheme_name)
end

local function remove_from_favorites()
    for i, colorscheme in ipairs(favorite_colorschemes) do
        if current_colorscheme_name == colorscheme then
            table.remove(favorite_colorschemes, i)
            vim.api.nvim_echo({{string.format("Removed colorscheme `%s` from favorites", colorscheme), UPDATION_HIGHLIGHT}}, true, {})
            return
        end
    end

    vim.api.nvim_echo({{string.format("Colorscheme `%s` is not in your favorites", current_colorscheme_name), "WarningMsg"}}, true, {})
end

-- keymaps

vim.keymap.set("n", "<S-Left>", function()
    enable_modified_day_colorscheme(false, -vim.v.count1)
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<S-Right>", function()
    enable_modified_day_colorscheme(false, vim.v.count1)
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<S-Down>", enable_default_colorscheme, { desc = "Reset daily colorscheme" })
vim.keymap.set("n", "<S-Up>", enable_festive_colorscheme, { desc = "Synchronize the current colorscheme" })

vim.keymap.set("n", "<Up>", query_colorscheme_name, { desc = "Query the current colorscheme" })
vim.keymap.set("n", "<Down>", query_synced_colorscheme, { desc = "Query the synced colorscheme info" })

vim.keymap.set("n", "<Left>", undo_colorscheme_action, { desc = "Undo the colorscheme action" })
vim.keymap.set("n", "<Right>", redo_colorscheme_action, { desc = "Redo the colorscheme action" })

-- vim.keymap.set("n", "<leader>=", save_colorscheme_data, { desc = "Open favorite colorschemes" })
vim.keymap.set("n", "<leader>~", open_favorites, { desc = "Open favorite colorschemes" })
vim.keymap.set("n", "<leader>#", function() open_favorites{initial_mode="normal"} end, { desc = "Open favorite colorschemes" })
vim.keymap.set("n", "<leader>=", add_to_favorites, { desc = "Open favorite colorschemes" })
vim.keymap.set("n", "<leader>-", remove_from_favorites, { desc = "Open favorite colorschemes" })

-- startup

local colorscheme_data = get_colorscheme_data()

if colorscheme_data then
    current_colorscheme = ColorschemeState.from_colorscheme_data(colorscheme_data[JsonFields.LAST_COLORSCHEME])
    favorite_colorschemes = colorscheme_data[JsonFields.FAVORITES] or {}
else
    current_colorscheme = ColorschemeState.default()
    favorite_colorschemes = {}
end

ColorschemeAction.from_current():append_and_apply()

