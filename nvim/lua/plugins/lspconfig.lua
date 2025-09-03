return {
  "neovim/nvim-lspconfig",
  config = function()    
    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup{
    	settings = {
    		["rust-analyzer"] = {
    			cargo = { allFeatures = true },
          checkOnSave = true,
    			check = { command = "clippy" },
    		},
    	}
    }

  end,
}
