vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-Up>", ":resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-S-Up>", ":resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Down>", ":resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -1<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-`>", ":wincmd =<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.keymap.set("n", "<LocalLeader>fmt", function()
      if vim.api.nvim_buf_get_option(0, "modified") then
        error("Open files have changes")
      end

      vim.cmd("!cargo fmt")
      vim.cmd("edit")
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>`", function() vim.cmd("e Cargo.toml") end)
  end,
})

