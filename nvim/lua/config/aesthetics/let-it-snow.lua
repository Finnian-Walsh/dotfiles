local keymaps = require("core.lazy_keymaps").new(function()
    require("let-it-snow").setup {
        delay = 150,
    }
end)

keymaps:add("n", "<leader>S", function()
    return vim.cmd.LetItSnow
end, { desc = "Let it snow!" })

keymaps:cmd("LetItSnow")

if current_month ~= 12 then -- only necessary during December
    return
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(_)
        vim.cmd.LetItSnow()
    end,
})
