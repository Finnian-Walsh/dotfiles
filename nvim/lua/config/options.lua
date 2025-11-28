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

vim.keymap.set("n", "<leader>A", ":Alpha<CR>", { silent = true, desc = "Toggle Alpha" })
vim.keymap.set("n", "<leader>L", ":Lazy<CR>", { silent = true, desc = "Open Lazy" })
vim.keymap.set("n", "<leader>M", ":Mason<CR>", { silent = true, desc = "Open Mason" })

vim.keymap.set("n", "<leader>b", function()
    vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
end, { noremap = true, silent = true, desc = "Toggle bufferline" })
vim.keymap.set("n", "<leader>n", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer " })
vim.keymap.set("n", "<leader>p", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous buffer "})
vim.keymap.set("n", "<leader>c", ":bd<CR>", { noremap = true, silent = true, desc = "Close buffer"})
vim.keymap.set("n", "<leader>C", ":bufdo bd<CR>", { noremap = true, silent = true, desc = "Close buffer"})

vim.keymap.set("n", "<leader><Right>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("BufferLineMoveNext")
    end
end, { silent = true, desc = "Move the buffer right" })

vim.keymap.set("n", "<leader><Left>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("BufferLineMovePrev")
    end
end, { silent = true, desc = "Move the buffer left" })

vim.keymap.set("n", "<leader>o", ":tabnew<CR>", { noremap = true, silent = true, desc = "Open a new tab" })
vim.keymap.set("n", "<leader>O", ":tabnew | tabmove -1<CR>", { noremap = true, silent = true, desc = "Open a new tab" })
vim.keymap.set("n", "<leader><leader>n", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnext")
    end
end, { noremap = true, silent = true, desc = "Next tab " })
vim.keymap.set("n", "<leader><leader>p", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabprev")
    end
end, { noremap = true, silent = true, desc = "Previous tab "})
vim.keymap.set("n", "<leader><leader>c", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close all buffers"})
vim.keymap.set("n", "<leader><leader>C", ":tabonly<CR>", { noremap = true, silent = true, desc = "Close all buffers"})

local function current_tab_can_move(count)
    local tabs = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local tab_position

    for i, tab in ipairs(tabs) do
        if tab == current_tab then
            tab_position = i
        end
    end

    assert(tab_position, "Current tab not found")

    local position = tab_position + count
    return position >= 1 and position <= #tabs
end

vim.keymap.set("n", "<leader><leader><Right>", function()
    local count = vim.v.count1
    if current_tab_can_move(count) then
        vim.cmd("tabmove +" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab +" .. count, "ErrorMsg" }}, true, {})
    end
end, { silent = true, desc = "Move the tab right" })

vim.keymap.set("n", "<leader><leader><Left>", function()
    local count = vim.v.count1
    if current_tab_can_move(-count) then
        vim.cmd("tabmove -" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab -" .. count, "ErrorMsg" }}, true, {})
    end
end, { silent = true, desc = "Move the tab left" })

vim.keymap.set("n", "<leader>z", function()
    local count = vim.v.count1
    print(count)
end, { silent = true, desc = "Test keymap" })

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

vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(args)
        local buf = args.buf

        if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].filetype ~= "" then
            return
        end

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        if #lines == 1 and lines[1] == "" then
            vim.schedule(function()
                vim.api.nvim_buf_delete(buf, { force = true })
            end)
        end
    end
})

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
