
local M = {}

function M.setup()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  vim.keymap.set("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>t", ":Neotree toggle<CR>", { noremap = true, silent = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
      vim.keymap.set("n", "<LocalLeader>cc", ":!cargo check<CR>", { buffer = 0, desc = "Cargo check command (debug)" })
      vim.keymap.set("n", "<LocalLeader>ccr", ":!cargo check --release<CR>", { buffer = 0, desc = "Cargo check command (release)" })
      vim.keymap.set("n", "<LocalLeader>cb", ":!cargo build<CR>", { buffer = 0, desc = "Cargo build command (debug)" })
      vim.keymap.set("n", "<LocalLeader>cbr", ":!cargo build --release<CR>", { buffer = 0, desc = "Cargo build command (release)" })
      vim.keymap.set("n", "<LocalLeader>cr", "!cargo run<CR>", { buffer = 0, desc = "Cargo run command (debug)" })
      vim.keymap.set("n", "<LocalLeader>crr", "!cargo run --release<CR>", { buffer = 0, desc = "Cargo run command (release)" })
    end,
  })
end

return M
