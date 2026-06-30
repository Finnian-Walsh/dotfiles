local cwd = vim.uv.cwd()

if vim.uv.fs_stat(cwd .. "/tests") then
    vim.opt.rtp:prepend(cwd)
else
    error(("Cannot run tests (wrong cwd: %s)"):format(cwd))
end

require("init")
require("mini.test").setup {}

MiniTest.run_file("tests/mini_test.lua")
