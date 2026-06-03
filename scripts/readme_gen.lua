package.path = package.path .. ";deps/?.lua"
local lunajson = require("lunajson")

local lockfile = assert(io.open("nvim/nvim-pack-lock.json", "r"), "Failed to open nvim lockfile")
local plugins = lunajson.decode(lockfile:read("*a"))
lockfile:close()

local lines = { "### Plugins" }

for name, data in pairs(plugins.plugins) do
	table.insert(lines, ("- [%s](%s)"):format(name, data.src or "no src"))
end

table.sort(lines)

local readme_file = assert(io.open("README.md", "r"), "Failed to open readme file for reading")
local readme_content = readme_file:read("*a")
readme_file:close()

local new_readme_content = readme_content:gsub(
	"<!%-%- START PLUGIN LIST %-%->[%s%S]*<!%-%- END PLUGIN LIST %-%->",
	([[<!-- START PLUGIN LIST -->
%s
<!-- END PLUGIN LIST -->]]):format(table.concat(lines, "\n"))
)

readme_file = assert(io.open("README.md", "w"), "Failed to open readme file for writing")
readme_file:write(new_readme_content)
readme_file:close()
