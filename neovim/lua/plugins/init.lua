local configuration_functions = {}

local err

local plugins = {}

local function create_options_handler(opts)
    return function()
        for plugin, options in pairs(opts) do
            require(plugin).setup(options)
        end
    end
end

local function load(path)
    local ok, result = pcall(function()
        local object = require(path)

        if not object then
            return
        end

        if object.plugins then
            vim.list_extend(plugins, object.plugins)
        end

        if object.lazy then
            require("lazy_loader").new {
                callback = function()
                    if object.opts then
                        create_options_handler(object.opts)()
                    end

                    if object.config then
                        object.config()
                    end
                end,
                keymaps = object.keys,
                cmds = object.cmds,
                autocmds = object.autocmds,
            }
        else
            if object.opts then
                configuration_functions[#configuration_functions + 1] = create_options_handler(object.opts)
            end

            if object.config then
                configuration_functions[#configuration_functions + 1] = object.config
            end
        end

        if object.modules then
            for _, module in ipairs(object.modules) do
                load(path .. "." .. module)
            end
        end
    end)

    if ok then
        return
    end

    vim.notify(("Failed to load `%s` with error:\n%s"):format(path, result), vim.log.levels.ERROR)

    -- A dead configuration function shouldn't have been added should the pcall fail
    err = err or result
end

load("plugins.lsp")
load("plugins.snacks")
load("plugins.autopairs")
load("plugins.emoji")
load("plugins.blinkv1")
load("plugins.bufferline")
load("plugins.colorschemes")
load("plugins.gitsigns")
load("plugins.hooker")
load("plugins.let-it-snow")
load("plugins.lualine")
load("plugins.mini.files")
load("plugins.mini.surround")
load("plugins.neorg")
load("plugins.nvim-dap")
load("plugins.peek")
load("plugins.plugin-view")
load("plugins.todo-comments")
load("plugins.tohtml")
load("plugins.which-key")
load("plugins.winresize")

vim.pack.add(plugins)

for _, fn in ipairs(configuration_functions) do
    local ok, result = pcall(fn)

    if not ok then
        err = err or result
        vim.notify(result, vim.log.levels.ERROR)
    end
end

return { ok = err == nil, err = err }
