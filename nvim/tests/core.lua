local expect = MiniTest.expect
local new_set = MiniTest.new_set

local child = MiniTest.new_child_neovim()
child.start()

--- Warning: if you put some unescaped escape keys then it will fail; you must escape the escape keys and this function does not do it because fully implementing it is just unnecessary overhead + code while partially implementing it is even more ass because of edge cases
local function trigger_keymap(keys)
    child.lua(([[
    vim.api.nvim_feedkeys(vim.keycode("%s"), "m", false)
    ]]):format(keys))
end

local function trigger_command(cmd)
    child.cmd(cmd)
end

T = new_set {
    hooks = {
        pre_case = function()
            child.restart {
                "--cmd",
                "set rtp^=" .. vim.uv.cwd(),
                "-u",
                vim.uv.cwd() .. "/init.lua",
            }
        end,

        post_case = child.stop,
    },
}

T["options"] = new_set()

T["options"]["nav_keys"] = function()
    expect.equality(#child.lua([[return nav_keys]]), 20)
end

T["options"]["terminal"] = function()
    trigger_command("terminal")
    trigger_keymap("<C-q>")
    expect.no_equality(vim.bo.buftype, "terminal")
end

T["options"]["restart"] = function()
    local file_name = "test.txt"
    local pattern = file_name .. "$"
    child.cmd("edit " .. file_name)
    expect.equality(child.api.nvim_buf_get_name(0):match(pattern), file_name)
    trigger_keymap("<leader>Q")

    expect.no_equality(child.api.nvim_buf_get_name(0):match(pattern), file_name)
end

T["options"]["wincmds"] = new_set {
    parametrize = {
        { "vs", "<C-l>", "<C-h>" },
        { "sp", "<C-j>", "<C-k>" },
    },
}

T["options"]["wincmds"]["normal"] = function(split_command, first_key, second_key)
    local initial_win = child.api.nvim_get_current_win()

    child.cmd(split_command)
    local new_win = child.api.nvim_get_current_win()

    trigger_keymap(first_key)
    expect.equality(initial_win, child.api.nvim_get_current_win())

    trigger_keymap(second_key)
    expect.equality(new_win, child.api.nvim_get_current_win())
end

T["options"]["wincmds"]["terminal"] = function(split_command, first_key, second_key)
    vim.cmd.terminal()
    local initial_win = child.api.nvim_get_current_win()

    child.cmd(split_command)
    local new_win = child.api.nvim_get_current_win()

    trigger_keymap(first_key)
    expect.equality(initial_win, child.api.nvim_get_current_win())

    trigger_keymap(second_key)
    expect.equality(new_win, child.api.nvim_get_current_win())
end

T["tabs"] = new_set()

T["tabs"]["forward creation and navigation"] = function()
    local tabs = {}
    local tab_set = {}

    tabs[1] = child.api.nvim_get_current_tabpage()

    for i = 2, 20 do
        trigger_keymap("<leader><Tab>n")
        local new_tabpage = child.api.nvim_get_current_tabpage()
        expect.equality(tab_set[new_tabpage], nil)
        tabs[i] = new_tabpage
        tab_set[new_tabpage] = true
    end

    local nav_keys = child.lua([[return nav_keys]])

    for i = 1, 20 do
        local keycode = ("<leader><Tab>" .. nav_keys[i]):gsub('"', '\\"')
        trigger_keymap(keycode)
        expect.equality(child.api.nvim_get_current_tabpage(), tabs[i])
    end
end

T["tabs"]["backward creation and navigation"] = function()
    local tabs = { child.api.nvim_get_current_tabpage() }
    local tab_set = {}

    for i = 2, 20 do
        trigger_keymap("<leader><Tab>N")
        local new_tabpage = child.api.nvim_get_current_tabpage()
        expect.equality(tab_set[new_tabpage], nil)
        tabs[i] = new_tabpage
        tab_set[new_tabpage] = true
    end

    local nav_keys = child.lua([[return nav_keys]])

    for i = 1, 19 do
        local keycode = ("<leader><Tab>" .. nav_keys[i]):gsub('"', '\\"')
        trigger_keymap(keycode)
        expect.equality(child.api.nvim_get_current_tabpage(), tabs[21 - i])
    end
end

T["tabs"]["incrementing and decrementing"] = function()
    local tabs = { vim.api.nvim_get_current_tabpage() }

    for i = 2, 20 do
        trigger_keymap("<leader><Tab>n")
        local new_tabpage = vim.api.nvim_get_current_tabpage()
        tabs[i] = new_tabpage
    end

    for i = 19, 1, -1 do
        trigger_keymap("<leader>{")
        expect.equality(vim.api.nvim_get_current_tabpage(), tabs[i])
    end

    for i = 2, 20 do
        trigger_keymap("<leader>}")
        expect.equality(vim.api.nvim_get_current_tabpage(), tabs[i])
    end
end

return T
