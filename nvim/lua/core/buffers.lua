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

local move_new_vert_split = "vs | wincmd l"
local move_new_horizontal_split = "sp | wincmd j"

-- previous buffer keymaps

vim.keymap.set("n", "<leader>[", function()
    if find_listed_buffer() then
        repeat_cmd("BufferLineCyclePrev", vim.v.count1)
    else
        vim.notify("There are no buffers", vim.log.levels.ERROR)
    end
end, { noremap = true, desc = "Previous buffer " })

vim.keymap.set("n", "<leader>n[", function()
    if find_listed_buffer() then
        vim.cmd(move_new_vert_split)
        repeat_cmd("BufferLineCyclePrev", vim.v.count1)
    else
        vim.notify("There are no buffers", vim.log.levels.ERROR)
    end
end, { noremap = true, desc = "Previous buffer " })

vim.keymap.set("n", "<leader>N[", function()
    if find_listed_buffer() then
        vim.cmd(move_new_horizontal_split)
        repeat_cmd("BufferLineCyclePrev", vim.v.count1)
    else
        vim.notify("There are no buffers", vim.log.levels.ERROR)
    end
end, { noremap = true, desc = "Previous buffer " })

-- next buffer keymaps

vim.keymap.set("n", "<leader>]", function()
    if find_listed_buffer() then
        repeat_cmd("BufferLineCycleNext", vim.v.count1)
    else
        vim.notify("There are no buffers", vim.log.levels.ERROR)
    end
end, { noremap = true, desc = "Next buffer " })

vim.keymap.set("n", "<leader>n]", function()
    if find_listed_buffer() then
        vim.cmd(move_new_vert_split)
        repeat_cmd("BufferLineCycleNext", vim.v.count1)
    else
        vim.notify("There are no buffers", vim.log.levels.ERROR)
    end
end, { noremap = true, desc = "Next buffer " })

vim.keymap.set("n", "<leader>N]", function()
    if find_listed_buffer() then
        vim.cmd(move_new_horizontal_split)
        repeat_cmd("BufferLineCycleNext", vim.v.count1)
    else
        vim.notify("There are no buffers", vim.log.levels.ERROR)
    end
end, { noremap = true, desc = "Next buffer " })

vim.keymap.set("n", "<leader>bn", vim.cmd.enew, { desc = "Open a new empty buffer" })

local discord_buffer, discord_win

local function close_discord_window()
    vim.api.nvim_win_close(discord_win, false)
end

local discord_keymap = "<leader>@"

vim.keymap.set("n", discord_keymap, function()
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
            end,
        })

        vim.keymap.set("t", "<S-Esc>", [[<C-\><C-n>]], { noremap = true })
        vim.keymap.set({ "n", "t" }, "<Esc>", close_discord_window, { buffer = buf })
        vim.keymap.set("n", discord_keymap, close_discord_window, { buffer = buf })
    end

    vim.cmd.startinsert()
end, { desc = "Toggle floating discord window" })

--[[
--------------------------------------------------------
    Buffer deletion
--------------------------------------------------------
]]

local function wipe_buffer(buf)
    vim.cmd("confirm bwipeout " .. buf)
end

local function delete_undisplayed_buffers()
    local displayed = {}

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        displayed[vim.api.nvim_win_get_buf(win)] = true
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if not displayed[buf] then
            wipe_buffer(buf)
        end
    end
end

local function delete_other_buffers()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= current_win then
            vim.api.nvim_win_close(win, {})
        end
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf then
            wipe_buffer(buf)
        end
    end
end

vim.keymap.set("n", "<leader>bo", delete_undisplayed_buffers, { noremap = true, desc = "Delete undisplayed buffers" })
vim.api.nvim_create_user_command(
    "BufOnly",
    delete_undisplayed_buffers,
    { desc = "Delete undisplayed buffers", bang = true }
)

vim.keymap.set("n", "<leader>bO", delete_other_buffers, { desc = "Delete other buffers" })
vim.api.nvim_create_user_command(
    "BufCurrentOnly",
    delete_other_buffers,
    { desc = "Delete all other windows and buffers", bang = true }
)

vim.keymap.set("n", "<leader>bd", function()
    wipe_buffer("")
end, { noremap = true, desc = "Delete current buffer" })

vim.keymap.set("n", "<leader>bD", function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        wipe_buffer(bufnr)
    end
end, { noremap = true, desc = "Delete all buffers" })

-- Buffer moving

vim.keymap.set("n", "<leader><Right>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd.BufferLineMoveNext()
    end
end, { desc = "Move the buffer right" })

vim.keymap.set("n", "<leader><Left>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd.BufferLineMovePrev()
    end
end, { desc = "Move the buffer left" })
