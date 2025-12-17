--[[
--------------------------------------------------------
    Colorscheme functionality
--------------------------------------------------------
--]]

vim.keymap.set("n", "<leader>cc", "<cmd>colorscheme catppuccin<CR>", { desc = "Set colorscheme to catppuccin" })
vim.keymap.set("n", "<leader>cg", "<cmd>colorscheme gruvbox<CR>", { desc = "Set colorscheme to gruvbox" })
vim.keymap.set("n", "<leader>ch", "<cmd>colorscheme habamax<CR>", { desc = "Set colorscheme to habamax" })

vim.keymap.set("n", "<leader>cts", "<cmd>colorscheme tokyonight-storm<CR>", { desc = "Set colorscheme to tokyonight-storm" })
vim.keymap.set("n", "<leader>ctn", "<cmd>colorscheme tokyonight-night<CR>", { desc = "Set colorscheme to tokyonight-night" })
vim.keymap.set("n", "<leader>ctm", "<cmd>colorscheme tokyonight-moon<CR>", { desc = "Set colorscheme to tokyonight-moon" })
vim.keymap.set("n", "<leader>ctd", "<cmd>colorscheme tokyonight-day<CR>", { desc = "Set colorscheme to tokyonight-day" })

local daily_colorschemes = {
    "catppuccin-mocha", -- Sunday
    "tokyonight", -- Monday
    "habamax", -- Tuesday
    "terafox", -- Wednesday
    "evergarden-spring", -- Thursday
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
local QUERY_HIGHLIGHT = "ColorschemeQuery"

local current_colorscheme, current_colorscheme_is_festive

local festive_colorscheme_file_path = vim.fn.stdpath("data") .. "/festive_colorscheme"

local function set_colorscheme_updation_hl(event)
    current_colorscheme = event.match
    vim.api.nvim_set_hl(0, UPDATION_HIGHLIGHT, { fg = "#5fafff" })
    vim.api.nvim_set_hl(0, QUERY_HIGHLIGHT, { fg = "#0ab4cf" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_colorscheme_updation_hl,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local file = io.open(festive_colorscheme_file_path, "w")

        if not file then
            return
        end

        file:write(vim.fn.json_encode(current_colorscheme_is_festive))
        file:close()
    end
})

local offset = 0

local function update_colorscheme_with_offset(silent)
    update_date()
    local target_day = (current_week_day + offset - 1) % 7 + 1

    local colorscheme = daily_colorschemes[target_day]
    vim.cmd("colorscheme " .. colorscheme)

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Displaying %s colorscheme for %s (day %d)", colorscheme, days_of_week[target_day], target_day), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function reset_colorscheme(silent)
    update_date()
    offset = 0
    local colorscheme = daily_colorschemes[current_week_day]
    vim.cmd("colorscheme " .. colorscheme)

    if silent then
        return
    end

    vim.schedule(function()
        vim.api.nvim_echo({
            { string.format("Reset: displaying %s colorscheme for %s (day %d)", colorscheme, days_of_week[current_week_day], current_week_day), UPDATION_HIGHLIGHT },
        }, true, {})
    end)
end

local function enable_festive_colorscheme()
    if current_month == 12 then
        -- christmas
        vim.cmd("colorscheme christmas")
    elseif current_month == 10 then
        -- halloween
        vim.cmd("colorscheme nightfall")
    else
        vim.api.nvim_echo({{"Currently, there are no festive colorschemes", "WarningMsg"}}, true, {})
        return false
    end

    return true
end

local function colorscheme_is_festive()
    local file = io.open(festive_colorscheme_file_path, "r")

    if not file then
        return false
    end

    local ok, parsed_contents = pcall(vim.fn.json_decode, file:read("*a"))

    if not ok then
        vim.api.nvim_echo({{"Failed to decode contents", "WarningMsg"}}, true, {})
        return false
    end

    return parsed_contents
end

local function toggle_festive_colorscheme()
    if current_colorscheme_is_festive then
        update_colorscheme_with_offset(true)
        current_colorscheme_is_festive = false
    else
        if enable_festive_colorscheme() then
            current_colorscheme_is_festive = true
        end
    end
end

local function query_colorscheme()
    vim.api.nvim_echo({
        { "Current colorscheme: " .. current_colorscheme, QUERY_HIGHLIGHT },
    }, true, {})
end

vim.keymap.set("n", "<Left>", function()
    offset = (offset - 1) % 7
    update_colorscheme_with_offset()
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<Right>", function()
    offset = (offset + 1) % 7
    update_colorscheme_with_offset()
end, { desc = "Cycle through daily colorschemes" })

vim.keymap.set("n", "<Up>", reset_colorscheme, { desc = "Reset daily colorscheme" })

vim.keymap.set("n", "<S-Up>", toggle_festive_colorscheme, { desc = "Reset daily colorscheme" })

vim.keymap.set("n", "<Down>", query_colorscheme, { desc = "Query colorscheme and day" })

if colorscheme_is_festive() then
    current_colorscheme_is_festive = true
    enable_festive_colorscheme()
else
    current_colorscheme_is_festive = false
    reset_colorscheme(true)
end
