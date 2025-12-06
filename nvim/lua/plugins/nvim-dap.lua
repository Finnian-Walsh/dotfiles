return {
    "mfussenegger/nvim-dap",
    config = function()
        vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue debugging" })
        vim.keymap.set("n", "<leader>dn", "<cmd>DapNew<CR>", { desc = "New debugging session" })
    end
}
