local M = {}
M.__index = M

---@class LazyLoaderOptions
---@field callback function?
---@field keymaps any[][]?
---@field cmds string[]?
---@field autocmds string[]?

local plugin_number = 1

---@param opts LazyLoaderOptions? The options
function M.new(opts)
    opts = opts or {}

    local self = setmetatable({
        _keys = {},
        _augroup = vim.api.nvim_create_augroup("lazy-loader-" .. plugin_number, {}),
        callback = opts.callback,
        setup_called = false,
    }, M)

    plugin_number = plugin_number + 1

    if opts.keymaps then
        for _, keymap in ipairs(opts.keymaps) do
            self:map(unpack(keymap))
        end
    end

    if opts.cmds then
        for _, cmd in ipairs(opts.cmds) do
            self:cmd(cmd)
        end
    end

    if opts.autocmds then
        local autocmd_group = self._augroup
        for _, autocmd in ipairs(opts.autocmds) do
            vim.api.nvim_create_autocmd(autocmd, {
                once = true,
                group = autocmd_group,
                callback = function()
                    self:setup()
                end,
            })
        end
    end

    return self
end

function M:__call()
    if self.setup_called then
        return
    end

    self:setup()
end

---@param keymap_caller table? The keymap that is calling setup
---@return function The function of the keymap
function M:setup(keymap_caller)
    self.setup_called = true

    if self.callback then
        local ok, err = pcall(self.callback)

        if not ok then
            vim.notify("Failed to call setup function with error\n" .. err, vim.log.levels.ERROR)
        end
    end

    local target_callback

    for _, keymap in ipairs(self._keys) do
        local callback = keymap.fn()
        if keymap == keymap_caller then
            target_callback = callback
        end

        vim.keymap.set(keymap.mode, keymap.key, callback, keymap.opts)
    end

    vim.api.nvim_del_augroup_by_id(self._augroup)

    return target_callback
end

---@param mode string|string[] The mode(s) that the key can be pressed in
---@param key string The key for the key mapping
---@param fn function A function that returns the keymap's function (not the keymap's function itself)
---@param opts table The keymap options
---@return self self allow chaining
function M:map(mode, key, fn, opts)
    local keymap = { mode = mode, key = key, fn = fn, opts = opts }
    table.insert(self._keys, keymap)
    vim.keymap.set(mode, key, function()
        local callback = self:setup(keymap)

        if type(callback) == "function" then
            callback()
        elseif type(callback) == "string" then
            vim.api.nvim_feedkeys(vim.keycode(callback), "t", false)
        else
            vim.notify("Invalid callback", vim.log.levels.ERROR)
        end
    end, opts)

    return self
end

---@param name string The name of the command
---@return self self To allow chaining
function M:cmd(name)
    vim.api.nvim_create_user_command(name, function(opts)
        self:setup()

        local cmd = {
            cmd = name,
            args = opts.fargs,
            bang = opts.bang,
            mods = opts.smods,
            range = opts.range > 0 and { opts.line1, opts.line2 } or nil,
        }

        if opts.count ~= -1 then
            cmd.count = opts.count
        end

        vim.api.nvim_cmd(cmd, {})
    end, {
        nargs = "*",
        range = true,
    })

    return self
end

return M
