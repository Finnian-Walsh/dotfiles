local loader = require("lazy_loader").new(function()
    require("let-it-snow").setup {
        delay = 150,
    }
end)

loader:map("n", "<leader>S", function()
    return vim.cmd.LetItSnow
end, { desc = "Let it snow!" })

loader:cmd("LetItSnow")

if current_month ~= 12 then -- only necessary during December
    return
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(_)
        vim.cmd.LetItSnow()
    end,
})
