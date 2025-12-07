vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#00BFA5", bg = "NONE", bold = true })
vim.opt.showtabline = 0

local date, week_day

local function update_date()
    date = os.date("*t")
    week_day = date.wday
end

update_date()

local daily_colorschemes = {
    "catppuccin", -- Sunday
    "tokyonight", -- Monday
    "habamax", -- Tuesday
    "elflord", -- Wednesday
    "evening", -- Thursday
    "catppuccin-macchiato", -- Friday
    "catppuccin", -- Saturday
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

local function set_colorscheme_updation_hl()
    vim.api.nvim_set_hl(0, UPDATION_HIGHLIGHT, { fg = "#5fafff" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_colorscheme_updation_hl,
})

local offset = 0

local function update_colorscheme_with_offset()
    update_date()
    local target_day = (week_day + offset - 1) % 7 + 1

    local colorscheme = daily_colorschemes[target_day]
    vim.cmd("colorscheme " .. colorscheme)

    vim.schedule(function()
        vim.api.nvim_echo({{string.format("Displaying colorscheme for %s (%s)", days_of_week[target_day], colorscheme), UPDATION_HIGHLIGHT}}, true, {})
    end)
end

local function reset_colorscheme(log)
    update_date()
    offset = 0
    local colorscheme = daily_colorschemes[week_day]
    vim.cmd("colorscheme " .. colorscheme)

    if log then
        vim.schedule(function()
            vim.api.nvim_echo({{string.format("Reset: displaying colorscheme for %s (%s)", days_of_week[week_day], colorscheme), UPDATION_HIGHLIGHT}}, true, {})
        end)
    end
end

vim.keymap.set("n", "<Left>", function()
    offset = (offset - 1) % 7
    update_colorscheme_with_offset()
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<Right>", function()
    offset = (offset + 1) % 7
    update_colorscheme_with_offset()
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<Up>", function() reset_colorscheme(true) end, { desc = "Reset daily colorscheme" })
vim.keymap.set("n", "<Down>", function() reset_colorscheme(true) end, { desc = "Reset daily colorscheme" })

reset_colorscheme()
