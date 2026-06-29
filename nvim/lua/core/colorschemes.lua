--[[
--------------------------------------------------------
    Colorscheme functionality
--------------------------------------------------------
--]]

local ColorschemeMode = {
    DEFAULT = "default",
    MODIFIED_DAY = "modified_day",
    FESTIVE = "festive",
    CUSTOM = "custom",
}

setmetatable(ColorschemeMode, {
    __index = function(_, index)
        error("No such index: " .. index)
    end,
    __newindex = function()
        error("Colorscheme mode is immutable")
    end,
})

local daily_colorschemes = {
    "catppuccin-macchiato", -- Sunday
    "catppuccin-macchiato", -- Monday
    "tokyonight-moon", -- Tuesday
    "catppuccin-nvim", -- Wednesday
    "tokyonight-night", -- Thursday
    "tokyonight-night", -- Friday
    "tokyonight-night", -- Saturday
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

local JsonFields = setmetatable({
    LAST_COLORSCHEME = "last_colorscheme",
    FAVORITES = "favorites",
}, {
    __index = function(_, key)
        error("No such json field `" .. key .. "`")
    end,

    __newindex = function()
        error("Keys should not be added to this table")
    end,
})

local current_colorscheme_name = vim.g.colors_name

local current_colorscheme, favorite_colorschemes
local colorscheme_path = vim.fs.joinpath(vim.fn.stdpath("data"), "colorschemes.json")

local ColorschemeState = {}
ColorschemeState.__index = ColorschemeState

function ColorschemeState.default()
    return setmetatable(
        { colorscheme = daily_colorschemes[current_week_day], mode = ColorschemeMode.DEFAULT },
        ColorschemeState
    )
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

    vim.cmd.colorscheme(self.colorscheme)
end

function ColorschemeAction:append_and_apply()
    self:apply()
    self:append()
end

local function on_colorscheme_changed(event)
    vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})

    current_colorscheme_name = event.match
    vim.api.nvim_set_hl(0, UPDATION_HIGHLIGHT, { fg = "#5fafff" })
    vim.api.nvim_set_hl(0, QUERY_HIGHLIGHT, { fg = "#fcae1e" })

    if current_colorscheme_name == current_colorscheme.colorscheme then
        return
    end

    local picker = Snacks.picker.get()[1]

    if picker and picker.opts.source == "colorschemes" then
        return
    end

    current_colorscheme:switch(ColorschemeMode.CUSTOM)
    current_colorscheme.colorscheme = current_colorscheme_name

    ColorschemeAction.from_current():append()
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = on_colorscheme_changed,
})

---@param no_log any
local function save_colorscheme_data(no_log)
    local file = io.open(colorscheme_path, "w")

    if not file then
        return
    end

    file:write(vim.json.encode {
        [JsonFields.LAST_COLORSCHEME] = current_colorscheme,
        [JsonFields.FAVORITES] = favorite_colorschemes,
    })

    file:close()

    if no_log then
        return
    end

    Snacks.notify.info("Colorscheme data saved", { hl = { msg = UPDATION_HIGHLIGHT } })
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = save_colorscheme_data,
})

local function enable_modified_day_colorscheme(silent, delta)
    delta = delta or 0

    if current_colorscheme.mode == ColorschemeMode.MODIFIED_DAY then
        current_colorscheme.day = (current_colorscheme.day + delta - 1) % 7 + 1
    else
        current_colorscheme:switch(ColorschemeMode.MODIFIED_DAY)

        if current_colorscheme.mode == ColorschemeMode.DEFAULT then
            current_colorscheme.day = (current_week_day + delta - 1) % 7 + 1
        else
            current_colorscheme.day = current_week_day
        end
    end

    current_colorscheme.colorscheme = daily_colorschemes[current_colorscheme.day]
    ColorschemeAction.from_current():append_and_apply()

    if silent then
        return
    end

    vim.schedule(function()
        Snacks.notify.info(
            ("Displaying %s colorscheme for %s (day %d)"):format(
                current_colorscheme_name,
                days_of_week[current_colorscheme.day],
                current_colorscheme.day
            ),
            { hl = { msg = UPDATION_HIGHLIGHT } }
        )
    end)
end

