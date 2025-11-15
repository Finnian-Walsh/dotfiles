vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Turn highlight off" })
vim.keymap.set("n", "<leader>c", ":bd<CR>", { noremap = true, silent = true, desc = "Close buffer"})
vim.keymap.set("n", "<leader>C", ":bufdo bd<CR>", { noremap = true, silent = true, desc = "Close all buffers"})
vim.keymap.set("n", "<leader>b", function()
    vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
end, { noremap = true, silent = true, desc = "Toggle bufferline" })
vim.keymap.set("n", "<leader>m", function()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
        vim.treesitter.stop()
    else
        vim.cmd("syntax enable")
        vim.treesitter.start()
    end
end, { noremap = true, silent = true, desc = "Toggle monochrome" })
vim.keymap.set("n", "<leader>j", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer " })
vim.keymap.set("n", "<leader>k", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous buffer "})

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true, desc = "Move to window left" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true, desc = "Move to window right" })
vim.keymap.set("n", "<C-`>", ":wincmd =<CR>", { noremap = true, silent = true, desc = "Equalize windows" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({"r"})
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        vim.lsp.config("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    checkOnSave = true,
                    check = { command = "clippy" },
                },
            }
        })

        local opts = { silent = true, buffer = true }

        vim.keymap.set("n", "<localleader>rf", function()
            if vim.api.nvim_buf_get_option(0, "modified") then
                vim.api.nvim_echo({{"The current file has changes", "ErrorMsg" }}, true, {})
                return
            end

            vim.cmd("!rustfmt " .. vim.fn.expand("%"))
            vim.cmd("edit");
        end, opts)

        vim.keymap.set("n", "<localleader>gf", function()
            local file_changes = {{ "Open files have changes:", "ErrorMsg" }}
            for _, buf in ipairs(vim.fn.getbufinfo{ buflisted = 1}) do
                if vim.api.nvim_buf_get_option(buf.bufnr, "modified") then
                    table.insert(file_changes, { "\n" .. vim.fn.fnamemodify(buf.name, ":."), "Normal" })
                end
            end

            if #file_changes > 1 then
                if #file_changes == 2 then
                    if vim.api.nvim_buf_get_option(0, "modified") then
                        file_changes[1][1] = "The current file has changes"
                        file_changes[2] = nil
                    else
                        file_changes[1][1] = "An open file has changes:"
                    end
                end

                vim.api.nvim_echo(file_changes, true, {})
                return
            end

            vim.cmd("!cargo fmt")
            vim.cmd("edit")
        end, opts)

        vim.keymap.set("n", "<leader>`", function() vim.cmd("e Cargo.toml") end, opts)
        vim.keymap.set("n", "<leader><leader>`", function() vim.cmd("e Cargo.lock") end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                        }
                    }
                }
            }
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        vim.lsp.config("jdtls", {})
    end
})
