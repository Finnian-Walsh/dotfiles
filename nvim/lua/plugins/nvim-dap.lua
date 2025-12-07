return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dr", dap.clear_breakpoints, { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue debugging" })
        vim.keymap.set("n", "<leader>dn", dap.run, { desc = "New debugging session" })

        vim.fn.sign_define("DapBreakpoint", {
            text = "●",          -- symbol
            texthl = "DapBreakpoint",
        })

        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000", bg = "", bold = true })
    end
}
