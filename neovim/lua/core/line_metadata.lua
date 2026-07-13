local VirtualDiagnosticMode = {
    VIRTUAL_TEXT = {
        virtual_text = true,
    },
    VIRTUAL_LINES = {
        virtual_lines = true,
    },
    NONE = {},
}

local virtual_diagnostic_mode = VirtualDiagnosticMode.VIRTUAL_TEXT
local virtual_diagnostics_enabled = true
local sign_diagnostics_enabled = true
local underline_diagnostics_enabled = true

local base_diagnostic_config = {
    signs = sign_diagnostics_enabled,
    underline = underline_diagnostics_enabled,
    update_in_insert = true,
    virtual_lines = false,
    virtual_text = false,
}

local function set_diagnostic_config()
    if virtual_diagnostics_enabled then
        vim.diagnostic.config(vim.tbl_extend("force", base_diagnostic_config, virtual_diagnostic_mode))
    else
        vim.diagnostic.config(base_diagnostic_config)
    end
end

set_diagnostic_config()

local gitsigns
local line_data = true

vim.keymap.set("n", "<leader>x", function()
    if not gitsigns then
        gitsigns = require("gitsigns")
    end

    if line_data then
        line_data = false

        local initial_opt_number = vim.api.nvim_get_option_value("number", { win = 0 })
        local initial_opt_relativenumber = vim.api.nvim_get_option_value("relativenumber", { win = 0 })

        vim.opt.number = false
        vim.opt.relativenumber = false

        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.api.nvim_set_option_value("number", initial_opt_number, { win = 0 })
            vim.api.nvim_set_option_value("relativenumber", initial_opt_relativenumber, { win = 0 })
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                vim.api.nvim_set_option_value("number", false, { win = win })
                vim.api.nvim_set_option_value("relativenumber", false, { win = win })
            end
        end

        virtual_diagnostics_enabled = false
        sign_diagnostics_enabled = false
        underline_diagnostics_enabled = false
        set_diagnostic_config()

        gitsigns.toggle_signs(false)
        disable_todo_signs()

        Snacks.indent.disable()
    else
        line_data = true

        local initial_opt_number = vim.api.nvim_get_option_value("number", { win = 0 })
        local initial_opt_relativenumber = vim.api.nvim_get_option_value("relativenumber", { win = 0 })

        vim.opt.number = true
        vim.opt.relativenumber = true

        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.api.nvim_set_option_value("number", initial_opt_number, { win = 0 })
            vim.api.nvim_set_option_value("relativenumber", initial_opt_relativenumber, { win = 0 })
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                vim.api.nvim_set_option_value("number", true, { win = win })
                vim.api.nvim_set_option_value("relativenumber", true, { win = win })
            end
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "alpha" then
                local buf_t = { buf = buf }
                vim.api.nvim_set_option_value("number", false, buf_t)
                vim.api.nvim_set_option_value("relativenumber", false, buf_t)
            end
        end

        virtual_diagnostics_enabled = true
        sign_diagnostics_enabled = true
        underline_diagnostics_enabled = true
        set_diagnostic_config()

        gitsigns.toggle_signs(true)
        reset_todo_signs()

        Snacks.indent.enable()
    end
end, { desc = "Toggle line metadata" })

vim.keymap.set("n", "<leader>vl", function() -- lines
    virtual_diagnostic_mode = VirtualDiagnosticMode.VIRTUAL_LINES
    set_diagnostic_config()
end, { desc = "Separate line virtual diagnostics" })

vim.keymap.set("n", "<leader>vi", function() -- inline
    virtual_diagnostic_mode = VirtualDiagnosticMode.VIRTUAL_TEXT
    set_diagnostic_config()
end, { desc = "Inline virtual diagnostics" })

vim.keymap.set("n", "<leader>vn", function() -- none
    virtual_diagnostic_mode = VirtualDiagnosticMode.NONE
    set_diagnostic_config()
end, { desc = "No virtual diagnostics" })
