-- ButtonCreator implementation

local M = {}
M.__index = M

local function create_padding(value)
    return { type = "padding", val = value or 2 }
end

function M.new(opts)
    opts = opts or {}

    local self = setmetatable({
        _padding = create_padding(opts.padding),
        _buttons = {},
    }, M)

    if opts.buttons then
        self:add_all(opts.buttons)
    end

    return self
end

function M:add(name, key, fn)
    table.insert(self._buttons, {
        name = name,
        key = key,
        fn = fn,
    })
end

function M:add_all(buttons)
    for _, button in ipairs(buttons) do
        self:add(unpack(button))
    end
end

function M:build(text_width)
    local value = {}
    local padding = self._padding

    local square_brackets_width = vim.fn.strdisplaywidth("[]")

    for _, button in ipairs(self._buttons) do
        local button_name = button.name
        local button_key = button.key
        local button_fn = button.fn

        local spaces = text_width
            - (vim.fn.strdisplaywidth(button_name) + vim.fn.strdisplaywidth(button_key) + square_brackets_width)

        local button_val = button_name .. string.rep(" ", spaces) .. "[" .. button.key .. "]"

        table.insert(value, {
            on_press = button_fn,
            opts = {
                position = "center",
                cursor = vim.fn.strdisplaywidth(button_val) - 2,
                keymap = { "n", button.key, button_fn },
                hl = {
                    { "AlphaText", 0, #button_name },
                    { "AlphaBracket", #button_val - 3, #button_val - 2 },
                    { "AlphaShortcut", #button_val - 2, #button_val - 1 },
                    { "AlphaBracket", #button_val - 1, #button_val },
                },
            },
            type = "button",
            val = button_val,
        })
        table.insert(value, padding)
    end

    return {
        type = "group",
        val = value,
    }
end

return M
