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

vim.keymap.set("n", "<leader>}", "gt", { noremap = true, desc = "Next tab ", silent = true })

vim.keymap.set("n", "<leader>{", "gT", { noremap = true, desc = "Previous tab ", silent = true })

vim.keymap.set("n", "<leader><Tab>d", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabclose")
    end
end, { noremap = true, desc = "Close tab" })

vim.keymap.set(
    "n",
    "<leader><Tab>o",
    "<cmd>tabonly<CR>",
    { noremap = true, desc = "Close all tabs except the current one" }
)

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
        vim.notify("Cannot move tab +" .. count, vim.log.levels.ERROR)
    end
end, { desc = "Move the tab right" })

vim.keymap.set("n", "<leader><S-Left>", function()
    local count = vim.v.count1
    if current_tab_can_move(-count) then
        vim.cmd("tabmove -" .. count)
    else
        vim.notify("Cannot move tab -" .. count, vim.log.levels.ERROR)
    end
end, { desc = "Move the tab left" })

-- Tab switching

-- stylua: ignore
_G.nav_keys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "!", "\"", "£", "$", "%", "^", "&", "*", "(", ")"
}

for i = 1, 20 do
    local command = "<cmd>tabnext " .. i .. "<CR>"
    local opts = { noremap = true, desc = "Go to tab " .. i }
    local navigation_key = nav_keys[i]
    vim.keymap.set("n", "<leader><Tab>" .. navigation_key, command, opts)
end
