vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename a variable" })
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

vim.keymap.set("n", "gnd", function()
    vim.cmd("vs | wincmd l")
    vim.lsp.buf.definition()
end, { desc = "Go to definition in a new buffer" })

vim.keymap.set("n", "gNd", function()
    vim.cmd("sp | wincmd j")
    vim.lsp.buf.definition()
end, { desc = "Go to definition in a new buffer" })

vim.keymap.set("n", "gnD", function()
    vim.cmd("vs | wincmd l")
    vim.lsp.buf.declaration()
end, { desc = "Go to declaration in a new buffer" })

vim.keymap.set("n", "gNd", function()
    vim.cmd("sp | wincmd j")
    vim.lsp.buf.declaration()
end, { desc = "Go to definition in a new buffer" })
