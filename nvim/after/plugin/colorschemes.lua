--[[
--------------------------------------------------------
    Colorscheme functionality
--------------------------------------------------------
--]]

local COLORSCHEME = {
    Default = "default",
    ModifiedDay = "modified_day",
    Festive = "festive",
    Custom = "custom",
}

setmetatable(COLORSCHEME, {
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
    "catppuccin-macchiato", -- Friday
    "catppuccin-mocha", -- Saturday
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

local current_colorscheme = {}
local active_colorscheme_name = vim.g.colors_name

setmetatable(current_colorscheme, {
    __index = function(self, index)
        if index ~= "type" then
            error("`" .. index .. "` does not exist")
        end

        return self._type
    end,

    __newindex = function(self, index, value)
        if index ~= "type" then
            error("You cannot set `" .. index .. "`")
        end

        if self._type == value then
            return
        end

        for key, _ in pairs(self) do
            self[key] = nil
        end

        self._type = value
    end,
})

local colorscheme_path = vim.fn.stdpath("data") .. "/last_colorscheme.json"

local function on_colorscheme_changed(event)
    active_colorscheme_name = event.match
    vim.api.nvim_set_hl(0, UPDATION_HIGHLIGHT, { fg = "#5fafff" })
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

local function use_modified_day_colorscheme(silent)
    local colorscheme = daily_colorschemes[current_colorscheme.day]
    vim.cmd("colorscheme " .. colorscheme)

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Displaying %s colorscheme for %s (day %d)", colorscheme, days_of_week[current_colorscheme.day], current_colorscheme.day), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function use_default_colorscheme(silent)
    update_date()
    local colorscheme = daily_colorschemes[current_week_day]
    vim.cmd("colorscheme " .. colorscheme)

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Displaying %s colorscheme for current day (%s, day %d)", colorscheme, days_of_week[current_week_day], current_week_day), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function enable_default_colorscheme(silent)
    current_colorscheme.type = COLORSCHEME.Default
    use_default_colorscheme(silent)
end

local function enable_modified_day_colorscheme(silent, delta)
    delta = delta or 0

    if current_colorscheme.type == COLORSCHEME.ModifiedDay then
        current_colorscheme.day = (current_colorscheme.day + delta - 1) % 7 + 1
    else
        current_colorscheme.type = COLORSCHEME.ModifiedDay
        current_colorscheme.day = (current_day + delta - 1) % 7 + 1
    end

    use_modified_day_colorscheme(silent)
end

local function use_festive_colorscheme(silent)
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
    vim.cmd("colorscheme " .. colorscheme)

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Displaying %s colorscheme for month %s", colorscheme, current_month), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function enable_festive_colorscheme(silent)
    current_colorscheme.type = COLORSCHEME.Festive
    use_festive_colorscheme(silent)
end

local function use_custom_colorscheme()
    vim.cmd("colorscheme " .. current_colorscheme.colorscheme)
end

local function sync_custom_colorscheme(silent)
    current_colorscheme.type = COLORSCHEME.Custom
    current_colorscheme.colorscheme = active_colorscheme_name

    if silent then
        return
    end

    vim.api.nvim_echo({
        { "Syncing colorscheme " .. active_colorscheme_name, UPDATION_HIGHLIGHT },
    }, true, {})
end

local function get_last_colorscheme()
    local file = io.open(colorscheme_path, "r")

    if not file then
        return false
    end

    local ok, parsed_contents = pcall(vim.json.decode, file:read("*a"))

    if not ok then
        vim.api.nvim_echo({{"Failed to decode contents", "WarningMsg"}}, true, {})
        return false
    end

    return parsed_contents
end

vim.keymap.set("n", "<S-Left>", function()
    enable_modified_day_colorscheme(false, -vim.v.count1)
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<S-Right>", function()
    enable_modified_day_colorscheme(false, vim.v.count1)
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<S-Up>", enable_default_colorscheme, { desc = "Reset daily colorscheme" })

vim.keymap.set("n", "<M-S-Up>", enable_festive_colorscheme, { desc = "Reset daily colorscheme" })

vim.keymap.set("n", "<S-Down>", sync_custom_colorscheme, { desc = "Query colorscheme and day" })

current_colorscheme = get_last_colorscheme() or {
    type = COLORSCHEME.Default,
}

if current_colorscheme.type == COLORSCHEME.ModifiedDay then
    use_modified_day_colorscheme(true)
elseif current_colorscheme.type == COLORSCHEME.Festive then
    use_festive_colorscheme(true)
elseif current_colorscheme.type == COLORSCHEME.Custom then
    use_custom_colorscheme()
else
    use_default_colorscheme(true)
end

