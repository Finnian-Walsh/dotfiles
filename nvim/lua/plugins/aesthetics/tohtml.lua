require("lazy_loader").new {
    callback = function()
        vim.cmd.packadd("nvim.tohtml")
    end,
    cmds = { "TOhtml" },
}
