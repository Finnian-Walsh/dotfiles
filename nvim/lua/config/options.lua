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
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, desc = "Turn highlight off" })
vim.keymap.set("n", "<leader>s", "<cmd>source<CR>", { desc = "Source Neovim config" })

vim.keymap.set("n", "<leader>A", "<cmd>Alpha<CR>", { desc = "Toggle Alpha" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason" })

vim.keymap.set("n", "<leader>b", function()
    vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
end, { noremap = true, desc = "Toggle bufferline" })
vim.keymap.set("n", "<leader>n", function()
    vim.cmd("bnext " .. vim.v.count1)
end, { noremap = true, desc = "Next buffer " })
vim.keymap.set("n", "<leader>p", function()
    vim.cmd("bprev " .. vim.v.count1)
end, { noremap = true, desc = "Previous buffer "})
vim.keymap.set("n", "<leader>c", "<cmd>bd<CR>", { noremap = true, desc = "Close buffer"})
vim.keymap.set("n", "<leader>C", "<cmd>bufdo bd<CR>", { noremap = true, desc = "Close buffer"})

vim.keymap.set("n", "<leader><Right>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("BufferLineMoveNext")
    end
end, { desc = "Move the buffer right" })

vim.keymap.set("n", "<leader><Left>", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("BufferLineMovePrev")
    end
end, { desc = "Move the buffer left" })

vim.keymap.set("n", "<leader>o", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew")
    end
end, { noremap = true, desc = "Open a new tab" })

vim.keymap.set("n", "<leader>O", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew | tabmove -1")
    end
end, { noremap = true, desc = "Open a new tab" })

vim.keymap.set("n", "<leader><leader>n", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnext")
    end
end, { noremap = true, desc = "Next tab " })
vim.keymap.set("n", "<leader><leader>p", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabprev")
    end
end, { noremap = true, desc = "Previous tab "})

vim.keymap.set("n", "<leader><leader>c", "<cmd>tabclose<CR>", { noremap = true, desc = "Close all buffers"})
vim.keymap.set("n", "<leader><leader>C", "<cmd>tabonly<CR>", { noremap = true, desc = "Close all buffers"})

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
end, { desc = "Move the tab right" })

vim.keymap.set("n", "<leader><leader><Left>", function()
    local count = vim.v.count1
    if current_tab_can_move(-count) then
        vim.cmd("tabmove -" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab -" .. count, "ErrorMsg" }}, true, {})
    end
end, { desc = "Move the tab left" })

vim.keymap.set("n", "<leader>z", function()
    local count = vim.v.count1
    print(count)
end, { desc = "Test keymap" })

_G.nav_keys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "!", "\"", "£", "$", "%", "^", "&", "*", "(", ")"
}

for i = 1, 20 do
    vim.keymap.set("n", "<leader><leader>" .. nav_keys[i], "<cmd>tabnext " .. i .. "<CR>", { noremap = true, desc = "Go to tab " .. i})
end

vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(args)
        local buf = args.buf

        if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].filetype ~= "" then
            return
        end

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        if #lines > 1 or lines[1] ~= "" then
            return
        end

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == buf then
                if vim.api.nvim_win_get_config(win).relative ~= "" then -- buffer in a floating window
                    return
                end
            end
        end

        vim.schedule(function()
            vim.api.nvim_buf_delete(buf, { force = true })
        end)
    end
})

vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        vim.schedule(function()
            vim.cmd("redrawtabline")
        end)
    end
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Open neo-tree" })
vim.keymap.set("n", "<leader>m", function()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
        vim.treesitter.stop()
    else
        vim.cmd("syntax enable")
        vim.treesitter.start()
    end
end, { noremap = true, desc = "Toggle Linus syntax highlighting" })

vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>", { noremap = true, desc = "Move to window left" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { noremap = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>", { noremap = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>", { noremap = true, desc = "Move to window right" })
vim.keymap.set("n", "<C-`>", "<cmd>wincmd =<CR>", { noremap = true, desc = "Equalize windows" })

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

        local opts = { buffer = true }

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
