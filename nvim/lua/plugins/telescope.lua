return {
  "nvim-telescope/telescope.nvim", tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup{
      defaults = {
        
      }
    }
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find files with telescope" })
    vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Live grep with telescope" })
  end,
  lazy = false,
}
