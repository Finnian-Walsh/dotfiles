
if vim.env.ZELLIJ_SESSION_NAME == nil then
  vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })
  return {}
end

return {
  "swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>",  { silent = true, desc = "navigate left or tab"  } },
    { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down"  } },
    { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up"    } },
    { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
  },
  opts = {},
}
