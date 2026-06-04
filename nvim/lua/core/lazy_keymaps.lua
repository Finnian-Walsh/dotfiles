local M = {}
M.__index = M

---@param on_setup function? A function to be called on setup
function M.new(on_setup)
    return setmetatable({
        _keys = {},
        on_setup = on_setup,
    }, M)
end

---@param keymap_caller table? The keymap that is calling setup
---@return function The function of the keymap
function M:setup(keymap_caller)
    if self.on_setup then
        self.on_setup()
    end

    local caller_fn

    for _, keymap in ipairs(self._keys) do
        local fn = keymap.fn()
        if keymap == keymap_caller then
            caller_fn = fn
        end

        vim.keymap.set(keymap.mode, keymap.key, keymap.fn(), keymap.opts)
    end

    return caller_fn
end

---@param mode string|string[] The mode(s) that the key can be pressed in
---@param key string The key for the key mapping
---@param fn function A function that returns the keymap's function (not the keymap's function itself)
---@param opts table The keymap options
function M:add(mode, key, fn, opts)
    local keymap = { mode = mode, key = key, fn = fn, opts = opts }
    table.insert(self._keys, keymap)
    vim.keymap.set(mode, key, function()
        self:setup(keymap)()
    end, opts)
end

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
end

return M
