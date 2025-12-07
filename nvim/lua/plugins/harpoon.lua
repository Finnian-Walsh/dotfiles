local function trim_path(path, dir)
    if path:sub(1, #dir) == dir then
        return path:sub(#dir + 1)
    end

    return path
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    event = "VeryLazy",

    config = function()
        local harpoon = require("harpoon")
        harpoon:setup{
            settings = {
            save_on_toggle = true,
                save_on_change = true,
                sync_on_ui_close = true,
            }
        }

        vim.keymap.set("n", "<leader>a", function()
            local dir = require("oil").get_current_dir()
            local cwd = vim.fn.fnamemodify(vim.uv.cwd(), ":p")
            local harpoon_text

            if dir then
                local local_dir = trim_path(dir, cwd)

                local fd = vim.uv.fs_scandir(dir)
                if not fd then
                    vim.api.nvim_echo({{
                        "The current directory (" .. dir .. ") does not exist", "WarningMsg"
                    }}, true, {})
                    return
                end

                local files = {}

                while true do
                    local name, ft = vim.uv.fs_scandir_next(fd)
                    if not name then
                        break
                    end

                    if ft == "file" then
                        table.insert(files, local_dir .. name)
                    end
                end

                harpoon_text = table.concat(files, "\n")
            else
                harpoon_text = trim_path(vim.fn.expand("%"), cwd)
            end

            vim.fn.setreg('"', harpoon_text)
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Add file(s) to harpoon" })

        vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open Harpoon" })

        for i = 1, 20 do
            local navigation_key = nav_keys[i]

            vim.keymap.set("n", "<leader>" .. navigation_key, function()
                harpoon:list():select(i)
            end, { desc = "Harpoon " .. i})

            vim.keymap.set("n", "<leader>n" .. navigation_key, function()
                vim.cmd("vs | wincmd l")
                harpoon:list():select(i)
            end, { desc = "Harpoon " .. i .. " (vertical split)"})

            vim.keymap.set("n", "<leader>N" .. navigation_key, function()
                vim.cmd("sp | wincmd j")
                harpoon:list():select(i)
            end, { desc = "Harpoon " .. i .. " (horizontal split)"})

            vim.keymap.set("n", "<leader>o" .. navigation_key, function()
                harpoon:list():select(i)
                vim.cmd("BufOnly")
            end)

            vim.keymap.set("n", "<leader>O" .. navigation_key, function()
                harpoon:list():select(i)
                vim.cmd("BufCurrentOnly")
            end)
        end
    end,
}
