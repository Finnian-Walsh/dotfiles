local M = {}

function M.load(path)
    local ok, result = pcall(require, path)

    if ok then
        return result
    end

    vim.notify(("Failed to require `%s` with error:\n%s"):format(path, result), vim.log.levels.ERROR)
end

function M.setup(plugin_name)
    local plugin = M.load(plugin_name)

    if not plugin then
        return
    end

    local ok, result = pcall(plugin.setup, {})

    if ok then
        return result
    end

    vim.notify(("Failed to set up `%s` with error:\n%s"):format(plugin, result), vim.log.levels.ERROR)
end

return M
