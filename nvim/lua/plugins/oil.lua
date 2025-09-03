return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup{
      show_hidden = true,
      devicons = {
        icons = require("nvim-web-devicons").get_icons(),
      }
    }

    vim.keymap.set("n", "<Leader>t", require("oil").open, { desc = "Open oil" })
  end,
  lazy = false,
}
