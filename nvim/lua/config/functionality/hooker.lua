local hooker = require("hooker")

hooker.setup {
    open_directory = require("oil").open,
}

vim.keymap.set("n", "<leader>a", function()
    if vim.bo.filetype == "oil" then
        hooker.add_file(vim.api.nvim_buf_get_name(0):gsub("^oil://", ""))
    else
        hooker.add_file()
    end
end, { desc = "Add current file to hooker" })

vim.keymap.set("n", "<leader>h", hooker.menu)

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

    vim.keymap.set(
        "n",
        "<leader>" .. navigation_key,
        bound_creator(function()
            hooker.select(i)
        end),
        { desc = "Hooker " .. i }
    )

    vim.keymap.set(
        "n",
        "<leader>n" .. navigation_key,
        bound_creator(function()
            vim.cmd("vs | wincmd l")
            hooker.select(i)
        end),
        { desc = "Hooker " .. i .. " (vertical split)" }
    )

    vim.keymap.set(
        "n",
        "<leader>N" .. navigation_key,
        bound_creator(function()
            vim.cmd("sp | wincmd j")
            hooker.select(i)
        end),
        { desc = "Hooker " .. i .. " (horizontal split)" }
    )

    vim.keymap.set(
        "n",
        "<leader>o" .. navigation_key,
        bound_creator(function()
            hooker.select(i)
            vim.cmd.BufOnly()
        end),
        {
            desc = "Hooker switch to only " .. i .. " and displayed",
        }
    )

    vim.keymap.set(
        "n",
        "<leader>O" .. navigation_key,
        bound_creator(function()
            hooker.select(i)
            vim.cmd.BufCurrentOnly()
        end),
        { desc = "Hooker switch to only " .. i }
    )
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "hooker",
    callback = function(event)
        vim.b[event.buf].completion = false
    end,
})
