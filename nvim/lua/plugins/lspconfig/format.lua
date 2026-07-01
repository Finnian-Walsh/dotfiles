require("conform").setup {
    options = {
        formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "ruff_format" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt" },

            json = { "prettierd" },

            java = { "google-java-format" },
        },
        format_on_save = {
            timeout_ms = 5000,
        },
    },
}

vim.keymap.set("n", "<leader>lf", function()
    vim.lsp.buf.format {
        async = true,
    }
end, { desc = "Format the current file" })

local function assert_files_written()
    local file_changes = { "Open files have changes:" }

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].modified then
            table.insert(file_changes, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."))
        end
    end

    local changes = #file_changes > 1

    if changes then
        if #file_changes == 2 then
            if vim.bo.modified then
                file_changes[1] = "The current file has changes"
                file_changes[2] = nil
            else
                file_changes[1] = "An open file has changes:"
            end
        end

        vim.notify(table.concat(file_changes, "\n"), vim.log.levels.ERROR)
    end

    return not changes
end

local function handle_format_command(proc)
    local obj = proc:wait()

    if obj.code == 0 then
        vim.cmd.edit()
        return
    end

    vim.notify("Failed to format files:\n" .. obj.stderr, vim.log.levels.ERROR)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                handle_format_command(vim.system { "cargo", "fmt" })
            end
        end, { desc = "Globally format files", buffer = ev.buf })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function(ev)
        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                handle_format_command(vim.system { "stylua", "." })
            end
        end, { desc = "Globally format files", buffer = ev.buf })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(ev)
        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                vim.notify("Not yet implemented", vim.log.levels.WARN)
            end
        end, { desc = "Globally format files", buf = ev.buf })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        if vim.bo[args.buf].modifiable then
            vim.lsp.buf.format()
        end
    end,
})
