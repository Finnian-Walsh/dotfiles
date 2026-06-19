require("mason").setup {}

vim.keymap.set("n", "<leader>M", vim.cmd.Mason, { desc = "Open Mason" })

local ensure_installed = {
    -- Vimscript
    "vimls",
    -- Lua
    "stylua",
    -- Rust
    "rust_analyzer",
    -- Lua
    "lua_ls",
    -- Python
    "pyright",
    "ruff",
    -- Asm
    "asm_lsp",
    -- Web dev
    "ts_ls",
    "html",
    "cssls",
    "eslint",
}

if vim.uv.os_getenv("NO_CLANGD") ~= "1" then
    table.insert(ensure_installed, "clangd")
end

vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        require("mason-lspconfig").setup {
            ensure_installed = ensure_installed,
            automatic_enable = { exclude = { "rust_analyzer" } },
            -- ignore_install = { "rust_analyzer" },
        }
    end,
})

require("conform").setup {
    options = {
        formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "ruff_format" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt" },

            json = { "prettierd" },
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

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename a variable" })
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

vim.keymap.set("n", "gnd", function()
    vim.cmd("vs | wincmd l")
    vim.lsp.buf.definition()
end, { desc = "Go to definition in a new buffer" })

vim.keymap.set("n", "gNd", function()
    vim.cmd("sp | wincmd j")
    vim.lsp.buf.definition()
end, { desc = "Go to definition in a new buffer" })

vim.keymap.set("n", "gnD", function()
    vim.cmd("vs | wincmd l")
    vim.lsp.buf.declaration()
end, { desc = "Go to declaration in a new buffer" })

vim.keymap.set("n", "gNd", function()
    vim.cmd("sp | wincmd j")
    vim.lsp.buf.declaration()
end, { desc = "Go to definition in a new buffer" })

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

local lua_library = vim.api.nvim_get_runtime_file("", true)

table.insert(lua_library, "${3rd}/luv/library")
table.insert(lua_library, "${3rd}/luassert/library")
table.insert(lua_library, "${3rd}/busted/library")

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
            -- workspace = {
            --     library = lua_library,
            --     -- checkThirdParty = true,
            -- },
        },
    },
})

vim.lsp.config("pyright", {})
