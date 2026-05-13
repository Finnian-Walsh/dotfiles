vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#00BFA5", bg = "NONE", bold = true })

local pickers
local finders
local conf
local actions
local action_state

local function open_picker()
    if not pickers then
        pickers = require("telescope.pickers")
        finders = require("telescope.finders")
        conf = require("telescope.config").values
        actions = require("telescope.actions")
        action_state = require("telescope.actions.state")
    end

    pickers
        .new({}, {
            prompt_title = "Plugins",

            finder = finders.new_table {
                results = vim.pack.get(),

                entry_maker = function(entry)
                    local value = entry.spec.name
                    local display

                    if entry.active then
                        display = value
                    else
                        display = value .. " [inactive]"
                    end

                    return {
                        value = value,
                        display = display,
                        ordinal = display,
                    }
                end,
            },

            sorter = conf.generic_sorter {},

            attach_mappings = function(buf, map)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()

                    actions.close(buf)

                    print(selection[1])
                end)

                map({ "i", "n" }, "<C-d>", function()
                    local selection = action_state.get_selected_entry()

                    vim.print(selection)
                end)

                return true
            end,

            initial_mode = "normal",
        })
        :find()
end

vim.keymap.set("n", "<leader>p", open_picker, { desc = "View plugins" })

vim.keymap.set("n", "<leader>P", vim.pack.update, { desc = "Update plugins" })

vim.api.nvim_create_user_command("Plugins", open_picker, { desc = "View plugins" })
