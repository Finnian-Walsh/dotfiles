local peek

local function find_peek()
    for _, path in ipairs(vim.opt.rtp:get()) do
        if path:match("peek.nvim") then
            return path
        end
    end
end

require("lazy_loader")
    .new(function()
        peek = require("peek")
        peek.setup {
            app = "browser",
        }

        local deno_build_command = { "deno", "task", "--quiet", "build:fast" }

        vim.system(deno_build_command, { cwd = find_peek() }, function(res)
            if res.code ~= 0 then
                error(("Failed to build peek with code: %d\n%s"):format(res.code, res.stderr))
            end
        end)
    end)
    :map("n", "<localleader>p", function()
        return peek.open
    end, { desc = "Open peek" })
    :map("n", "<localleader>P", function()
        return peek.close
    end, { desc = "Close peek" })
