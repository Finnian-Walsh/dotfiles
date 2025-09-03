local M = {}

function M.setup()
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.cursorline = true
end

return M
