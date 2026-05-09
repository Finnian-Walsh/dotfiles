require("mason").setup {}

vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason" })

local ensure_installed = {
    "stylua",
    "rust_analyzer",
    "lua_ls",
    "pyright",
    "asm_lsp",
    "ruff",
}

if not vim.uv.os_getenv("NO_CLANGD") then
    table.insert(ensure_installed, "clangd")
end

require("mason-lspconfig").setup {
    ensure_installed = ensure_installed,
    automatic_enable = { exclude = { "rust_analyzer" } },
    -- ignore_install = { "rust_analyzer" },
}

require("conform").setup {
    options = {
        formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "ruff_format" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt" },
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
end)

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename a variable" })
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { desc = "Code actions" })

local function assert_files_written()
    local file_changes = { { "Open files have changes:", "ErrorMsg" } }

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, "modified") then
            table.insert(file_changes, { "\n" .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."), "Normal" })
        end
    end

    local changes = #file_changes > 1

    if changes then
        if #file_changes == 2 then
            if vim.api.nvim_buf_get_option(0, "modified") then
                file_changes[1][1] = "The current file has changes"
                file_changes[2] = nil
            else
                file_changes[1][1] = "An open file has changes:"
            end
        end

        vim.api.nvim_echo(file_changes)
    end

    return not changes
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                vim.fn.system { "cargo", "fmt" }
                vim.cmd("edit")
            end
        end, opts)

        vim.keymap.set("n", "<leader>`", function()
            vim.cmd("e Cargo.toml")
        end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                vim.fn.system { "stylua", "." }
                vim.cmd("edit")
            end
        end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>gf", function()
            if assert_files_written() then
                vim.notify("Not yet implemented", vim.log.levels.WARN)
            end
        end, opts)
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
        if vim.bo[args.buf].modifiable then
            vim.lsp.buf.format()
        end
    end,
})

local capabilities = require("blink-cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

vim.g.rustaceanvim = {
    server = {
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
                check = { command = "clippy" },
                diagnostics = {
                    enable = true,
                    experimental = { enable = true },
                },
            },
        },
    },
}

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = {
                    "vim",
                },
            },
        },
    },
})

vim.lsp.config("pyright", {})
