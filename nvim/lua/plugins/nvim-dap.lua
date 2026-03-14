return {
    {
        "mfussenegger/nvim-dap",

        config = function()
            local dap = require("dap")

            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<leader>dB", dap.clear_breakpoints, { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue debugging" })
            vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
            vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
            vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })

            local widgets

            vim.keymap.set("n", "<leader>dw", function()
                if not widgets then
                    widgets = require("dap.ui.widgets")
                end

                local sidebar = widgets.sidebar(widgets.scopes)
                sidebar.open()
            end)

            vim.fn.sign_define("DapBreakpoint", {
                text = "🔴", -- symbol
                texthl = "DapBreakpoint",
            })

            vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000", bg = "", bold = true })
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("python3")
        end,
    },
}
