-- HeaderValues implementation

local M = {}

function M.__index(self, key)
    if key == "selected" then
        -- ensure that there is no recursive chain if the object has been tampered with
        return rawget(self, "_headers")[rawget(self, "_selected_index")]
    else
        return M[key]
    end
end

function M.new(listed_values)
    local ordered_values = {}
    local references = {}

    for index, value in pairs(listed_values) do
        ordered_values[#ordered_values + 1] = {
            name = value.name,
            text = value.text,
            width = vim.fn.strdisplaywidth(value.text[1]),
        }

        references[value.name] = index
    end

    return setmetatable({
        _headers = ordered_values,
        _references = references,
    }, M)
end

function M:select(name)
    self._selected_index = self._references[name]
    -- print(self._references[name])
end

function M:select_next()
    local new_index = self._selected_index + 1

    if new_index > #self._headers then
        new_index = 1
    end

    self._selected_index = new_index
end

function M:select_previous()
    local new_index = self._selected_index - 1

    if new_index <= 0 then
        new_index = #self._headers
    end

    self._selected_index = new_index
end

local function center_text(text, required_width)
    local text_width = vim.fn.strdisplaywidth(text)
    local missing_width = required_width - text_width
    local first_half = math.floor(missing_width / 2)
    local second_half = math.ceil(missing_width / 2)

    return string.rep(" ", first_half) .. text .. string.rep(" ", second_half)
end

function M:add_extensions(extensions)
    for _, header in ipairs(self._headers) do
        local text = header.text
        local header_width = vim.fn.strdisplaywidth(text[1])

        for _, addition in ipairs(extensions) do
            if addition.center then
                text[#text + 1] = center_text(addition[1], header_width)
            else
                text[#text + 1] = addition[1]
            end
        end
    end
end

return M
