local dap
return {
    plugins = {
        "https://github.com/mfussenegger/nvim-dap",
        "https://github.com/mfussenegger/nvim-dap-python",
    },

    lazy = true,

    config = function()
        dap = require("dap")
        require("dap-python").setup("python3")

        vim.fn.sign_define("DapBreakpoint", {
            text = "🔴", -- symbol
            texthl = "DapBreakpoint",
        })

        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000", bg = "", bold = true })
    end,

    keys = {
        {
            "n",
            "<leader>db",
            function()
                return dap.toggle_breakpoint
            end,
            { desc = "Toggle breakpoint" },
        },
        {
            "n",
            "<leader>dB",
            function()
                return dap.clear_breakpoints
            end,
            { desc = "Toggle breakpoint" },
        },

        {

            "n",
            "<leader>dc",
            function()
                return dap.continue
            end,
            { desc = "Continue debugging" },
        },

        {
            "n",
            "<leader>di",
            function()
                return dap.step_into
            end,
            { desc = "Step into" },
        },

        {
            "n",
            "<leader>do",
            function()
                return dap.step_over
            end,
            { desc = "Step over" },
        },

        {
            "n",
            "<leader>dO",
            function()
                return dap.step_out
            end,
            { desc = "Step out" },
        },

        {
            "n",
            "<leader>dw",
            function()
                local widgets = require("dap.ui.widgets")
                return function()
                    local sidebar = widgets.sidebar(widgets.scopes)
                    sidebar.open()
                end
            end,
            { desc = "Open dap widgets" },
        },
    },
}
