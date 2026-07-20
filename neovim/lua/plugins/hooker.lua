local hooker

local function setup()
    hooker = require("hooker")

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "hooker",
        callback = function(event)
            vim.b[event.buf].completion = false
        end,
    })

    vim.api.nvim_create_user_command("ChangeHookerDirectory", function(args)
        hooker.options.target_directory = args.args
    end, { nargs = 1 })
end

local function make_bound_creator(i)
    local warning_message = "There is no item " .. i .. " in the hooker list"
    return function(f_normal, f_with_explorer)
        f_with_explorer = f_with_explorer or f_normal
        return function()
            if hooker.length() < i then
                vim.notify(warning_message, vim.log.levels.WARN)
                return
            end

            if vim.bo.filetype == "snacks_file_explorer" and Snacks.picker.get()[1].opts.source == "explorer" then
                f_with_explorer()
            else
                f_normal()
            end
        end
    end
end

local keys = {
    {
        "n",
        "<leader>a",
        function()
            return function()
                if vim.bo.filetype == "snacks_picker_list" then
                    -- TODO: implement this
                    error("Not yet implemented")
                else
                    hooker.add_file()
                end
            end
        end,
        { desc = "Add current file to hooker" },
    },
    {
        "n",
        "<leader>H",
        function()
            return hooker.menu
        end,
        { desc = "Open hooker menu" },
    },
}

for i = 1, 20 do
    local navigation_key = nav_keys[i]
    local bound_creator = make_bound_creator(i)

    local function select_i()
        hooker.select(i)
    end

    keys[#keys + 1] = {
        "n",
        "<leader>" .. navigation_key,
        function()
            return bound_creator(select_i)
        end,
        { desc = "Hooker " .. i },
    }

    keys[#keys + 1] = {
        "n",
        "<leader>n" .. navigation_key,
        function()
            return bound_creator(function()
                vim.cmd("vs | wincmd l")
                hooker.select(i)
            end, select_i)
        end,
        { desc = ("Hooker %d (vertical split)"):format(i) },
    }

    keys[#keys + 1] = {
        "n",
        "<leader>N" .. navigation_key,
        function()
            return bound_creator(function()
                vim.cmd("sp | wincmd j")
                hooker.select(i)
            end, select_i)
        end,
        { desc = ("Hooker %d (horizontal split)"):format(i) },
    }

    keys[#keys + 1] = {
        "n",
        "<leader>o" .. navigation_key,
        function()
            return bound_creator(function()
                hooker.select(i)
                vim.cmd.BufOnly()
            end, select_i)
        end,
        {
            desc = ("Hooker switch to only %d and displayed"):format(i),
        },
    }

    keys[#keys + 1] = {
        "n",
        "<leader>O" .. navigation_key,
        function()
            return bound_creator(function()
                hooker.select(i)
                vim.cmd.BufCurrentOnly()
            end, select_i)
        end,
        { desc = "Hooker switch to only " .. i },
    }
end

return {
    plugins = { "https://github.com/Finnian-Walsh/hooker.nvim" },

    lazy = true,

    opts = {
        hooker = {
            open_directory = function(dir)
                local pickers = Snacks.picker.get()

                for _, picker in ipairs(pickers) do
                    if picker.opts.source == "explorer" then
                        Snacks.explorer.open()
                        break
                    end
                end

                Snacks.explorer.open { cwd = dir }
            end,
        },
    },

    cmds = { "ChangeHookerDirectory" },

    config = setup,

    keys = keys,
}
