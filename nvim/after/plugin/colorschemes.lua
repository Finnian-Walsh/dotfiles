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

local current_colorscheme_name = vim.g.colors_name

local current_colorscheme
local colorscheme_path = vim.fn.stdpath("data") .. "/last_colorscheme.json"

local ColorschemeState = {}
ColorschemeState.__index = ColorschemeState

function ColorschemeState.default()
    return setmetatable({ mode = COLORSCHEME_MODE.Default }, ColorschemeState)
end

function ColorschemeState.fetch_last_or_default()
    local file = io.open(colorscheme_path, "r")

    if not file then
        return ColorschemeState.default()
    end

    local ok, parsed_contents = pcall(vim.json.decode, file:read("*a"))

    if not ok then
        vim.api.nvim_echo({{"Failed to decode contents", "WarningMsg"}}, true, {})
        return ColorschemeState.default()
    end

    return setmetatable(parsed_contents, ColorschemeState)
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

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local file = io.open(colorscheme_path, "w")

        if not file then
            return
        end

        file:write(vim.json.encode(current_colorscheme))
        file:close()
    end,
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

local function sync_custom_colorscheme(silent)
    if silent then
        return
    end

    vim.api.nvim_echo({
        { "Syncing colorscheme " .. current_colorscheme_name, UPDATION_HIGHLIGHT },
    }, true, {})
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


current_colorscheme = ColorschemeState.fetch_last_or_default()
ColorschemeAction.from_current():append_and_apply()

