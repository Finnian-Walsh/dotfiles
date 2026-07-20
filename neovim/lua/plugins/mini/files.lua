local show_hidden_files = false

local mini_actions = {
    new_left = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd.vsplit(path)
    end,

    new_below = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd("split | wincmd j")
        vim.cmd.edit(path)
    end,

    new_above = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd.split(path)
    end,

    new_right = function()
        local path = MiniFiles.get_fs_entry().path
        MiniFiles.close()
        vim.cmd("vs | wincmd l")
        vim.cmd.edit(path)
    end,
}

return {
    plugins = {
        "https://github.com/nvim-mini/mini.files",
    },

    lazy = true,

    opts = {
        ["mini.files"] = {
            content = {
                filter = function(file)
                    return show_hidden_files or not vim.startswith(file.name, ".")
                end,
            },
        },
    },

    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "minifiles",
            callback = function(event)
                local buf = event.buf
                vim.b[buf].completion = false

                vim.keymap.set("n", "<leader>.", function()
                    show_hidden_files = not show_hidden_files
                    local state = assert(MiniFiles.get_explorer_state(), "Expected state to exist in mini.files buffer")
                    MiniFiles.close()
                    MiniFiles.open(state.anchor)
                end, { desc = "Toggle hidden files", buffer = buf })

                vim.keymap.set("n", "<leader>r", function()
                    local state = assert(MiniFiles.get_explorer_state(), "Expected state to exist in mini.files buffer")
                    MiniFiles.close()
                    MiniFiles.open(state.anchor)
                end, { desc = "Refresh mini.files", buffer = buf })

                vim.keymap.set(
                    "n",
                    "<C-h>",
                    mini_actions.new_left,
                    { desc = "Open in a new window left", buffer = buf }
                )
                vim.keymap.set(
                    "n",
                    "<C-j>",
                    mini_actions.new_below,
                    { desc = "Open in a new window below", buffer = buf }
                )
                vim.keymap.set(
                    "n",
                    "<C-k>",
                    mini_actions.new_above,
                    { desc = "Open in a new window above", buffer = buf }
                )
                vim.keymap.set(
                    "n",
                    "<C-l>",
                    mini_actions.new_right,
                    { desc = "Open in a new window right", buffer = buf }
                )
            end,
        })
    end,

    keys = {
        {
            "n",
            "<leader>t",
            function()
                print("evaluating")
                return function()
                    if vim.bo.filetype == "oil" then
                        MiniFiles.open(vim.api.nvim_buf_get_name(0):gsub("^oil://", ""))
                    else
                        local buf_name = vim.api.nvim_buf_get_name(0)

                        if vim.uv.fs_stat(buf_name) then
                            MiniFiles.open(buf_name)
                        else
                            -- highly likely that the buffer open references a file since directories are delegated to oil,
                            -- which are handled separately, so parent_dir variable is ok
                            local parent_dir = vim.fs.dirname(buf_name)

                            if vim.uv.fs_stat(parent_dir) then
                                MiniFiles.open(parent_dir)
                            else
                                MiniFiles.open()
                            end
                        end
                    end
                end
            end,
            { desc = "Mini files" },
        },

        {
            "n",
            "<leader>T",
            function()
                return MiniFiles.open
            end,
            { desc = "Mini files" },
        },
    },
}
