return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
        options = {
            custom_filter = function(buf)
                local buf_info = vim.bo[buf]
                local filetype = buf_info.filetype
                local is_normal = filetype ~= "alpha" and filetype ~= "harpoon"
                return is_normal and (vim.api.nvim_buf_get_name(buf) ~= "" or buf_info.modified)
            end,
        },
    }
}
