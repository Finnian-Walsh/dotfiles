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

vim.diagnostic.config{
    virtual_text = true,
    update_in_insert = true,
}

local date = os.date("*t")
_G.is_december = date.month == 12

if is_december then
    local day = date.day

    if day <= 25 then
        _G.days_until_xmas = 25 - day
    end
end

local function printable_char_set()
    local char_set = {}

    for byte = 32, 126 do
        char_set[string.char(byte)] = true
    end

    return char_set
end

local function matched_keys(mode, regular_expression)
    return coroutine.wrap(function()
        local keymaps = vim.api.nvim_get_keymap(mode)

        for _, map in ipairs(keymaps) do
            local result = map.lhs:match(regular_expression)
            if result then
                coroutine.yield(result, map)
            end
        end
    end)
end

local function group_ascii_characters(chars)
    local uppercase_chars = {}
    local lowercase_chars = {}
    local numbers = {}
    local symbols = {}

    local zero_byte = string.byte'0'
    local nine_byte = string.byte'9'

    local upper_a_byte = string.byte'A'
    local upper_z_byte = string.byte'Z'

    local lower_a_byte = string.byte'a'
    local lower_z_byte = string.byte'z'

    -- lazy so no optimize

    for _, key in ipairs(chars) do
        local key_byte = string.byte(key)
        if key_byte < zero_byte then
            table.insert(symbols, key)
        elseif key_byte <= nine_byte then
            table.insert(numbers, key)
        elseif key_byte < upper_a_byte then
            table.insert(symbols, key)
        elseif key_byte <= upper_z_byte then
            table.insert(uppercase_chars, key)
        elseif key_byte < lower_a_byte then
            table.insert(symbols, key)
        elseif key_byte <= lower_z_byte then
            table.insert(lowercase_chars, key)
        else
            table.insert(symbols, key)
        end
    end

    return uppercase_chars, lowercase_chars, numbers, symbols
end

-- command for checking unused global leader keymaps:
vim.keymap.set("n", "<leader>K", function()
    local chars = printable_char_set()

    for key in matched_keys("n", "^" .. vim.g.mapleader .. "[%g ]") do
        chars[key] = nil
    end

    local unused_keys = {}

    for key, _ in pairs(chars) do
        table.insert(unused_keys, key)
    end

    table.sort(unused_keys)

    local unused_uppercase, unused_lowercase, unused_numbers, unused_symbols = group_ascii_characters(unused_keys)

    vim.api.nvim_echo({
        { "Unused uppercase: " },
        { table.concat(unused_uppercase, ", "), "DiagnosticInfo" },
        { "\n" },
        { "Unused lowercase: " },
        { table.concat(unused_lowercase, ", "), "DiagnosticInfo" },
        { "\n" },
        { "Unused numbers: " },
        { table.concat(unused_numbers, ", "), "DiagnosticInfo" },
        { "\n" },
        { "Unused symbols: " },
        { table.concat(unused_symbols, ", "), "DiagnosticInfo" },
    }, true, {})
end, { desc = "Check unused leader keymaps" })


local function set_global_keys_check(char)
    vim.keymap.set("n", "<leader>k" .. char, function()
        local mappings = {}

        for _, map in matched_keys("n", "^" .. vim.g.mapleader .. char) do
            table.insert(mappings, { string.format("<leader>%s: %s\n", map.lhs:sub(2), map.desc or "[no description]"), "DiagnosticInfo" })
        end

        if #mappings == 0 then
            mappings[1] = { string.format("<leader>%s is not mapped\n", char), "DiagnosticInfo" }
        end

        vim.api.nvim_echo(mappings, true, {})
    end, { desc = "Check normal mode leader keys for " .. char .. " key" })
end

for i = 32, 126 do
    set_global_keys_check(string.char(i))
end

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, desc = "Turn highlight off" })

-- vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit neovim" })

