vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-Up>", ":resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-`>", ":wincmd =<CR>", { noremap = true, silent = true })

if vim.env.ZELLIJ_SESSION_NAME == nil then
  vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.keymap.set("n", "<LocalLeader>c", ":!cargo check<CR>", { buffer = 0, desc = "Cargo check command (debug)" })
    vim.keymap.set("n", "<LocalLeader>cr", ":!cargo check --release<CR>", { buffer = 0, desc = "Cargo check command (release)" })
    vim.keymap.set("n", "<LocalLeader>b", ":!cargo build<CR>", { buffer = 0, desc = "Cargo build command (debug)" })
    vim.keymap.set("n", "<LocalLeader>br", ":!cargo build --release<CR>", { buffer = 0, desc = "Cargo build command (release)" })
    vim.keymap.set("n", "<LocalLeader>r", ":!cargo run<CR>", { buffer = 0, desc = "Cargo run command (debug)" })
    vim.keymap.set("n", "<LocalLeader>rr", ":!cargo run --release<CR>", { buffer = 0, desc = "Cargo run command (release)" })
    vim.keymap.set("n", "<LocalLeader>fmt", function()
      if vim.api.nvim_buf_get_option(0, "modified") then
        error("Open files have changes")
      end

      vim.cmd("!cargo fmt")
      vim.cmd("edit")
    end, { noremap = true, silent = true })
  end,
})

