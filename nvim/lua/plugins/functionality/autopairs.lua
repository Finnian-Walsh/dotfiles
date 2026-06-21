vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        require("nvim-autopairs").setup {
            check_ts = true,
            ts_config = {
                rust = { "string", "char" },
            },
        }
    end,
})
