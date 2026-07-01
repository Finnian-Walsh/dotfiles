local hooker

local loader = require("lazy_loader").new {
    callback = function()
        hooker = require("hooker")

        hooker.setup {
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
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "hooker",
            callback = function(event)
                vim.b[event.buf].completion = false
            end,
        })

        vim.api.nvim_create_user_command("ChangeHookerDirectory", function(args)
            hooker.options.target_directory = args.args
        end, { nargs = 1 })
    end,
    cmds = { "ChangeHookerDirectory" },
}

loader:map("n", "<leader>a", function()
    return function()
        if vim.bo.filetype == "snacks_picker_list" then
            -- TODO: implement this
            error("Not yet implemented")
        else
            hooker.add_file()
        end
    end
end, { desc = "Add current file to hooker" })

loader:map("n", "<leader>H", function()
    return hooker.menu
end, { desc = "Open hooker menu" })

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

for i = 1, 20 do
    local navigation_key = nav_keys[i]
    local bound_creator = make_bound_creator(i)

    local function select_i()
        hooker.select(i)
    end

    loader
        :map("n", "<leader>" .. navigation_key, function()
            return bound_creator(select_i)
        end, { desc = "Hooker " .. i })
        :map("n", "<leader>n" .. navigation_key, function()
            return bound_creator(function()
                vim.cmd("vs | wincmd l")
                hooker.select(i)
            end, select_i)
        end, { desc = ("Hooker %d (vertical split)"):format(i) })
        :map("n", "<leader>N" .. navigation_key, function()
            return bound_creator(function()
                vim.cmd("sp | wincmd j")
                hooker.select(i)
            end, select_i)
        end, { desc = ("Hooker %d (horizontal split)"):format(i) })
        :map("n", "<leader>o" .. navigation_key, function()
            return bound_creator(function()
                hooker.select(i)
                vim.cmd.BufOnly()
            end, select_i)
        end, {
            desc = ("Hooker switch to only %d and displayed"):format(i),
        })
        :map("n", "<leader>O" .. navigation_key, function()
            return bound_creator(function()
                hooker.select(i)
                vim.cmd.BufCurrentOnly()
            end, select_i)
        end, { desc = "Hooker switch to only " .. i })
end
