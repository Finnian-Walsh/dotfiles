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

vim.keymap.set("n", "<leader>B", toggle_bufferline, { noremap = true, desc = "Toggle bufferline" })

vim.api.nvim_create_user_command("ToggleBufferline", toggle_bufferline, { desc = "Toggle bufferline" })
