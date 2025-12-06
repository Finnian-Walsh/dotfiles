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
        return pos[1] - 1, pos[2]
    end,
    function()
        return Direction.Right
    end
)

Direction.Down = DirectionValue.new(
    2,
    function(pos)
        return pos[1], pos[2] + 1
    end,
    function()
        return Direction.Up
    end
)

Direction.Up = DirectionValue.new(
    3,
    function(pos)
        return pos[1], pos[2] - 1
    end,
    function()
        return Direction.Down
    end
)

Direction.Right = DirectionValue.new(
    4,
    function(pos)
        return pos[1] + 1, pos[2]
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
    else
        vim.api.nvim_echo({{"Unknown difficulty: " .. difficulty, "ErrorMsg"}}, true, {})
        return
    end

    local game_width, game_height

    if game_size == "small" then
        game_width, game_height = 45, 18
    elseif game_size == "medium" then
        game_width, game_height = 55, 22
    elseif game_size == "large" then
        game_width, game_height = 60, 30
    else
        vim.api.nvim_echo({{"Unknown game size: " .. game_size}}, true, {})
        return
    end

    local buffer_width, buffer_height = game_width, game_height + 1
    local buf = vim.api.nvim_create_buf(false, true) -- listed, scratch
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = buffer_width,
        height = buffer_height,
        row = math.floor((vim.o.lines - buffer_height) / 2),
        col = math.floor((vim.o.columns - buffer_width) / 2),
        style = "minimal",
        border = "single",
    })
    -- vim.api.nvim_buf_set_option(buf, "modifiable", false)

    -- use a table for the snake body
    -- change the direction when keys are pressed

    local direction = Direction.Right
    local buffer_local = { buffer = buf }

    local log_direction_changes = false
    local turn_left, turn_down, turn_up, turn_right

    if log_direction_changes then
        function turn_left()
            print("left")
            direction = Direction.left
        end

        function turn_down()
            print("down")
            direction = Direction.Down
        end

        function turn_up()
            print("up")
            direction = Direction.Up
        end

        function turn_right()
            print("right")
            direction = Direction.Right
        end
    else
        function turn_left()
            direction = Direction.left
        end

        function turn_down()
            direction = Direction.Down
        end

        function turn_up()
            direction = Direction.Up
        end

        function turn_right()
            direction = Direction.Right
        end
    end

    for _, keys in ipairs({
        { "h", "j", "k", "l", },
        { "a", "s", "w", "d", },
        { "<Left>", "<Down>", "<Up>", "<Right>", },
    }) do
        vim.keymap.set("n", keys[1], turn_left, buffer_local)
        vim.keymap.set("n", keys[2], turn_down, buffer_local)
        vim.keymap.set("n", keys[3], turn_up, buffer_local)
        vim.keymap.set("n", keys[4], turn_right, buffer_local)
    end

    local game_active = true

    local function confirm_quit()
        print("Are you sure you would like to quit? (Enter y/n): ")
        local char = string.char(vim.fn.getchar()):lower()

        if char == "y" then
            vim.api.nvim_win_close(win, false)
            game_active = false
        elseif char == "n" then
            return
        end
    end

    vim.keymap.set("n", "q", confirm_quit, buffer_local)
    vim.keymap.set("n", "<Esc>", confirm_quit, buffer_local)

    local BODY_LENGTH = 3

    local opposite_dir = direction.invert()
    local head = Block.new(5, 5)
    local tail = head

    for _ = 2, BODY_LENGTH do
        local current = Block.new(opposite_dir.advance(tail.position))
        current.prev = tail
        tail.next = current
        tail = current
    end

    math.randomseed(os.time())

    local grid = {}

    for i = 1, game_height do
        grid[i] = string.rep("·", game_width)
    end

    local title = "Snake"
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, {string.rep(" ", math.floor((buffer_width - #title) / 2)) .. title})
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, grid)

    local function update_game()
        if not game_active then
            return
        end

        local x, y = direction.advance(head.position)
        local new_head = Block.new(x, y, head)
        head.next = new_head

        -- remove tail from grid

        -- local new_tail = tail.next
        -- new_tail.prev = nil

        local line = grid[y]
        grid[y] = line:sub(1, x-1) .. "s" .. line:sub(x+1)
        print(grid[y])
        vim.api.nvim_buf_set_lines(buf, 1, -1, false, grid)
    end

    update_game()
end

local difficulties = {"easy", "normal", "hard"}
local game_sizes = {"small", "medium", "large"}

vim.api.nvim_create_user_command("Snake", snake, {
    desc = "Play snake",
    nargs = "*",
    complete = function(_, cmd_line, cursor_pos)
        local arg
        local count = 0
        local cmd_to_cursor = cmd_line:sub(1, cursor_pos)

        for word in cmd_to_cursor:gmatch("%S+") do
            count = count + 1
            arg = word
        end

        if cmd_to_cursor:sub(-1) == " " then
            count = count + 1
            arg = ""
        end

        local matches = {}

        if count == 2 then
            for _, difficulty in ipairs(difficulties) do
                if difficulty:match("^" .. arg) then
                    table.insert(matches, difficulty)
                end
            end
        elseif count == 3 then
            for _, game_size in ipairs(game_sizes) do
                if game_size:match("^" .. arg) then
                    table.insert(matches, game_size)
                end
            end
        end

        return matches
    end
})

vim.keymap.set("n", "<leader>s", "<cmd>Snake<CR>", { desc = "Play snake" })
