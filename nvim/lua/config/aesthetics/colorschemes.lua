local unloaded = {
    nightfall = function()
        require("nightfall").setup {}
    end,
}

local group = vim.api.nvim_create_augroup("ColorSchemeLazyLoading", {})

vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = group,
    callback = function(event)
        local match = event.match
        local corresponding = unloaded[match]

        if corresponding then
            unloaded[match] = nil

            local iter, state, key = pairs(unloaded)
            if not iter(state, key) then
                vim.api.nvim_clear_autocmds { group = group }
            end

            corresponding()
        end
    end,
})
