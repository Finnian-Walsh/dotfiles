-- vim.pack.add(require("plugins.spec"))

local ok = true
local err

local function load(path)
    local require_ok, result = pcall(require, path)

    if require_ok then
        return result
    end

    vim.notify(("Failed to require `%s` with error:\n%s"):format(path, result), vim.log.levels.ERROR)
    ok = false
    err = err or result
end

local function setup(plugin_name)
    local plugin = load(plugin_name)

    if not plugin then
        return
    end

    local setup_ok, result = pcall(plugin.setup, {})

    if setup_ok then
        return result
    end

    vim.notify(("Failed to set up `%s` with error:\n%s"):format(plugin, result), vim.log.levels.ERROR)
    ok = false
    err = err or result
end

load("plugins.lspconfig")
load("plugins.snacks")
load("plugins.autopairs")
load("plugins.blinkv1")
load("plugins.bufferline")
load("plugins.colorschemes")
load("plugins.gitsigns")
load("plugins.hooker")
load("plugins.let-it-snow")
setup("lualine")
load("plugins.mini")
load("plugins.neorg")
load("plugins.nvim-dap")
load("plugins.peek")
load("plugins.plugin-view")
load("plugins.todo-comments")
load("plugins.tohtml")
load("plugins.which-key")
load("plugins.winresize")

return { ok = ok, err = err }
