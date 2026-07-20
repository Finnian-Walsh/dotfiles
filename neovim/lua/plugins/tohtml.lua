return {
    lazy = true,

    config = function()
        vim.cmd.packadd("nvim.tohtml")
    end,

    cmds = { "TOhtml" },
}
