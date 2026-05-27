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

_G.response_key_codes = {
    affirmative = {
        [89] = true, -- Y
        [121] = true, -- y
    },
    negative = {
        [78] = true, -- N
        [110] = true, -- n
    },
    abortive = {
        [67] = true, -- C
        [99] = true, -- c
        [27] = true, -- Esc
    },
}

-- stylua: ignore
_G.nav_keys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "!", "\"", "£", "$", "%", "^", "&", "*", "(", ")"
}

function _G.update_date()
    _G.current_date = os.date("*t")
    _G.current_month = current_date.month
    _G.current_day = current_date.day
    _G.current_week_day = current_date.wday

    if current_month == 12 then
        _G.days_until_xmas = 25 - current_day
    elseif current_month == 9 then
        _G.days_until_halloween = 31 - current_day
    end
end

update_date()

vim.keymap.set("t", "<S-Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set({ "n", "t" }, "<C-Q>", function()
    vim.cmd("confirm close")
end, { noremap = true })

vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch, { noremap = true, desc = "Turn highlight off" })

-- Automatic empty buffer deletion

local function auto_buffer_delete(buf)
    if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].filetype ~= "" then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines > 1 or lines[1] ~= "" then
        return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf and vim.api.nvim_win_get_config(win).relative ~= "" then
            return
        end
    end

    vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end)
end

vim.api.nvim_create_autocmd("BufHidden", {
    callback = function(args)
        auto_buffer_delete(args.buf)
    end,
})

-- Automatic tabline updation

local function schedule_tabline_redraw()
    vim.schedule(function()
        vim.cmd.redrawtabline()
    end)
end

vim.api.nvim_create_autocmd("BufLeave", {
    callback = schedule_tabline_redraw,
})

-- Miscellaneous keymaps

vim.keymap.set("n", "<leader>m", function()
    if vim.g.syntax_on then
        vim.cmd("syntax off")
        vim.treesitter.stop()
    else
        vim.cmd("syntax enable")
        vim.treesitter.start()
    end
end, { noremap = true, desc = "Toggle Linus syntax highlighting" })

vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<CR>", { noremap = true, desc = "Move to window left" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<CR>", { noremap = true, desc = "Move to window below" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<CR>", { noremap = true, desc = "Move to window above" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<CR>", { noremap = true, desc = "Move to window right" })
vim.keymap.set({ "n", "t" }, "<C-`>", "<cmd>wincmd =<CR>", { noremap = true, desc = "Equalize windows" })

vim.keymap.set("n", "<leader>Q", vim.cmd.restart, { noremap = true, desc = "Restart neovim" })

vim.keymap.set("n", "<leader>P", vim.pack.update, { desc = "Update plugins" })

-- File type autocmds
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove { "r" }
    end,
})

if current_month == 12 then
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            vim.cmd.LetItSnow()
        end,
    })
end
