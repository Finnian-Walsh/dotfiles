local unpack = table.unpack or unpack

local DirectionValue = {}

function DirectionValue.new(identifier, advance, invert)
    return setmetatable({
        _identifier = identifier,
        advance = advance,
        invert = invert,
    }, DirectionValue)
end

function DirectionValue.__eq(this, other)
    return this._identifier == other._identifier
end

local Direction = {}

Direction.Left = DirectionValue.new(
    1,
    function(pos)
        return { pos[1] - 1, pos[2] }
    end,
    function()
        return Direction.Right
    end
)

Direction.Down = DirectionValue.new(
    2,
    function(pos)
        return { pos[1], pos[2] + 1 }
    end,
    function()
        return Direction.Up
    end
)

Direction.Up = DirectionValue.new(
    3,
    function(pos)
        return { pos[1], pos[2] - 1 }
    end,
    function()
        return Direction.Down
    end
)

Direction.Right = DirectionValue.new(
    4,
    function(pos)
        return { pos[1] + 1, pos[2] }
    end,
    function()
        return Direction.Left
    end
)

setmetatable(Direction, {
    __newindex = function()
        error("Direction enum is read-only")
    end
})

local Block = {}
Block.__index = {}

function Block.new(x, y, prev, next)
    return setmetatable({
        prev = prev,
        next = next,
        position = { x, y },
    }, Block)
end

local function snake(opts)
    local args = opts.fargs

    if #args > 2 then
        vim.api.nvim_echo({
            { "Unknown option: " .. args[3], "ErrorMsg" },
        }, true, {})
    end

    local difficulty = args[1] or "normal"
    local game_size = args[2] or "medium"

    local waiting_time_ms

    if difficulty == "easy" then
        waiting_time_ms = 800
    elseif difficulty == "normal" then
        waiting_time_ms = 600
    elseif difficulty == "hard" then
        waiting_time_ms = 400
    end

    local game_width, game_height

    if game_size == "small" then
        game_width, game_height = 10, 10
    elseif game_size == "medium" then
        game_width, game_height = 15, 15
    elseif game_size == "large" then
        game_width, game_height = 20, 20
    end

    local buf = vim.api.nvim_create_buf(false, true) -- listed, scratch
    vim.api.nvim_set_current_buf(buf)

    -- use a table for the snake body
    -- change the direction when keys are pressed

    local direction = Direction.Right
    local buffer_local = { buffer = buf }

    local function turn_left()
        print("left")
        direction = Direction.left
    end

    local function turn_down()
        print("down")
        direction = Direction.Down
    end

    local function turn_up()
        print("up")
        direction = Direction.Up
    end

    local function turn_right()
        print("right")
        direction = Direction.Right
    end

    vim.keymap.set("n", "h", turn_left, buffer_local)
    vim.keymap.set("n", "j", turn_down, buffer_local)
    vim.keymap.set("n", "k", turn_up, buffer_local)
    vim.keymap.set("n", "l", turn_right, buffer_local)

    vim.keymap.set("n", "a", turn_left, buffer_local)
    vim.keymap.set("n", "s", turn_down, buffer_local)
    vim.keymap.set("n", "w", turn_up, buffer_local)
    vim.keymap.set("n", "d", turn_right, buffer_local)

    vim.keymap.set("n", "<Left>", turn_left, buffer_local)
    vim.keymap.set("n", "<Down>", turn_down, buffer_local)
    vim.keymap.set("n", "<Up>", turn_up, buffer_local)
    vim.keymap.set("n", "<Right>", turn_right, buffer_local)

    local BODY_LENGTH = 3

    local opposite_dir = direction.invert()
    local head = Block.new(5, 5)
    local tail = head

    for _ = 2, BODY_LENGTH do
        local current = Block.new(unpack(opposite_dir.advance(tail.position)))
        current.prev = tail
        tail.next = current
        tail = current
    end

    math.randomseed(os.time())
end

vim.api.nvim_create_user_command("Snake", snake, {
    nargs = "*",
})

