vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = ""

_G.response_key_codes = {
    affirmative = {
        [89] = true, -- Y
        [121] = true, -- y
    },
    negative = {
        [78] = true, -- N
        [110] = true, -- n
    },
    abortive = {
        [67] = true, -- C
        [99] = true, -- c
        [27] = true, -- Esc
    },
}

function _G.update_date()
    _G.current_date = os.date("*t")
    _G.current_month = current_date.month
    _G.current_day = current_date.day
    _G.current_week_day = current_date.wday

    if current_month == 12 then
        _G.days_until_xmas = 25 - current_day
    elseif current_month == 9 then
        _G.days_until_halloween = 31 - current_day
    end
end

update_date()

local VIRTUAL_DIAGNOSTIC_MODE = {
    VirtualText = 1,
    VirtualLines = 2,
    None = 3,
}

local virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.VirtualText
local virtual_diagnostics_enabled = true
local sign_diagnostics_enabled = true
local underline_diagnostics_enabled = true

local function set_diagnostic_config()
    local config = {
        signs = sign_diagnostics_enabled,
        underline = underline_diagnostics_enabled,
        update_in_insert = true,
        virtual_lines = false,
        virtual_text = false,
    }

    if virtual_diagnostics_enabled then
        if virtual_diagnostic_mode == VIRTUAL_DIAGNOSTIC_MODE.VirtualText then
            config.virtual_text = true
        elseif virtual_diagnostic_mode == VIRTUAL_DIAGNOSTIC_MODE.VirtualLines then
            config.virtual_lines = true
        end
    end

    vim.diagnostic.config(config)
end

set_diagnostic_config()

--[[
--------------------------------------------------------
    Line keymaps
--------------------------------------------------------
--]]

local gitsigns
local line_metadata = true

vim.keymap.set("n", "<leader>x", function()
    if not gitsigns then
        gitsigns = require("gitsigns")
    end

    if line_metadata then
        line_metadata = false

        local initial_opt_number = vim.api.nvim_win_get_option(0, "number")
        local initial_opt_relativenumber = vim.api.nvim_win_get_option(0, "relativenumber")

        vim.opt.number = false
        vim.opt.relativenumber = false

        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.api.nvim_win_set_option(0, "number", initial_opt_number)
            vim.api.nvim_win_set_option(0, "relativenumber", initial_opt_relativenumber)
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                vim.api.nvim_win_set_option(win, "number", false)
                vim.api.nvim_win_set_option(win, "relativenumber", false)
            end
        end

        virtual_diagnostics_enabled = false
        sign_diagnostics_enabled = false
        underline_diagnostics_enabled = false
        set_diagnostic_config()

        gitsigns.toggle_signs(false)
        disable_todo_signs()
    else
        line_metadata = true

        local initial_opt_number = vim.api.nvim_win_get_option(0, "number")
        local initial_opt_relativenumber = vim.api.nvim_win_get_option(0, "relativenumber")

        vim.opt.number = true
        vim.opt.relativenumber = true

        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.api.nvim_win_set_option(0, "number", initial_opt_number)
            vim.api.nvim_win_set_option(0, "relativenumber", initial_opt_relativenumber)
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                vim.api.nvim_win_set_option(win, "number", true)
                vim.api.nvim_win_set_option(win, "relativenumber", true)
            end
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, "ft") == "alpha" then
                vim.api.nvim_buf_set_option(buf, "number", false)
                vim.api.nvim_buf_set_option(buf, "relativenumber", false)
            end
        end

        virtual_diagnostics_enabled = true
        sign_diagnostics_enabled = true
        underline_diagnostics_enabled = true
        set_diagnostic_config()

        gitsigns.toggle_signs(true)
        reset_todo_signs()
    end
end, { desc = "Toggle line metadata" })

vim.keymap.set("n", "<leader>vl", function() -- lines
    virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.VirtualLines
    set_diagnostic_config()
end)

vim.keymap.set("n", "<leader>vi", function() -- inline
    virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.VirtualText
    set_diagnostic_config()
end)

vim.keymap.set("n", "<leader>vn", function() -- none
    virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.None
    set_diagnostic_config()
end)

--[[
--------------------------------------------------------
    Keymap usage checking
--------------------------------------------------------
--]]

local function printable_char_set()
    local char_set = {}

    for byte = 32, 126 do
        char_set[string.char(byte)] = true
    end

    return char_set
end

local function matched_keys(mode, pattern)
    return coroutine.wrap(function()
        local keymaps = vim.api.nvim_get_keymap(mode)

        for _, map in ipairs(keymaps) do
            local result = map.lhs:match(pattern)
            if result then
                coroutine.yield(result, map)
            end
        end
    end)
end

local function group_sorted_ascii_characters(chars)
    local uppercase_chars = {}
    local lowercase_chars = {}
    local numbers = {}
    local symbols = {}

    local groups = {
        { string.byte("0") - 1, symbols },
        { string.byte("9"), numbers },
        { string.byte("A") - 1, symbols },
        { string.byte("Z"), uppercase_chars },
        { string.byte("a") - 1, symbols },
        { string.byte("z"), lowercase_chars },
        { 126, symbols },
    }

    local index = 1
    local current_table = groups[index][2]

    for _, key in ipairs(chars) do
        local key_byte = string.byte(key)

        while key_byte > groups[index][1] do
            index = index + 1
            current_table = groups[index][2]
        end

        table.insert(current_table, key)
    end

    return uppercase_chars, lowercase_chars, numbers, symbols
