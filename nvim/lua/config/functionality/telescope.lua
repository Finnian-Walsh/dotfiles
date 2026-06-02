local telescope = require("telescope")

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

local function find_telescope_fzf()
    for _, path in ipairs(vim.opt.rtp:get()) do
        if path:match("telescope%-fzf%-native%.nvim") then
            return path
        end
    end
end

vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        local command = { "make", "-C", find_telescope_fzf() }
        vim.system(command, {}, function(res)
            if res.code ~= 0 then
                error(
                    string.format("Failed to build telescope-fzf-native.nvim with code: %d\n%s", res.code, res.stderr),
                    vim.log.levels.ERROR
                )
                return
            end

            local success, result = pcall(function()
                telescope.load_extension("fzf")
            end)

            if not success then
                vim.schedule(function()
                    vim.notify(
                        string.format(
                            "Unable to load fzf extension; stderr from make command: \n%s\nstdout from make command:\n%s\nerror from loading fzf extension:\n%s",
                            res.stderr,
                            res.stdout,
                            result
                        )
                    )
                end)
            end
        end)
    end,
})

if vim.fn.executable("rg") == 0 then
    vim.notify("Warning: ripgrep is not available, so live grep will not work", vim.log.levels.WARN)
end

local builtin = require("telescope.builtin")
local initial_mode_normal = { initial_mode = "normal" }

vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep with telescope" })

vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files with telescope" })
vim.keymap.set("n", "<leader>F", function()
    builtin.find_files(initial_mode_normal)
end, { desc = "Find files with telescope" })

vim.keymap.set("n", "<leader>R", function()
    builtin.resume(initial_mode_normal)
end, { desc = "Resume previous telescope action" })
vim.keymap.set("n", "<leader>D", function()
    builtin.diagnostics(initial_mode_normal)
end, { desc = "View diagnostics" })

vim.keymap.set("n", "<leader>C", function()
    builtin.colorscheme(initial_mode_normal)
end, { desc = "View colorschemes" })

vim.keymap.set("n", "<leader>b/", builtin.buffers, { desc = "Search for buffer with telescope" })
vim.keymap.set("n", "<leader>b?", function()
    builtin.buffers(initial_mode_normal)
end, { desc = "View buffers with telescope" })

vim.keymap.set("n", "<leader>k/", builtin.keymaps, { desc = "Search for keymaps with telescope" })
vim.keymap.set("n", "<leader>k?", function()
    builtin.keymaps(initial_mode_normal)
end, { desc = "Search for keymaps with telescope" })

vim.keymap.set("n", "<leader>i", function()
    vim.cmd.TodoTelescope("initial_mode=normal")
end, { desc = "View todo comments" })