vim.keymap.set("n", "<leader>A", "<cmd>Alpha<CR>", { desc = "Toggle Alpha" })
vim.keymap.set("n", "<leader>nA", "<cmd>vs | wincmd l | Alpha<CR>", { desc = "Toggle Alpha in a new vertical split" })
vim.keymap.set("n", "<leader>NA", "<cmd>sp | wincmd j | Alpha<CR>", { desc = "Toggle Alpha in a new horizontal split" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason" })

--[[
--------------------------------------------------------
    Bufferline keymap
--------------------------------------------------------
]]

local function show_tabline()
    vim.o.showtabline = 2
end

local function hide_tabline()
    vim.o.showtabline = 0
end

local function toggle_bufferline()
    if vim.o.showtabline < 2 then
        show_tabline()
    else
        hide_tabline()
    end
end

vim.keymap.set("n", "<leader>B", toggle_bufferline, { noremap = true, desc = "Toggle bufferline" })

vim.api.nvim_create_user_command("ToggleBufferline", toggle_bufferline, { desc = "Toggle bufferline" })

--[[
--------------------------------------------------------
    Buffer navigation
--------------------------------------------------------
]]

local function repeat_cmd(cmd, count)
    for _ = 1, count do
        vim.cmd(cmd)
    end
end

local function find_listed_buffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted then
            return buf
        end
    end
end

-- previous buffer keymaps

local move_new_vert_split = "vs | wincmd l"
local move_new_horizontal_split = "sp | wincmd j"

vim.keymap.set("n", "<leader>[", function()
    if find_listed_buffer() then
        repeat_cmd("BufferLineCyclePrev", vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Previous buffer "})

vim.keymap.set("n", "<leader>n[", function()
    if find_listed_buffer() then
        vim.cmd(move_new_vert_split)
        repeat_cmd("BufferLineCyclePrev", vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Previous buffer "})

vim.keymap.set("n", "<leader>N[", function()
    if find_listed_buffer() then
        vim.cmd(move_new_horizontal_split)
        repeat_cmd("BufferLineCyclePrev", vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Previous buffer "})

-- next buffer keymaps

vim.keymap.set("n", "<leader>]", function()
    if find_listed_buffer() then
        repeat_cmd("BufferLineCycleNext", vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Next buffer " })

vim.keymap.set("n", "<leader>n]", function()
    if find_listed_buffer() then
        vim.cmd(move_new_vert_split)
        repeat_cmd("BufferLineCycleNext", vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Next buffer " })

vim.keymap.set("n", "<leader>N]", function()
    if find_listed_buffer() then
        vim.cmd(move_new_horizontal_split)
        repeat_cmd("BufferLineCycleNext", vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Next buffer " })


vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Open a new empty buffer" })

local discord_buffer, discord_win

local function close_discord_window()
    vim.api.nvim_win_close(discord_win, false)
end

local discord_keymap = "<leader>#"

vim.keymap.set("n",  discord_keymap, function()
    if discord_win and vim.api.nvim_win_is_valid(discord_win) then
        close_discord_window()
        return
    end

    local buf = discord_buffer
    local new_buffer = false

    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        new_buffer = true
        buf = vim.api.nvim_create_buf(false, true)
        discord_buffer = buf
    end

    local columns, lines = vim.o.columns, vim.o.lines

    local width = math.floor(columns * 0.8)
    local height = math.floor(lines * 0.8)

    local col = math.floor((columns - width) / 2)
    local row = math.floor((lines - height) / 2)

    discord_win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
    })

    if new_buffer then
        vim.fn.termopen("discordo", {
            on_exit = function()
                if vim.api.nvim_win_is_valid(discord_win) then
                    vim.api.nvim_win_close(discord_win, false)
                end

                if vim.api.nvim_buf_is_valid(discord_buffer) then
                    vim.api.nvim_buf_delete(discord_buffer, {})
                end

                discord_win, discord_buffer = nil, nil
            end
        })

        vim.keymap.set("t", "<S-Esc>", [[<C-\><C-n>]], { noremap = true })
        vim.keymap.set({"n", "t"}, "<Esc>", close_discord_window, { buffer = buf })
        vim.keymap.set("n", discord_keymap, close_discord_window, { buffer = buf })
    end

    vim.cmd("startinsert")
end, { desc = "Toggle floating discord window" })

--[[
--------------------------------------------------------
    Buffer deletion
--------------------------------------------------------
]]

vim.keymap.set("n", "<leader>bd", function()
    for _ = 1, vim.v.count1 do
        vim.api.nvim_buf_delete(0, {})
    end
end, { noremap = true, desc = "Close buffer"})

vim.keymap.set("n", "<leader>b!d", function()
    for _ = 1, vim.v.count1 do
        vim.api.nvim_buf_delete(0, { force = true })
    end
end, { noremap = true, desc = "Close buffer"})

local function delete_undisplayed_buffers(force)
    local displayed = {}

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        displayed[vim.api.nvim_win_get_buf(win)] = true
    end

    local opts = {force = force}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if not displayed[buf] then
            vim.api.nvim_buf_delete(buf, opts)
        end
    end
end

local function delete_other_buffers(force)
    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= current_win then
            vim.api.nvim_win_close(win, force)
        end
    end

    local opts = {force = force}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf then
            vim.api.nvim_buf_delete(buf, opts)
        end
    end

end

vim.keymap.set("n", "<leader>bo", delete_undisplayed_buffers, { noremap = true, desc = "Delete undisplayed buffers"})

vim.keymap.set("n", "<leader>b!o", function()
    delete_undisplayed_buffers(true)
end, { noremap = true, desc = "Force delete undisplayed buffers"})

vim.api.nvim_create_user_command("BufOnly", function(opts)
    delete_undisplayed_buffers(opts.bang)
end, { desc = "Delete undisplayed buffers", bang = true })

vim.keymap.set("n", "<leader>bO", delete_other_buffers, { desc = "Delete other buffers"})

vim.keymap.set("n", "<leader>b!O", function()
    delete_other_buffers(true)
end, { desc = "Force delete other buffers"})

vim.api.nvim_create_user_command("BufCurrentOnly", function(opts)
    delete_other_buffers(opts.bang)
end, { desc = "Delete all other windows and buffers", bang = true })

vim.keymap.set("n", "<leader>bD", "<cmd>bufdo bd<CR>", { noremap = true, desc = "Close all buffers"})
vim.keymap.set("n", "<leader>b!D", "<cmd>bufdo bd!<CR>", { noremap = true, desc = "Close all buffers"})

-- Buffer moving

vim.keymap.set("n", "<leader><Right>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("BufferLineMoveNext")
    end
end, { desc = "Move the buffer right" })

vim.keymap.set("n", "<leader><Left>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("BufferLineMovePrev")
    end
end, { desc = "Move the buffer left" })

--[[
--------------------------------------------------------
    Tab keymaps
--------------------------------------------------------
]]

vim.keymap.set("n", "<leader><Tab>n", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew")
    end
end, { noremap = true, desc = "Open a new tab" })

vim.keymap.set("n", "<leader><Tab>N", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew | tabmove -1")
    end
end, { noremap = true, desc = "Open a new tab to the left" })

vim.keymap.set("n", "<leader>}", "gt", { noremap = true, desc = "Next tab ", silent = true, })

vim.keymap.set("n", "<leader>{", "gT", { noremap = true, desc = "Previous tab ", silent = true, })

vim.keymap.set("n", "<leader><Tab>d", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabclose")
    end
end, { noremap = true, desc = "Close tab"})

vim.keymap.set("n", "<leader><Tab>o", "<cmd>tabonly<CR>", { noremap = true, desc = "Close all tabs except the current one"})

-- Tab movement

local function current_tab_can_move(count)
    local tabs = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local tab_position

    for i, tab in ipairs(tabs) do
        if tab == current_tab then
            tab_position = i
        end
    end

    assert(tab_position, "Current tab not found")

    local position = tab_position + count
    return position >= 1 and position <= #tabs
end

vim.keymap.set("n", "<leader><S-Right>", function()
    local count = vim.v.count1
    if current_tab_can_move(count) then
        vim.cmd("tabmove +" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab +" .. count, "ErrorMsg" }}, true, {})
    end
end, { desc = "Move the tab right" })

vim.keymap.set("n", "<leader><S-Left>", function()
    local count = vim.v.count1
    if current_tab_can_move(-count) then
        vim.cmd("tabmove -" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab -" .. count, "ErrorMsg" }}, true, {})
    end
end, { desc = "Move the tab left" })

-- Tab switching

_G.nav_keys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "!", "\"", "£", "$", "%", "^", "&", "*", "(", ")"
}

for i = 1, 20 do
    local command = "<cmd>tabnext " .. i .. "<CR>"
    local opts = { noremap = true, desc = "Go to tab " .. i}
    local navigation_key = nav_keys[i]
    vim.keymap.set("n", "<leader><Tab>" .. navigation_key, command, opts)
end

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
        if vim.api.nvim_win_get_buf(win) == buf
            and vim.api.nvim_win_get_config(win).relative ~= "" then
            return
        end
    end

    vim.schedule(function()
        vim.api.nvim_buf_delete(buf, { force = true })
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

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Open neo-tree" })
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


-- File type autocmds
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({"o"})
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        if is_december then
            vim.cmd("LetItSnow")
        end

        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format{ async = true }
        end, opts)

        vim.keymap.set("n", "<leader>gf", function()
            local file_changes = {{ "Open files have changes:", "ErrorMsg" }}

            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_get_option(buf, "modified") then
                    table.insert(file_changes, { "\n" .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."), "Normal" })
                end
            end

            if #file_changes > 1 then
                if #file_changes == 2 then
                    if vim.api.nvim_buf_get_option(0, "modified") then
                        file_changes[1][1] = "The current file has changes"
                        file_changes[2] = nil
                    else
                        file_changes[1][1] = "An open file has changes:"
                    end
                end

                vim.api.nvim_echo(file_changes, true, {})
                return
            end

            vim.fn.system{"cargo", "fmt"}
            vim.cmd("edit")
        end, opts)

        vim.keymap.set("n", "<leader>`", function() vim.cmd("e Cargo.toml") end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "norg",
    callback = function()
        vim.b.completion = false
    end
})