end

-- command for checking unused global leader keymaps:
vim.keymap.set("n", "<leader>kk", function()
    local chars = printable_char_set()

    for key in matched_keys("n", "^" .. vim.g.mapleader .. "([%g ])") do
        chars[key] = nil
    end

    local unused_keys = {}

    for key, _ in pairs(chars) do
        table.insert(unused_keys, key)
    end

    table.sort(unused_keys)

    local unused_uppercase, unused_lowercase, unused_numbers, unused_symbols =
        group_sorted_ascii_characters(unused_keys)

    local echo_message = {}

    local edge_message = { "'" }
    local middle_message = { "', '" }

    local function add_to_message(t)
        if #t == 0 then
            return
        end

        table.insert(echo_message, edge_message)

        local i = 1
        local length = #t
        while i < length do
            table.insert(echo_message, { t[i], "DiagnosticInfo" })
            table.insert(echo_message, middle_message)
            i = i + 1
        end

        table.insert(echo_message, { t[i], "DiagnosticInfo" })
        table.insert(echo_message, edge_message)
    end

    table.insert(echo_message, { "Unused uppercase: " })
    add_to_message(unused_uppercase)

    table.insert(echo_message, { "\nUnused lowercase: " })
    add_to_message(unused_lowercase)

    table.insert(echo_message, { "\nUnused numbers: " })
    add_to_message(unused_numbers)

    table.insert(echo_message, { "\nUnused symbols: " })
    add_to_message(unused_symbols)

    vim.notify(echo_message)
end, { desc = "Check unused leader keymaps" })

local function set_global_keys_check(char)
    vim.keymap.set("n", "<leader>K" .. char, function()
        local mappings = {}

        local special_cases = {
            ["["] = "\\[",
            ["-"] = "\\-",
            ["^"] = "\\^",
        }

        local special_match = special_cases[char]

        if special_match then
            char = special_match
        end

        for _, map in matched_keys("n", "^" .. vim.g.mapleader .. "[" .. char .. "]") do
            table.insert(mappings, {
                string.format("<leader>%s: %s\n", map.lhs:sub(2), map.desc or "[no description]"),
                "DiagnosticInfo",
            })
        end

        if #mappings == 0 then
            mappings[1] = { string.format("<leader>%s is not mapped\n", char), "DiagnosticInfo" }
        end

        vim.notify(mappings)
    end, { desc = "Check normal mode leader keys for " .. char .. " key" })
end

for i = 32, 126 do
    set_global_keys_check(string.char(i))
end

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, desc = "Turn highlight off" })

--[[
--------------------------------------------------------
    Plugin screen keymaps
--------------------------------------------------------
--]]

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason" })


-- Automatic empty buffer deletion

local function auto_buffer_delete(buf)
    if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].filetype ~= "" then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines > 1 or lines[1] ~= "" then
        return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf and vim.api.nvim_win_get_config(win).relative ~= "" then
            return
        end
    end

    vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end)
end

vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(args)
        auto_buffer_delete(args.buf)
    end,
})

-- Automatic tabline updation

local function schedule_tabline_redraw()
    vim.schedule(function()
        vim.cmd("redrawtabline")
    end)
end

vim.api.nvim_create_autocmd("BufLeave", {
    callback = schedule_tabline_redraw,
})

-- Miscellaneous keymaps

vim.keymap.set("n", "<leader>m", function()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
        vim.treesitter.stop()
    else
        vim.cmd("syntax enable")
        vim.treesitter.start()
    end
end, { noremap = true, desc = "Toggle Linus syntax highlighting" })

vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>", { noremap = true, desc = "Move to window left" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { noremap = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>", { noremap = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>", { noremap = true, desc = "Move to window right" })
vim.keymap.set("n", "<C-`>", "<cmd>wincmd =<CR>", { noremap = true, desc = "Equalize windows" })

vim.keymap.set("n", "<leader>l", function()
    vim.lsp.buf.format {
        async = true,
    }
end)

-- File type autocmds
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove { "o" }
    end,
})

local function assert_files_written()
    local file_changes = { { "Open files have changes:", "ErrorMsg" } }

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, "modified") then
            table.insert(file_changes, { "\n" .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."), "Normal" })
        end
    end

    local changes = #file_changes > 1

    if changes then
        if #file_changes == 2 then
            if vim.api.nvim_buf_get_option(0, "modified") then
                file_changes[1][1] = "The current file has changes"
                file_changes[2] = nil
            else
                file_changes[1][1] = "An open file has changes:"
            end
        end

        vim.notify(file_changes)
    end

    return not changes
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        if current_month == 12 then
            vim.cmd("LetItSnow")
        end

        vim.keymap.set("n", "<leader>dn", function()
            local args = { "debuggables" }
            local input = vim.fn.input("Program arguments: ")

            for arg in input:gmatch("%S+") do
                table.insert(args, arg)
            end

            vim.cmd.RustLsp(args)
        end, { desc = "Start a new debugging session" })

        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                vim.fn.system { "cargo", "fmt" }
                vim.cmd("edit")
            end
        end, opts)

        vim.keymap.set("n", "<leader>`", function()
            vim.cmd("e Cargo.toml")
        end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                vim.fn.system { "stylua", "." }
                vim.cmd("edit")
            end
        end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>gf", function()
            vim.notify("Not yet implemented", vim.log.levels.WARN)
        end, opts)
    end,
})
