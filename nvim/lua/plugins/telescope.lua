return {
  "nvim-telescope/telescope.nvim", tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup{
      defaults = {
        
      }
    }
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<Leader>/", builtin.live_grep, { desc = "Live grep with telescope" })
  end,
  lazy = false,
}
