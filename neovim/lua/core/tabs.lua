local function new_tab_right()
    for _ = 1, vim.v.count1 do
        vim.cmd.tabnew()
    end
end

local new_tab_right_opts = { desc = "Open a new tab" }

vim.keymap.set("n", "<leader><Tab>n", new_tab_right, new_tab_right_opts)
vim.keymap.set("n", "<leader><S-Tab>n", new_tab_right, new_tab_right_opts)

local function new_tab_left()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew | tabmove -1")
    end
end

local new_tab_left_opts = { desc = "Open a new tab to the left" }

vim.keymap.set("n", "<leader><Tab>N", new_tab_left, new_tab_left_opts)
vim.keymap.set("n", "<leader><S-Tab>N", new_tab_left, new_tab_left_opts)

vim.keymap.set("n", "<leader>}", "gt", { desc = "Next tab ", silent = true })

vim.keymap.set("n", "<leader>{", "gT", { desc = "Previous tab ", silent = true })

vim.keymap.set("n", "<leader><Tab>d", function()
    for _ = 1, vim.v.count1 do
        vim.cmd.tabclose()
    end
end, { desc = "Close tab" })

vim.keymap.set("n", "<leader><Tab>o", vim.cmd.tabonly, { desc = "Close all tabs except the current one" })

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
        vim.cmd.tabmove("+" .. count)
    else
        vim.notify("Cannot move tab +" .. count, vim.log.levels.ERROR)
    end
end, { desc = "Move the tab right" })

vim.keymap.set("n", "<leader><S-Left>", function()
    local count = vim.v.count1
    if current_tab_can_move(-count) then
        vim.cmd.tabmove(-count)
    else
        vim.notify("Cannot move tab -" .. count, vim.log.levels.ERROR)
    end
end, { desc = "Move the tab left" })

-- Tab switching

for i = 1, 20 do
    local command = "<cmd>tabnext " .. i .. "<CR>"

    local opts = { desc = "Go to tab " .. i }
    local navigation_key = nav_keys[i]
    vim.keymap.set("n", "<leader><Tab>" .. navigation_key, command, opts)
    vim.keymap.set("n", "<leader><S-Tab>" .. navigation_key, command, opts)
end
