return {
    plugins = { "https://github.com/windwp/nvim-autopairs" },

    lazy = true,

    opts = {
        ["nvim-autopairs"] = {
            check_ts = true,
            ts_config = {
                rust = { "string", "char" },
            },
        },
    },

    autocmds = { "InsertEnter" },
}
