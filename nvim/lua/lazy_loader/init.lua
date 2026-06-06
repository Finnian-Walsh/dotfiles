local M = {}
M.__index = M

local InitializationState = setmetatable({
    UNSTARTED = 0,
    SETUP_COMPLETE = 1,
    FULLY_COMPLETE = 2,
}, {
    __newindex = function()
        error("InitializationState is immutable")
    end,

    __index = function(_, key)
        error(("Variant %s does not exist"):format(key))
    end,
})

---@param on_setup function? A function to be called on setup
---@param name string? The name of the system
function M.new(on_setup, name)
    local self = setmetatable({
        _keys = {},
        _initialization_state = InitializationState.UNSTARTED,
        on_setup = on_setup,
    }, M)

    if name then
        self._load_autocmd_id = vim.api.nvim_create_autocmd("User", {
            pattern = ("Load%s"):format(name),
            callback = function()
                self:ensure_initialized()
            end,
        })
    end

    return self
end

---@param keymap_caller table? The keymap that is calling setup
---@param skip_setup boolean? Whether setup should be mandatorily skipped
---@return function The function of the keymap
function M:setup(keymap_caller, skip_setup)
    if self.on_setup and not skip_setup then
        self.on_setup()
    end

    self._initialization_state = InitializationState.SETUP_COMPLETE

    if self._load_autocmd_id then
        vim.api.nvim_del_autocmd(self._load_autocmd_id)
        self._load_autocmd_id = nil
    end

    local caller_fn

    for _, keymap in ipairs(self._keys) do
        local fn = keymap.fn()
        if keymap == keymap_caller then
            caller_fn = fn
        end

        vim.keymap.set(keymap.mode, keymap.key, keymap.fn(), keymap.opts)
    end

    self._initialization_state = InitializationState.FULLY_COMPLETE

    return caller_fn
end

function M:ensure_initialized()
    if self._initialization_state == InitializationState.FULLY_COMPLETE then
        return
    elseif self._initialization_state == InitializationState.SETUP_COMPLETE then
        self:setup(nil, true)
    elseif self._initialization_state == InitializationState.UNSTARTED then
        self:setup()
    end
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
        self:setup(keymap)()
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
