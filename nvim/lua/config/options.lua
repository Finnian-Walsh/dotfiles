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

vim.keymap.set("n", "<C-`>", ":wincmd =<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.keymap.set("n", "<localleader>fmt", function()
      if vim.api.nvim_buf_get_option(0, "modified") then
        error("Open files have changes")
      end

      vim.cmd("!cargo fmt")
      vim.cmd("edit")
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>`", function() vim.cmd("e Cargo.toml") end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()

    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({"o"})
    end,
})
