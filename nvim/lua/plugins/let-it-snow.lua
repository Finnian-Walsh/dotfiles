if current_month ~= 12 then -- only necessary during December
    return {}
end

return {
    "marcussimonsen/let-it-snow.nvim",
    cmd = "LetItSnow",
    opts = {
        delay = 150,
    },
}
