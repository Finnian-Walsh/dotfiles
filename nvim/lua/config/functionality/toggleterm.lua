require("lazy_loader")
    .new(function()
        require("toggleterm").setup {}
    end)
    :map("n", "<leader><CR>", vim.cmd.ToggleTerm, { desc = "Toggle terminal" })
