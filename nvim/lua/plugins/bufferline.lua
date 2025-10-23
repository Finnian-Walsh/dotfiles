return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup{
            options = {
                custom_filter = function(bufnr)
                    return vim.fn.bufname(bufnr) ~= ""
                end,
            },
        }
    end,
}
