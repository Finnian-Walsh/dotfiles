local DirectionValue = {}

function DirectionValue.new(identifier, advance, invert)
    local self = setmetatable({
        _identifier = identifier,
        advance = advance,
        invert = invert,
    }, DirectionValue)
end

function DirectionValue.__eq(this, other)
    return this._identifier == other._identifier
end

local Direction = setmetatable({}, {
    __newindex = function()
        error("Direction enum is read-only")
    end
})

Direction.Left = DirectionValue(
    1,
    function(pos)
        return { pos[1] - 1, pos[2] }
    end,
    function()
        return Direction.Right
    end
)

Direction.Down = DirectionValue(
    2,
    function(pos)
        return { pos[1], pos[2] + 1 }
    end,
    function()
        return Direction.Up
    end
)

Direction.Up = DirectionValue(
    3,
    function(pos)
        return { pos[1], pos[2] - 1 }
    end,
    function()
        return Direction.Down
    end
)

Direction.Right = DirectionValue(
    4,
    function(pos)
        return { pos[1] + 1, pos[2] }
    end,
    function()
        return Direction.Left
    end
)

local Block = {}
Block.__index = {}



local function snake(args)
    local difficulty

    local buf = vim.api.nvim_create_buf(false, true) -- listed, scratch
    vim.api.nvim_set_current_buf(buf)

    -- use a table for the snake body
    -- change the direction when keys are pressed

    math.randomseed(os.time())

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

    local function prev_block(block, dir, count)
        count = count or 1

        local new_block = dir.advance(block)
        new_block.next = block

        if count > 1 then
            block.prev = prev_block(block, dir, count - 1)
        end

        return new_block
    end

    local opposite_dir = direction:invert()
    local tail = Block.new(5, 5, direction)
    local BODY_LENGTH = 3
    local current = tail

    for i = 2, BODY_LENGTH do
        local new = current:advance()
        new.direction = current.direction
    end

end

vim.api.nvim_create_user_command("Snake", snake, {
    nargs = "*",
})
