vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup {

            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signs_staged = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signs_staged_enable = true,
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                delay = 50,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
            current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
        }

        local map = vim.keymap.set

        local function nmap(key, callback, opts)
            map("n", key, callback, opts)
        end

        nmap(
            "<leader>gd",
            gitsigns.diffthis,
            { desc = "See the git diff for the current file against the staged/committed changes" }
        )

        nmap("<leader>gD", function()
            gitsigns.diffthis("~")
        end, { desc = "See the git diff for the current file against the last commit" })

        nmap("<leader>gb", gitsigns.blame, { desc = "Toggle the global git blame" })
        nmap("<leader>gi", gitsigns.blame_line, { desc = "Inspect the commit for the current line" })
        nmap("<leader>gl", gitsigns.toggle_current_line_blame, { desc = "Toggle the current line blame" }) -- never used this practically btw

        map({ "n", "v", "s" }, "[c", gitsigns.prev_hunk, { desc = "Go to the previous hunk" })
        map({ "n", "v", "s" }, "]c", gitsigns.next_hunk, { desc = "Go to the next hunk" })

        nmap("<leader>hs", gitsigns.stage_hunk, { desc = "Stage current hunk" })
        nmap("<leader>hu", gitsigns.undo_stage_hunk, { desc = "Unstage current hunk" })
        nmap("<leader>hr", gitsigns.reset_hunk, { desc = "Reset current hunk" })

        nmap("<leader>hp", gitsigns.preview_hunk_inline, { desc = "Preview the current hunk (inline)" })
        nmap("<leader>hP", gitsigns.preview_hunk, { desc = "Preview the current hunk (in a floating buffer)" })

        nmap("<leader>bs", gitsigns.stage_buffer, { desc = "Stage current buffer" })
        nmap("<leader>bu", gitsigns.reset_buffer_index, { desc = "Unstage current buffer" })
        nmap("<leader>br", gitsigns.reset_buffer, { desc = "Reset current buffer" })
    end,
})
