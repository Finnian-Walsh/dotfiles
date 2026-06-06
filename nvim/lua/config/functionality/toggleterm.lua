require("core.lazy_keymaps")
    .new(function()
        require("toggleterm").setup {}
    end)
    :add("n", "<leader><CR>", vim.cmd.ToggleTerm, { desc = "Toggle terminal" })
