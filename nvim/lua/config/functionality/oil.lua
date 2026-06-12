local oil

local oil_autocmd_group = vim.api.nvim_create_augroup("OilLoadEvents", {})
local group_deleted = false

local loader = require("lazy_loader").new(function()
    if not group_deleted then
        vim.api.nvim_del_augroup_by_id(oil_autocmd_group)
    end

    oil = require("oil")
    oil.setup {
        keymaps = {
            ["<leader>."] = "actions.toggle_hidden",
            ["<C-l>"] = false,
            ["<leader>r"] = "actions.refresh",
            ["<C-h>"] = false,
        },
        devicons = {
            icons = require("nvim-web-devicons").get_icons(),
        },
    }
end)

loader:cmd("Oil")

loader
    :map("n", "<leader>e", function()
        return oil.open
    end, { desc = "Open file tree" })
    :map("n", "<leader>ne", function()
        return function()
            vim.cmd("vs | wincmd l")
            oil.open()
        end
    end, { desc = "Open oil file tree in new vertical split" })
    :map("n", "<leader>Ne", function()
        return function()
            vim.cmd("sp | wincmd j")
            oil.open()
        end
    end, { desc = "Open oil file tree in new horizontal split" })

loader
    :map("n", "<leader>E", function()
        return function()
            oil.open(vim.uv.cwd())
        end
    end, { desc = "Open oil file tree at cwd" })
    :map("n", "<leader>nE", function()
        return function()
            vim.cmd("vs | wincmd l")
            oil.open(vim.uv.cwd())
        end
    end, { desc = "Open oil file tree at cwd in new vertical split" })
    :map("n", "<leader>NE", function()
        return function()
            vim.cmd("sp | wincmd j")
            oil.open(vim.uv.cwd())
        end
    end, { desc = "Open oil file tree at cwd in new horizontal split" })

vim.api.nvim_create_autocmd("BufEnter", {
    group = oil_autocmd_group,
    callback = function(args)
        local name = vim.api.nvim_buf_get_name(args.buf)

        if vim.fn.isdirectory(name) == 1 then
            vim.api.nvim_del_augroup_by_id(oil_autocmd_group)
            group_deleted = true

            loader()
            vim.schedule(function()
                oil.open(name)
            end)
        end
    end,
})
