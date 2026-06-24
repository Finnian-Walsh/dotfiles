local expect = MiniTest.expect
local new_set = MiniTest.new_set

local child = MiniTest.new_child_neovim()
child.start()

local function inspect_keys(keys)
    local str = ""
    local keycode = child.lua(([[
    return vim.keycode("%s")
    ]]):format(keys))
end

local function trigger_keymap(keys)
    child.lua(([[
    vim.api.nvim_feedkeys(vim.keycode("%s"), "m", false)
    ]]):format(keys))
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

        post_case = function()
            child.stop()
        end,
    },
}

T["options"] = new_set()

T["options"]["wincmds"] = new_set {
    parametrize = {
        { "vs", "<C-l>", "<C-h>" },
        { "sp", "<C-j>", "<C-k>" },
    },
}

T["options"]["wincmds"]["mappings"] = function(split_command, first_key, second_key)
    local initial_win = child.api.nvim_get_current_win()

    child.cmd(split_command)
    local new_win = child.api.nvim_get_current_win()

    trigger_keymap(first_key)
    expect.equality(initial_win, child.api.nvim_get_current_win())

    trigger_keymap(second_key)
    expect.equality(new_win, child.api.nvim_get_current_win())
end

T["tabs"] = function()
    local initial_tab = vim.api.nvim_get_current_tabpage()
    inspect_keys("<leader><Tab>n")
    trigger_keymap("<leader><Tab>n")

    error(vim.inspect(vim.api.nvim_list_tabpages()))

    expect.no_equality(initial_tab, vim.api.nvim_get_current_tabpage())
end

return T
