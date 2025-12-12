--[[
--------------------------------------------------------
    Colorscheme functionality
--------------------------------------------------------
--]]

vim.keymap.set("n", "<leader>Cc", "<cmd>colorscheme catppuccin<CR>", { desc = "Set colorscheme to catppuccin" })
vim.keymap.set("n", "<leader>Cg", "<cmd>colorscheme gruvbox<CR>", { desc = "Set colorscheme to gruvbox" })
vim.keymap.set("n", "<leader>Ch", "<cmd>colorscheme habamax<CR>", { desc = "Set colorscheme to habamax" })

vim.keymap.set("n", "<leader>Cts", "<cmd>colorscheme tokyonight-storm<CR>", { desc = "Set colorscheme to tokyonight-storm" })
vim.keymap.set("n", "<leader>Ctn", "<cmd>colorscheme tokyonight-night<CR>", { desc = "Set colorscheme to tokyonight-night" })
vim.keymap.set("n", "<leader>Ctm", "<cmd>colorscheme tokyonight-moon<CR>", { desc = "Set colorscheme to tokyonight-moon" })
vim.keymap.set("n", "<leader>Ctd", "<cmd>colorscheme tokyonight-day<CR>", { desc = "Set colorscheme to tokyonight-day" })

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

