local hooker = require("hooker")

hooker.setup {
    open_directory = require("oil").open,
}

vim.keymap.set("n", "<leader>a", hooker.add_file, { desc = "Add current file to hooker" })

vim.keymap.set("n", "<leader>h", hooker.menu)

local telescope_modules

_G.hooker_picker_selection_reset = 5

local function load_hooker_telescope()
    if not telescope_modules then
        telescope_modules = {
            pickers = require("telescope.pickers"),
            finders = require("telescope.finders"),
            conf = require("telescope.config").values,
            actions = require("telescope.actions"),
            action_state = require("telescope.actions.state"),
            devicons = require("nvim-web-devicons"),
        }
    end

    local get_icon = telescope_modules.devicons.get_icon_by_filetype
    local index = 1

    local function schedule_ahead(f, loops)
        if loops <= 0 then
            f()
        elseif loops == 1 then
            vim.schedule(f)
        else
            vim.schedule(function()
                schedule_ahead(f, loops - 1)
            end)
        end
    end

    local function entry_maker(filename)
        local icon
        if filename:sub(-1) == package.config:sub(1, 1) then
            icon = ""
        else
            icon = get_icon(vim.fn.fnamemodify(filename, ":e"), { default = true })
        end

        local entry = {
            value = { filename = filename, index = index },
            display = icon .. " " .. filename,
            ordinal = filename,
        }

        index = index + 1

        return entry
    end

    telescope_modules.pickers
        .new({}, {
            prompt_title = "Hooker",

            finder = telescope_modules.finders.new_table {
                results = hooker.get_written_hooks(),

                entry_maker = entry_maker,
            },

            attach_mappings = function(buf, map)
                map("n", "<C-d>", function()
                    local selection = telescope_modules.action_state.get_selected_entry()
                    local hooks = hooker.get_written_hooks()
                    table.remove(hooks, selection.value.index)

                    hooker.write_hooks(hooks)

                    index = 1

                    local get_picker = telescope_modules.action_state.get_current_picker
                    local row = get_picker(buf):get_selection_row()

                    get_picker(buf):refresh(telescope_modules.finders.new_table {
                        results = hooker.get_written_hooks(),
                        entry_maker = entry_maker,
                    })

                    schedule_ahead(function()
                        local picker = get_picker(buf)
                        if picker:can_select_row(row) then
                            picker:set_selection(row)
                        else
                            picker:set_selection(row + 1)
                        end
                    end, hooker_picker_selection_reset)
                end)

                map("n", "<C-a>", function()
                    local search = telescope_modules.action_state.get_current_line()

                    if #search == 0 then
                        return
                    end

                    local hooks = hooker.get_written_hooks()
                    table.insert(hooks, search)

                    hooker.write_hooks(hooks)

                    index = 1

                    local get_picker = telescope_modules.action_state.get_current_picker
                    local row = get_picker(buf):get_selection_row()

                    get_picker(buf):refresh(telescope_modules.finders.new_table {
                        results = hooker.get_written_hooks(),
                        entry_maker = entry_maker,
                    })

                    schedule_ahead(function()
                        local picker = get_picker(buf)
                        picker:set_selection(row)
                    end, hooker_picker_selection_reset)
                end)

                return true
            end,

            initial_mode = "normal",
        })
        :find()
end

vim.keymap.set("n", "<leader>H", load_hooker_telescope, { desc = "Load hooker using telescope" })

local function make_bound(i)
    local warning_message = "There is no item " .. i .. " in the hooker list"
    return function(f)
        return function()
            if hooker.length() >= i then
                f()
            else
                vim.notify(warning_message, vim.log.levels.WARN)
            end
        end
    end
end

for i = 1, 20 do
    local navigation_key = nav_keys[i]
    local bound_function = make_bound(i)

    vim.keymap.set(
        "n",
        "<leader>" .. navigation_key,
        bound_function(function()
            hooker.select(i)
        end),
        { desc = "Hooker " .. i }
    )

    vim.keymap.set(
        "n",
        "<leader>n" .. navigation_key,
        bound_function(function()
            vim.cmd("vs | wincmd l")
            hooker.select(i)
        end),
        { desc = "Hooker " .. i .. " (vertical split)" }
    )

    vim.keymap.set(
        "n",
        "<leader>N" .. navigation_key,
        bound_function(function()
            vim.cmd("sp | wincmd j")
            hooker.select(i)
        end),
        { desc = "Hooker " .. i .. " (horizontal split)" }
    )

    vim.keymap.set(
        "n",
        "<leader>o" .. navigation_key,
        bound_function(function()
            hooker.select(i)
            vim.cmd.BufOnly()
        end),
        {
            desc = "Hooker switch to only " .. i .. " and displayed",
        }
    )

    vim.keymap.set(
        "n",
        "<leader>O" .. navigation_key,
        bound_function(function()
            hooker.select(i)
            vim.cmd.BufCurrentOnly()
        end),
        { desc = "Hooker switch to only " .. i }
    )
end
