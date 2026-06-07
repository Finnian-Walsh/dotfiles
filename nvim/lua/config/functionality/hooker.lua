local hooker

local loader = require("lazy_loader")
    .new(function()
        hooker = require("hooker")

        hooker.setup {
            open_directory = vim.cmd.Oil,
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "hooker",
            callback = function(event)
                vim.b[event.buf].completion = false
            end,
        })

        vim.api.nvim_create_user_command("ChangeHookerDirectory", function(args)
            hooker.options.directory = args.args
        end, { nargs = 1 })
    end)
    :cmd("ChangeHookerDirectory")

loader:map("n", "<leader>a", function()
    return function()
        if vim.bo.filetype == "oil" then
            hooker.add_file(vim.api.nvim_buf_get_name(0):gsub("^oil://", ""))
        else
            hooker.add_file()
        end
    end
end, { desc = "Add current file to hooker" })

loader:map("n", "<leader>h", function()
    return hooker.menu
end, { desc = "Open hooker menu" })

local function make_bound_creator(i)
    local warning_message = "There is no item " .. i .. " in the hooker list"
    return function(f)
        return function()
            if hooker.length() >= i then
                f()
            else
                vim.notify(warning_message, vim.log.levels.WARN)
            end
        end
    end
end

for i = 1, 20 do
    local navigation_key = nav_keys[i]
    local bound_creator = make_bound_creator(i)

    loader
        :map("n", "<leader>" .. navigation_key, function()
            return bound_creator(function()
                hooker.select(i)
            end)
        end, { desc = "Hooker " .. i })
        :map("n", "<leader>n" .. navigation_key, function()
            return bound_creator(function()
                vim.cmd("vs | wincmd l")
                hooker.select(i)
            end)
        end, { desc = ("Hooker %d (vertical split)"):format(i) })
        :map("n", "<leader>N" .. navigation_key, function()
            return bound_creator(function()
                vim.cmd("sp | wincmd j")
                hooker.select(i)
            end)
        end, { desc = ("Hooker %d (horizontal split)"):format(i) })
        :map("n", "<leader>o" .. navigation_key, function()
            return bound_creator(function()
                hooker.select(i)
                vim.cmd.BufOnly()
            end)
        end, {
            desc = ("Hooker switch to only %d and displayed"):format(i),
        })
        :map("n", "<leader>O" .. navigation_key, function()
            return bound_creator(function()
                hooker.select(i)
                vim.cmd.BufCurrentOnly()
            end)
        end, { desc = "Hooker switch to only " .. i })
end
