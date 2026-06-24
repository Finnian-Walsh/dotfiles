vim.opt.rtp:prepend(vim.uv.cwd())

require("init")
require("mini.test").setup {}

MiniTest.run_file("tests/mini_test.lua")
