local telescope
local builtin

local function find_telescope_fzf()
    for _, path in ipairs(vim.opt.rtp:get()) do
        if path:match("telescope%-fzf%-native%.nvim") then
            return path
        end
    end
end

local loader = require("lazy_loader").new(function()
    telescope = require("telescope")
    builtin = require("telescope.builtin")

    telescope.setup {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    }

    vim.system({ "make" }, { cwd = find_telescope_fzf() }, function(res)
        if res.code ~= 0 then
            error(("Failed to build telescope-fzf-native.nvim with code: %d\n%s"):format(res.code, res.stderr))
        end

        local success, result = pcall(telescope.load_extension, "fzf")

        if not success then
            vim.schedule(function()
                vim.notify(
                    ("Unable to load fzf extension; stderr from make command: \n%s\nstdout from make command:\n%s\nerror from loading fzf extension:\n%s"):format(
                        res.stderr,
                        res.stdout,
                        result
                    )
                )
            end)
        end
    end)
end)

if vim.fn.executable("rg") == 0 then
    vim.notify("Warning: ripgrep is not available, so live grep will not work", vim.log.levels.WARN)
end

local initial_mode_normal = { initial_mode = "normal" }

loader:map("n", "<leader>/", function()
    return builtin.live_grep
end, { desc = "Live grep with telescope" })

loader
    :map("n", "<leader>f", function()
        return builtin.find_files
    end, { desc = "Find files with telescope" })
    :map("n", "<leader>F", function()
        return function()
            builtin.find_files(initial_mode_normal)
        end
    end, { desc = "Find files with telescope" })

loader:map("n", "<leader>R", function()
    return function()
        builtin.resume(initial_mode_normal)
    end
end, { desc = "Resume previous telescope action" })

loader:map("n", "<leader>D", function()
    return function()
        builtin.diagnostics(initial_mode_normal)
    end
end, { desc = "View diagnostics" })

loader:map("n", "<leader>C", function()
    return function()
        builtin.colorscheme(initial_mode_normal)
    end
end, { desc = "View colorschemes" })

loader
    :map("n", "<leader>b/", function()
        return builtin.buffers
    end, { desc = "Search for buffer with telescope" })
    :map("n", "<leader>b?", function()
        return function()
            builtin.buffers(initial_mode_normal)
        end
    end, { desc = "View buffers with telescope" })

loader
    :map("n", "<leader>k/", function()
        return builtin.keymaps
    end, { desc = "Search for keymaps with telescope" })
    :map("n", "<leader>k?", function()
        return function()
            builtin.keymaps(initial_mode_normal)
        end
    end, { desc = "Search for keymaps with telescope" })

loader:map("n", "<leader>L", function()
    return function()
        vim.cmd.TodoTelescope("initial_mode=normal")
    end
end, { desc = "View todo comments" })
