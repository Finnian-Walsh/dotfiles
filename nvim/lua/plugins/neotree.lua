return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", 
  },
  lazy = false,
  config = function()
    require("neo-tree").setup{
      close_if_last_window = true,
      enable_git_status = true,
      window = {
        position = "right",
        width = 35,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        auto_close = true,
      },
      filesystem = {
        -- bind_to_cwd = true,
        find_by_git_root = true,
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "disabled",
        filtered_items = {
          visible = true,
        },
        use_libuv_file_watcher = false,
      },
    }
  end,
}
