local M = {}
M.__index = M

---@param on_setup function? A function to be called on setup
function M.new(on_setup)
    return setmetatable({
        _keys = {},
        on_setup = on_setup,
        setup_called = false,
    }, M)
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

    if self.on_setup then
        local ok, err = pcall(self.on_setup)

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

    return target_callback
end

---@param mode string|string[] The mode(s) that the key can be pressed in
---@param key string The key for the key mapping
---@param fn function A function that returns the keymap's function (not the keymap's function itself)
---@param opts table The keymap options
---@return self To allow chaining
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
---@return self To allow chaining
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
