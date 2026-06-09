require("lazy_loader")
    .new(function()
        require("toggleterm").setup {}
    end)
    :map("n", "<leader><CR>", function()
        return vim.cmd.ToggleTerm
    end, { desc = "Toggle terminal" })
    :cmd("ToggleTerm")
