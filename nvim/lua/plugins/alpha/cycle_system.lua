-- Cycle System implementation

local M = {}
M.__index = M

function M.new(items, interval, reset, fn)
    return setmetatable({
        items = items,
        reset = reset,
        fn = fn,
        _running = false,
        _index = 1,
        _last_used = 0,
        _cooldown = 1 + interval,
        _interval = interval,
    }, M)
end

function M:is_running()
    return self._running
end

local function epoch_ms()
    return vim.loop.hrtime() / 1e6
end

function M:start()
    local time = epoch_ms()

    if self._running or self._last_used + self._cooldown > time then
        return
    end

    self._running = true
    self._last_used = time

    self:_next()
end

function M:_next()
    if not self._running then
        return
    end

    local new_index = self._index % #self.items + 1
    self._index = new_index
    self.fn(self.items[new_index])

    vim.defer_fn(function()
        self:_next()
    end, self._interval)
end

function M:stop()
    local time = epoch_ms()

    if not self._running then
        return
    end

    self._running = false
    self._last_used = time + self._cooldown

    vim.defer_fn(function()
        self.reset()
    end, self._cooldown)
end

function M:toggle()
    if self._running then
        self:stop()
    else
        self:start()
    end
end

return M
