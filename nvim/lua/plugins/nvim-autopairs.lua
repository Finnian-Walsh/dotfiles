return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
    opts = {
        check_ts = true,
        ts_config = {
            rust = { "string", "char" },
        },
    },
}
