local function printable_char_set()
    local char_set = {}

    for byte = 32, 126 do
        char_set[string.char(byte)] = true
    end

    return char_set
end

local function matched_keys(mode, pattern)
    return coroutine.wrap(function()
        local keymaps = vim.api.nvim_get_keymap(mode)

        for _, map in ipairs(keymaps) do
            local result = map.lhs:match(pattern)
            if result then
                coroutine.yield(result, map)
            end
        end
    end)
end

local function group_sorted_ascii_characters(chars)
    local uppercase_chars = {}
    local lowercase_chars = {}
    local numbers = {}
    local symbols = {}

    local groups = {
        { string.byte("0") - 1, symbols },
        { string.byte("9"), numbers },
        { string.byte("A") - 1, symbols },
        { string.byte("Z"), uppercase_chars },
        { string.byte("a") - 1, symbols },
        { string.byte("z"), lowercase_chars },
        { 126, symbols },
    }

    local index = 1
    local current_table = groups[index][2]

    for _, key in ipairs(chars) do
        local keybyte = string.byte(key)

        while keybyte > groups[index][1] do
            index = index + 1
            current_table = groups[index][2]
        end

        current_table[#current_table + 1] = key
    end

    return uppercase_chars, lowercase_chars, numbers, symbols
end

-- command for checking unused global leader keymaps:
vim.keymap.set("n", "<leader>kk", function()
    local chars = printable_char_set()

    for key in matched_keys("n", "^" .. vim.g.mapleader .. "([%g ])") do
        chars[key] = nil
    end

    local unused_keys = {}

    for key in pairs(chars) do
        unused_keys[#unused_keys + 1] = key
    end

    table.sort(unused_keys)

    local unused_uppercase, unused_lowercase, unused_numbers, unused_symbols =
        group_sorted_ascii_characters(unused_keys)

    local message = {}

    local function add_to_message(tbl)
        if #tbl == 0 then
            message[#message + 1] = "''"
            return
        end

        message[#message + 1] = "'"

        local i = 1
        local length = #tbl

        while i < length do
            message[#message + 1] = tbl[i] .. ", "
            i = i + 1
        end

        message[#message + 1] = tbl[i] .. "'"
    end

    message[#message + 1] = "Unused uppercase: "
    add_to_message(unused_uppercase)

    message[#message + 1] = "\nUnused lowercase: "
    add_to_message(unused_lowercase)

    message[#message + 1] = "\nUnused numbers: "
    add_to_message(unused_numbers)

    message[#message + 1] = "\nUnused symbols: "
    add_to_message(unused_symbols)

    Snacks.notify.info(table.concat(message), { hl = { msg = "DiagnosticInfo" } })
end, { desc = "Check unused leader keymaps" })

local function set_global_keys_check(char)
    vim.keymap.set("n", "<leader>K" .. char, function()
        local mappings = {}

        local special_cases = {
            ["["] = "%[",
            ["-"] = "%-",
            ["^"] = "%^",
        }

        local special_match = special_cases[char]

        if special_match then
            char = special_match
        end

        for _, map in matched_keys("n", ("^%s[%s]"):format(vim.g.mapleader, char)) do
            mappings[#mappings + 1] = ("<leader>%s: %s"):format(map.lhs:sub(2), map.desc or "[no description]")
        end

        if #mappings == 0 then
            mappings[1] = ("<leader>%s is not mapped"):format(char)
        end

        Snacks.notify.info(table.concat(mappings, "\n"), { hl = { msg = "DiagnosticInfo" } })
    end, { desc = "Check normal mode leader keys for `" .. char .. "` key" })
end

for i = 32, 126 do
    set_global_keys_check(string.char(i))
end
