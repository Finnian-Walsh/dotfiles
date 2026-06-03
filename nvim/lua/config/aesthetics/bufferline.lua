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

vim.keymap.set("n", "<leader>B", toggle_bufferline, { desc = "Toggle bufferline" })

vim.api.nvim_create_user_command("ToggleBufferline", toggle_bufferline, { desc = "Toggle bufferline" })

vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        require("bufferline").setup {
            options = {
                custom_filter = function(buf)
                    local buf_info = vim.bo[buf]
                    local filetype = buf_info.filetype
                    local is_normal = filetype ~= "alpha" and filetype ~= "harpoon"
                    return is_normal and (vim.api.nvim_buf_get_name(buf) ~= "" or buf_info.modified)
                end,
            },
        }

        hide_tabline()
    end,
})

-- Automatic tabline updation

local function schedule_tabline_redraw()
    vim.schedule(function()
        vim.cmd.redrawtabline()
    end)
end

vim.api.nvim_create_autocmd("BufLeave", {
    callback = schedule_tabline_redraw,
})