local function enable_default_colorscheme(silent)
    update_date()

    current_colorscheme:switch(ColorschemeMode.DEFAULT)
    current_colorscheme.colorscheme = daily_colorschemes[current_week_day]

    ColorschemeAction.from_current():append_and_apply()

    if silent then
        return
    end

    vim.schedule(function()
        Snacks.notify.info(
            ("Displaying %s colorscheme for current day (%s, day %d)"):format(
                current_colorscheme_name,
                days_of_week[current_week_day],
                current_week_day
            ),
            { hl = { msg = UPDATION_HIGHLIGHT } }
        )
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
    elseif 6 <= current_month and current_month <= 8 then
        -- summer
        colorscheme = "sunset"
    else
        Snacks.notify.warn("Currently, there are no festive colorschemes")
        return
    end

    assert(type(colorscheme) == "string", "Expected a colorscheme")

    current_colorscheme:switch(ColorschemeMode.FESTIVE)
    current_colorscheme.colorscheme = colorscheme

    ColorschemeAction.from_current():append_and_apply()

    if silent then
        return
    end

    vim.schedule(function()
        Snacks.notify.info(
            ("Displaying %s colorscheme for month %d"):format(colorscheme, current_month),
            { hl = { msg = UPDATION_HIGHLIGHT } }
        )
    end)
end

local function query_colorscheme_name()
    Snacks.notify.info("Colorscheme in use: " .. current_colorscheme_name, { hl = { msg = QUERY_HIGHLIGHT } })
end

local function query_synced_colorscheme()
    local message = {}

    for key, value in pairs(current_colorscheme) do
        table.insert(message, ("%s: %s\n"):format(key, value))
    end

    Snacks.notify.info(message, { hl = { msg = QUERY_HIGHLIGHT } })
end

local function get_colorscheme_data()
    local file = io.open(colorscheme_path, "r")

    if not file then
        return ColorschemeState.default()
    end

    local ok, parsed_contents = pcall(vim.json.decode, file:read("*a"))

    if not ok then
        Snacks.notify.warn("Failed to decode contents of colorscheme file", vim.log.levels.WARN)
        vim.fn.getchar()
        os.exit(1)
    end

    return parsed_contents
end

-- favorites functionality

local function open_favorites(focus)
    local favorites_set = {}

    for _, colorscheme in ipairs(favorite_colorschemes) do
        favorites_set[colorscheme] = true
    end

    Snacks.picker.colorschemes {
        title = "Favorite Colorschemes",
        focus = focus or "list",
        transform = function(item)
            return favorites_set[item.text] or false
        end,
    }
end

local function add_to_favorites()
    for _, colorscheme in ipairs(favorite_colorschemes) do
        if current_colorscheme_name == colorscheme then
            Snacks.notify.warn("Colorscheme `" .. colorscheme .. "` is already in your favorites")
            return
        end
    end

    Snacks.notify.info(
        "Added colorscheme `" .. current_colorscheme_name .. "` to favorites",
        { hl_group = UPDATION_HIGHLIGHT }
    )
    table.insert(favorite_colorschemes, current_colorscheme_name)
end

local function remove_from_favorites()
    for i, colorscheme in ipairs(favorite_colorschemes) do
        if current_colorscheme_name == colorscheme then
            table.remove(favorite_colorschemes, i)
            Snacks.notify.info(
                "Removed colorscheme `" .. colorscheme .. "` from favorites",
                vim.log.levels.INFO,
                { hl = { msg = UPDATION_HIGHLIGHT } }
            )
            return
        end
    end

    Snacks.notify.warn("Colorscheme `" .. current_colorscheme_name .. "` is not in your favorites")
end

-- keymaps

vim.keymap.set("n", "<S-Left>", function()
    enable_modified_day_colorscheme(false, -vim.v.count1)
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<S-Right>", function()
    enable_modified_day_colorscheme(false, vim.v.count1)
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<leader>jn", enable_default_colorscheme, { desc = "Reset daily colorscheme" })
vim.keymap.set("n", "<leader>jf", enable_festive_colorscheme, { desc = "Synchronize the current colorscheme" })

vim.keymap.set("n", "<leader>jq", query_colorscheme_name, { desc = "Query the current colorscheme" })
vim.keymap.set("n", "<leader>jQ", query_synced_colorscheme, { desc = "Query the synced colorscheme info" })

vim.keymap.set("n", "<Left>", undo_colorscheme_action, { desc = "Undo the colorscheme action" })
vim.keymap.set("n", "<Right>", redo_colorscheme_action, { desc = "Redo the colorscheme action" })

vim.keymap.set("n", "<leader>js", save_colorscheme_data, { desc = "Save favorite colorschemes" })
vim.keymap.set("n", "<leader>jo", open_favorites, { desc = "Open favorite colorschemes (normal)" })
vim.keymap.set("n", "<leader>ja", add_to_favorites, { desc = "Add colorscheme to favorites" })
vim.keymap.set("n", "<leader>jd", remove_from_favorites, { desc = "Remove colorscheme from favorites" })

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
