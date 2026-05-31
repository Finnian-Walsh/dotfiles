if current_month ~= 12 then -- only necessary during December
    return
end

require("let-it-snow").setup {
    delay = 150,
}

vim.keymap.set("n", "<leader>S", vim.cmd.LetItSnow, { desc = "Let it snow!" })

vim.api.nvim_create_autocmd("BufEnter", {
    callback = vim.cmd.LetItSnow,
})
