local function show_tabline()
    vim.o.showtabline = 2
end

local function hide_tabline()
    vim.o.showtabline = 0
end

local function toggle_bufferline()
    if vim.o.showtabline < 2 then
        show_tabline()
    else
        hide_tabline()
    end
end

local function schedule_tabline_redraw()
    vim.schedule(vim.cmd.redrawtabline)
end

return {
    plugins = {
        "https://github.com/akinsho/bufferline.nvim",
        "https://github.com/nvim-tree/nvim-web-devicons",
    },

    lazy = true,

    config = function()
        require("bufferline").setup {
            options = {
                custom_filter = function(buf)
                    local buf_info = vim.bo[buf]
                    local filetype = buf_info.filetype
                    local is_normal = filetype ~= "harpoon"
                    return is_normal and (vim.api.nvim_buf_get_name(buf) ~= "" or buf_info.modified)
                end,
            },
        }

        vim.keymap.set("n", "<leader>B", toggle_bufferline, { desc = "Toggle bufferline" })

        hide_tabline()
        -- Automatic tabline updation
        vim.api.nvim_create_autocmd("BufLeave", {
            callback = schedule_tabline_redraw,
        })
    end,

    autocmds = { "UIEnter" },
}
