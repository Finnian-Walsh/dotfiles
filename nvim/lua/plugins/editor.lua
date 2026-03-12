return {
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = {
                rust = { "string", "char" },
            },
        },
    },
    {
        "nvim-mini/mini.ai",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
}
