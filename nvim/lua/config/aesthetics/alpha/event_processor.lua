local M = {}

---@class Event
---@field current_date osdate
---@field total_seconds integer The total seconds remaining
---@field total_minutes integer The total minutes remaining
---@field total_hours integer The total hours remaining
---@field total_days integer The total hours remaining
---@field total_months integer The total months remaining
---@field total_years integer The total years remaining
---@field component_seconds integer The component seconds remaining
---@field component_minutes integer The component minutes remaining
---@field component_hours integer The component hours remaining
---@field component_days integer The component days remaining
---@field component_months integer The component months remaining
---@field component_years integer The component years remaining
---@field display fun(self): string[][]

function M:total_seconds()
    return os.time(self.event_date) - os.time(self.current_date)
end

function M:total_minutes()
    return math.floor(self.total_seconds / 60)
end

function M:total_hours()
    return math.floor(self.total_seconds / 3600)
end

function M:total_days()
    return math.floor(self.total_seconds / 86400)
end

function M:total_months()
    return self.total_years * 12 + self.event_date.month - self.current_date.month
end

function M:total_years()
    return self.event_date.year - self.current_date.year
end

function M:component_seconds()
    return (self.total_seconds % 60)
end

function M:component_minutes()
    return (self.total_seconds % 3600) / 60
end

function M:component_hours()
    return (self.total_seconds % 86400) / 3600
end

function M:component_days()
    -- TODO: finish ts
    return self.total_days
end

function M:component_months()
    return (self.event_date.month - self.current_date.month) % 12
end

function M:component_years()
    local current_date, event_date = self.current_date, self.event_date
    local current_month, event_month = current_date.month, event_date.month

    if current_month > event_month or (current_month == event_month and current_date.day > event_date.day) then
        return self.total_years - 1
    end

    return self.total_years
end

function M.display(_)
    return function(self)
        local lines = {}

        for _, value in ipairs(self.text) do
            local substituted_value = value:gsub("%[([^%]]+)%]", function(pattern)
                return self[pattern]
            end)

            table.insert(lines, { substituted_value, center = true })
        end

        return lines
    end
end

---@param date osdateparam
---@param text string[]
---@return Event
function M.new(date, text)
    return setmetatable({
        current_date = os.date("*t"),
        event_date = date,
        text = text,
    }, {
        __index = function(self, key)
            local fn = M[key]

            if fn then
                local value = fn(self)
                self[key] = value
                return value
            end
        end,
    })
end

return M
