local VIRTUAL_DIAGNOSTIC_MODE = {
    VirtualText = {
        virtual_text = true,
    },
    VirtualLines = {
        virtual_lines = true,
    },
    None = {},
}

local virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.VirtualText
local virtual_diagnostics_enabled = true
local sign_diagnostics_enabled = true
local underline_diagnostics_enabled = true

local function set_diagnostic_config()
    local config = {
        signs = sign_diagnostics_enabled,
        underline = underline_diagnostics_enabled,
        update_in_insert = true,
        virtual_lines = false,
        virtual_text = false,
    }

    if virtual_diagnostics_enabled then
        vim.tbl_extend("force", config, virtual_diagnostic_mode)
    end

    vim.diagnostic.config(config)
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

        local initial_opt_number = vim.api.nvim_win_get_option(0, "number")
        local initial_opt_relativenumber = vim.api.nvim_win_get_option(0, "relativenumber")

        vim.opt.number = false
        vim.opt.relativenumber = false

        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.api.nvim_win_set_option(0, "number", initial_opt_number)
            vim.api.nvim_win_set_option(0, "relativenumber", initial_opt_relativenumber)
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                vim.api.nvim_win_set_option(win, "number", false)
                vim.api.nvim_win_set_option(win, "relativenumber", false)
            end
        end

        virtual_diagnostics_enabled = false
        sign_diagnostics_enabled = false
        underline_diagnostics_enabled = false
        set_diagnostic_config()

        gitsigns.toggle_signs(false)
        disable_todo_signs()
    else
        line_data = true

        local initial_opt_number = vim.api.nvim_win_get_option(0, "number")
        local initial_opt_relativenumber = vim.api.nvim_win_get_option(0, "relativenumber")

        vim.opt.number = true
        vim.opt.relativenumber = true

        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.api.nvim_win_set_option(0, "number", initial_opt_number)
            vim.api.nvim_win_set_option(0, "relativenumber", initial_opt_relativenumber)
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                vim.api.nvim_win_set_option(win, "number", true)
                vim.api.nvim_win_set_option(win, "relativenumber", true)
            end
        end

        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, "ft") == "alpha" then
                vim.api.nvim_buf_set_option(buf, "number", false)
                vim.api.nvim_buf_set_option(buf, "relativenumber", false)
            end
        end

        virtual_diagnostics_enabled = true
        sign_diagnostics_enabled = true
        underline_diagnostics_enabled = true
        set_diagnostic_config()

        gitsigns.toggle_signs(true)
        reset_todo_signs()
    end
end, { desc = "Toggle line metadata" })

vim.keymap.set("n", "<leader>vl", function() -- lines
    virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.VirtualLines
    set_diagnostic_config()
end, { desc = "Separate line virtual diagnostics" })

vim.keymap.set("n", "<leader>vi", function() -- inline
    virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.VirtualText
    set_diagnostic_config()
end, { desc = "Inline virtual diagnostics" })

vim.keymap.set("n", "<leader>vn", function() -- none
    virtual_diagnostic_mode = VIRTUAL_DIAGNOSTIC_MODE.None
    set_diagnostic_config()
end, { desc = "No virtual diagnostics" })
