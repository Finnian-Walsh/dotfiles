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
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(event)
        vim.opt.formatoptions:remove { "r", "o" }

        local o_active = false

        vim.keymap.set("n", "<leader>lc", function()
            if o_active then
                vim.opt_local.formatoptions:remove("o")
                o_active = false
                vim.notify("Off", vim.log.levels.INFO)
            else
                o_active = true
                vim.opt_local.formatoptions:append("o")
                vim.notify("On", vim.log.levels.INFO)
            end
        end, { buf = event.buf })
    end,
})

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

vim.keymap.set({ "n", "t", "v" }, "<S-Space>", "<Space>", { remap = true })
vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-q>", "<cmd>confirm close<CR>", { desc = "Close current terminal" })
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch, { desc = "Turn highlight off" })

-- General keymaps

-- wincmd shortcuts
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<CR>", { desc = "Move to window left" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<CR>", { desc = "Move to window below" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<CR>", { desc = "Move to window above" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<CR>", { desc = "Move to window right" })
vim.keymap.set({ "n", "t" }, "<C-`>", "<cmd>wincmd =<CR>", { desc = "Equalize windows" })

vim.keymap.set("n", "<leader>Q", function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].modified then
            vim.cmd("confirm bwipe" .. buf)
        elseif vim.bo[buf].buftype == "terminal" then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    vim.cmd.restart()
end, { desc = "Restart neovim" })

vim.keymap.set("n", "<leader>y", "<cmd>!tokei<CR>", { desc = "Run tokei" })
