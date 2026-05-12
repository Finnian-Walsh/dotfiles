local hooker = require("hooker")

hooker.setup {
    open_directory = require("oil").open,
}

vim.keymap.set("n", "<leader>a", hooker.add_current, { desc = "Add current file to hooker" })

vim.keymap.set("n", "<leader>h", hooker.menu)

for i = 1, 20 do
    local navigation_key = nav_keys[i]

    local warning_message = "There is no item " .. i .. " in the hooker list"

    local function bound_function(f)
        return function()
            if hooker.length() >= i then
                f()
            else
                vim.notify(warning_message, vim.log.levels.WARN)
            end
        end
    end

    vim.keymap.set(
        "n",
        "<leader>" .. navigation_key,
        bound_function(function()
            hooker.select(i)
        end),
        { desc = "Harpoon " .. i }
    )

    vim.keymap.set(
        "n",
        "<leader>n" .. navigation_key,
        bound_function(function()
            vim.cmd("vs | wincmd l")
            hooker.select(i)
        end),
        { desc = "Harpoon " .. i .. " (vertical split)" }
    )

    vim.keymap.set(
        "n",
        "<leader>N" .. navigation_key,
        bound_function(function()
            vim.cmd("sp | wincmd j")
            hooker.select(i)
        end),
        { desc = "Harpoon " .. i .. " (horizontal split)" }
    )

    vim.keymap.set(
        "n",
        "<leader>o" .. navigation_key,
        bound_function(function()
            hooker.select(i)
            vim.cmd.BufOnly()
        end),
        {
            desc = "Harpoon switch to only " .. i .. " and displayed",
        }
    )

    vim.keymap.set(
        "n",
        "<leader>O" .. navigation_key,
        bound_function(function()
            hooker.select(i)
            vim.cmd.BufCurrentOnly()
        end),
        { desc = "Harpoon switch to only " .. i }
    )
end
