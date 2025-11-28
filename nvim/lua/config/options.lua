vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = ""

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Turn highlight off" })

vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "Write" })

vim.keymap.set("n", "<leader>A", ":Alpha<CR>", { silent = true, desc = "Toggle Alpha" })
vim.keymap.set("n", "<leader>L", ":Lazy<CR>", { silent = true, desc = "Open Lazy" })
vim.keymap.set("n", "<leader>M", ":Mason<CR>", { silent = true, desc = "Open Mason" })

vim.keymap.set("n", "<leader>b", function()
    vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
end, { noremap = true, silent = true, desc = "Toggle bufferline" })
vim.keymap.set("n", "<leader>n", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer " })
vim.keymap.set("n", "<leader>p", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous buffer "})
vim.keymap.set("n", "<leader>c", ":bd<CR>", { noremap = true, silent = true, desc = "Close buffer"})
vim.keymap.set("n", "<leader><leader>c", ":bufdo bd<CR>", { noremap = true, silent = true, desc = "Close buffer"})

vim.keymap.set("n", "<leader>o", ":tabnew<CR>", { noremap = true, silent = true, desc = "Open a new tab" })
vim.keymap.set("n", "<leader>O", ":tabnew | tabmove -1<CR>", { noremap = true, silent = true, desc = "Open a new tab" })
vim.keymap.set("n", "<leader>N", ":tabnext<CR>", { noremap = true, silent = true, desc = "Next buffer " })
vim.keymap.set("n", "<leader>P", ":tabprev<CR>", { noremap = true, silent = true, desc = "Previous buffer "})
vim.keymap.set("n", "<leader>C", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close all buffers"})
vim.keymap.set("n", "<leader><leader>C", ":tabonly<CR>", { noremap = true, silent = true, desc = "Close all buffers"})

vim.keymap.set("n", "<leader><leader>1", ":tabnext 1<CR>", { noremap = true, silent = true, desc = "Go to tab 1" })
vim.keymap.set("n", "<leader><leader>2", ":tabnext 2<CR>", { noremap = true, silent = true, desc = "Go to tab 2" })
vim.keymap.set("n", "<leader><leader>3", ":tabnext 3<CR>", { noremap = true, silent = true, desc = "Go to tab 3" })
vim.keymap.set("n", "<leader><leader>4", ":tabnext 4<CR>", { noremap = true, silent = true, desc = "Go to tab 4" })
vim.keymap.set("n", "<leader><leader>5", ":tabnext 5<CR>", { noremap = true, silent = true, desc = "Go to tab 5" })
vim.keymap.set("n", "<leader><leader>6", ":tabnext 6<CR>", { noremap = true, silent = true, desc = "Go to tab 6" })
vim.keymap.set("n", "<leader><leader>7", ":tabnext 7<CR>", { noremap = true, silent = true, desc = "Go to tab 7" })
vim.keymap.set("n", "<leader><leader>8", ":tabnext 8<CR>", { noremap = true, silent = true, desc = "Go to tab 8" })
vim.keymap.set("n", "<leader><leader>9", ":tabnext 9<CR>", { noremap = true, silent = true, desc = "Go to tab 9" })
vim.keymap.set("n", "<leader><leader>0", ":tabnext 0<CR>", { noremap = true, silent = true, desc = "Go to tab 0" })

vim.keymap.set("n", "<leader><leader>!", ":tabnext 11<CR>", { noremap = true, silent = true, desc = "Go to tab 11" })
vim.keymap.set("n", "<leader><leader>\"", ":tabnext 12<CR>", { noremap = true, silent = true, desc = "Go to tab 12" })
vim.keymap.set("n", "<leader><leader>£", ":tabnext 13<CR>", { noremap = true, silent = true, desc = "Go to tab 13" })
vim.keymap.set("n", "<leader><leader>$", ":tabnext 14<CR>", { noremap = true, silent = true, desc = "Go to tab 14" })
vim.keymap.set("n", "<leader><leader>%", ":tabnext 15<CR>", { noremap = true, silent = true, desc = "Go to tab 15" })
vim.keymap.set("n", "<leader><leader>^", ":tabnext 16<CR>", { noremap = true, silent = true, desc = "Go to tab 16" })
vim.keymap.set("n", "<leader><leader>&", ":tabnext 17<CR>", { noremap = true, silent = true, desc = "Go to tab 17" })
vim.keymap.set("n", "<leader><leader>*", ":tabnext 18<CR>", { noremap = true, silent = true, desc = "Go to tab 18" })
vim.keymap.set("n", "<leader><leader>(", ":tabnext 19<CR>", { noremap = true, silent = true, desc = "Go to tab 19" })
vim.keymap.set("n", "<leader><leader>)", ":tabnext 20<CR>", { noremap = true, silent = true, desc = "Go to tab 20" })

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "Open neo-tree" })
vim.keymap.set("n", "<leader>m", function()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
        vim.treesitter.stop()
    else
        vim.cmd("syntax enable")
        vim.treesitter.start()
    end
end, { noremap = true, silent = true, desc = "Toggle Linus syntax highlighting" })

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true, desc = "Move to window left" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true, desc = "Move to window right" })
vim.keymap.set("n", "<C-`>", ":wincmd =<CR>", { noremap = true, silent = true, desc = "Equalize windows" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({"o"})
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

        vim.keymap.set("n", "<localleader>ff", function()
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
                if vim.api.nvim_buf_get_option(buf.buf, "modified") then
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "norg",
    callback = function()
        vim.b.completion = false
    end
})
