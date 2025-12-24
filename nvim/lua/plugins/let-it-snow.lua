if current_month ~= 12 then -- only necessary during December
    return {}
end

return {
    "marcussimonsen/let-it-snow.nvim",
    cmd = "LetItSnow",
    config = function ()
        local let_it_snow = require("let-it-snow")
        let_it_snow.setup{
            delay = 100,
        }
        vim.keymap.set("n", "<leader>S", let_it_snow.let_it_snow, { desc = "Let it snow!" })
    end
}
