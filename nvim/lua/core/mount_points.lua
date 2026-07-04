local function get_cwd()
    local cwd = assert(vim.uv.cwd(), "Expected cwd to exist")
    return cwd
end

local mount_file_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "mount_points")
local mount_file_path = vim.fs.joinpath(mount_file_dir, vim.fn.sha256(get_cwd()) .. ".txt")

local function read_and_close_mount_file(mount_file)
    local raw_contents = mount_file:read("*a")
    mount_file:close()
    return raw_contents:gsub("\n$", "")
end

local function mount()
    local mount_file = io.open(mount_file_path, "r")

    if not mount_file then
        error("Failed to open " .. mount_file_path)
    end

    local mount_fs = read_and_close_mount_file(mount_file)

    local cwd = get_cwd()

    vim.system({
        "sshfs",
        mount_fs,
        cwd,
    }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                vim.notify(("Successfully mounted %s to %s"):format(cwd, mount_fs), vim.log.levels.INFO)
            else
                vim.notify(
                    ("Failed to mount %s to %s (code %d) with error:\n%s"):format(
                        cwd,
                        mount_fs,
                        result.code,
                        result.stderr
                    ),
                    vim.log.levels.ERROR
                )
            end
        end)
    end)
end

local function unmount()
    local cwd = get_cwd()
    local unwritten_files = {}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        if name:find(cwd, 1, true) == 1 and vim.bo[buf].modified then
            unwritten_files[#unwritten_files + 1] = vim.fs.relpath(cwd, name)
        end
    end

    if #unwritten_files > 0 then
        vim.notify(
            "Write any mounted files before unmounting\nUnwritten file(s): " .. table.concat(unwritten_files, ", "),
            vim.log.levels.WARN
        )
        return
    end

    vim.system({
        "umount",
        "-l",
        cwd,
    }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                vim.notify("Successfully unmounted " .. cwd, vim.log.levels.INFO)
            else
                vim.notify(
                    ("Failed to mount to %s (code %d) with error:\n%s"):format(result.code, result.code, result.stderr),
                    vim.log.levels.ERROR
                )
            end
        end)
    end)
end

local function create_mount_point()
    -- TODO: use some choice mechanism for other mounting methods or smth
    -- vim.ui.select({ "foo" }, { prompt = "Choose: " }, function(choice) end)

    local default

    if vim.uv.fs_stat(mount_file_path) then
        local mount_file = io.open(mount_file_path, "r")

        if not mount_file then
            vim.notify("Failed to open mount file", vim.log.levels.ERROR)
            return
        end

        default = read_and_close_mount_file(mount_file)
    end

    vim.ui.input({
        prompt = "Enter the mount filesystem path: ",
        default = default,
    }, function(input)
        if input == default then
            vim.notify("Mount file will remain the same", vim.log.levels.INFO)
            return
        end

        vim.fn.mkdir(mount_file_dir, "p")
        local mount_file = io.open(mount_file_path, "w")

        if not mount_file then
            vim.notify("Failed to open mount file", vim.log.levels.ERROR)
            return
        end

        mount_file:write(input)
        mount_file:close()

        if default then
            vim.notify("Successfully updated mount file for " .. get_cwd(), vim.log.levels.INFO)
        else
            vim.notify("Successfully created mount file for " .. get_cwd(), vim.log.levels.INFO)
        end
    end)
end

local function delete_mount_point()
    if not vim.uv.fs_stat(mount_file_path) then
        vim.notify("No mount file exists for the current directory", vim.log.levels.WARN)
        return
    end

    local mount_file = io.open(mount_file_path, "r")

    if not mount_file then
        vim.notify("Failed to open mount file", vim.log.levels.ERROR)
        return
    end

    local mount_fs = read_and_close_mount_file(mount_file)

    local answer = vim.fn.confirm(
        ("Are you sure you would like to delete the mount point?\nFile system pointed to: `%s`"):format(mount_fs),
        "&Yes\n&No"
    )

    if answer ~= 1 then
        return
    end

    vim.uv.fs_unlink(mount_file_path)
end

local function query_mount_point()
    if not vim.uv.fs_stat(mount_file_path) then
        vim.notify("There is no mount file for the current directory", vim.log.levels.INFO)
        return
    end

    local mount_file = io.open(mount_file_path, "r")

    if not mount_file then
        vim.notify("Failed to open mount point file", vim.log.levels.ERROR)
        return
    end

    local mount_fs = read_and_close_mount_file(mount_file)

    vim.notify(("The mount fs used by the current directory is: `%s`"):format(mount_fs))
end

vim.keymap.set("n", "<leader>mm", mount, { desc = "Mount the current directory" })
vim.keymap.set("n", "<leader>mu", unmount, { desc = "Unmount the current directory" })
vim.keymap.set("n", "<leader>ma", create_mount_point, { desc = "Create a mount point for the current directory" })
vim.keymap.set("n", "<leader>md", delete_mount_point, { desc = "Delete the mount point of the current directory" })
vim.keymap.set("n", "<leader>mq", query_mount_point, { desc = "Query the mount point of the cwd" })
