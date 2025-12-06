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

vim.diagnostic.config{
    virtual_text = true,
}

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, desc = "Turn highlight off" })

vim.keymap.set("n", "<leader>A", "<cmd>Alpha<CR>", { desc = "Toggle Alpha" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Open Mason" })

local function find_listed_buffer()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buflisted then
            return buf
        end
    end
end

local function toggle_bufferline()
    vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
end

vim.keymap.set("n", "<leader>B", toggle_bufferline, { noremap = true, desc = "Toggle bufferline" })

vim.api.nvim_create_user_command("ToggleBufferline", toggle_bufferline, { desc = "Toggle bufferline" })

vim.keymap.set("n", "<leader>]", function()
    if find_listed_buffer() then
        vim.cmd("bnext " .. vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Next buffer " })

vim.keymap.set("n", "<leader>[", function()
    if find_listed_buffer() then
        vim.cmd("bprev " .. vim.v.count1)
    else
        vim.api.nvim_echo({{"There are no buffers", "ErrorMsg"}}, true, {})
    end
end, { noremap = true, desc = "Previous buffer "})

vim.keymap.set("n", "<leader>bd", function()
    for _ = 1, vim.v.count1 do
        vim.api.nvim_buf_delete(0, {})
    end
end, { noremap = true, desc = "Close buffer"})

vim.keymap.set("n", "<leader>b!d", function()
    for _ = 1, vim.v.count1 do
        vim.api.nvim_buf_delete(0, { force = true })
    end
end, { noremap = true, desc = "Close buffer"})

vim.keymap.set("n", "<leader>bo", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current then
            vim.api.nvim_buf_delete(buf, {})
        end
    end
end, { noremap = true, desc = "Close all buffers"})

vim.keymap.set("n", "<leader>b!o", function()
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end, { noremap = true, desc = "Close all buffers"})

vim.keymap.set("n", "<leader>bD", "<cmd>bufdo bd<CR>", { noremap = true, desc = "Close all buffers"})
vim.keymap.set("n", "<leader>b!D", "<cmd>bufdo bd!<CR>", { noremap = true, desc = "Close all buffers"})

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

vim.keymap.set("n", "<leader><Tab>n", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew")
    end
end, { noremap = true, desc = "Open a new tab" })

vim.keymap.set("n", "<leader><Tab>N", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabnew | tabmove -1")
    end
end, { noremap = true, desc = "Open a new tab to the left" })

vim.keymap.set("n", "<leader>}", "gt", { noremap = true, desc = "Next tab ", silent = true, })

vim.keymap.set("n", "<leader>{", "gT", { noremap = true, desc = "Previous tab ", silent = true, })

vim.keymap.set("n", "<leader><Tab>d", function()
    for _ = 1, vim.v.count1 do
        vim.cmd("tabclose")
    end
end, { noremap = true, desc = "Close tab"})

vim.keymap.set("n", "<leader><Tab>o", "<cmd>tabonly<CR>", { noremap = true, desc = "Close all tabs except the current one"})

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

vim.keymap.set("n", "<leader><S-Right>", function()
    local count = vim.v.count1
    if current_tab_can_move(count) then
        vim.cmd("tabmove +" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab +" .. count, "ErrorMsg" }}, true, {})
    end
end, { desc = "Move the tab right" })

vim.keymap.set("n", "<leader><S-Left>", function()
    local count = vim.v.count1
    if current_tab_can_move(-count) then
        vim.cmd("tabmove -" .. count)
    else
        vim.api.nvim_echo({{ "Cannot move tab -" .. count, "ErrorMsg" }}, true, {})
    end
end, { desc = "Move the tab left" })

_G.nav_keys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "!", "\"", "£", "$", "%", "^", "&", "*", "(", ")"
}

for i = 1, 20 do
    local command = "<cmd>tabnext " .. i .. "<CR>"
    local opts = { noremap = true, desc = "Go to tab " .. i}
    local navigation_key = nav_keys[i]
    vim.keymap.set("n", "<leader><Tab>" .. navigation_key, command, opts)
end

local function auto_buffer_delete(buf)
    if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].filetype ~= "" then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines > 1 or lines[1] ~= "" then
        return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf
            and vim.api.nvim_win_get_config(win).relative ~= "" then
            return
        end
    end

    vim.schedule(function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end)
end

vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(args)
        auto_buffer_delete(args.buf)
    end,
})

local function schedule_tabline_redraw()
    vim.schedule(function()
        vim.cmd("redrawtabline")
    end)
end

vim.api.nvim_create_autocmd("BufLeave", {
    callback = schedule_tabline_redraw,
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
        local opts = { buffer = true }

        vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format{ async = true }
        end, opts)

        vim.keymap.set("n", "<leader>gf", function()
            local file_changes = {{ "Open files have changes:", "ErrorMsg" }}

            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_get_option(buf, "modified") then
                    table.insert(file_changes, { "\n" .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."), "Normal" })
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

            vim.fn.system{"cargo", "fmt"}
            vim.cmd("edit")
        end, opts)

        vim.keymap.set("n", "<leader>`", function() vim.cmd("e Cargo.toml") end, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "norg",
    callback = function()
        vim.b.completion = false
    end
})
