This style guide puts an emphasis on readability and consistency

## Naming conventions

Use snake case for naming all variables and modules
```lua
local installation_list = {...}
```
```lua
local safe_loader = require("core.safe_loader")
```

However, prefer single, compounded words for conceptual terms

```lua
local filename = "init.lua"
local keycodes = ":q"
```

## String joining

If only one non-literal is being joined, use concatenation

```lua
local greeting = "Hello, " .. name .. "!"
local message = name .. " is my name"
local goodbye = "Goodbye" .. name
```

If there are two or three non-literals being joined, prefer concatenation only when the non-literals are the only parts being joined

```lua
local adverb = adjective .. suffix
```

```lua
local file_path = dir .. separator .. file
```

When two or three non-literals are being joined, if there is at least 1 literal, prefer formatting

```lua
local advice = ("%s once wisely said %s %d years ago"):format(ally, advice, years_passed)
local names = ("%s and %s"):format(enemy, friend)
local welcome = ("%s, %s%s"):format(discourse_particle, names, punctuation)
```

When there are more than 3 non-literals, use formatting

```lua
local fully_qualified_path = ("%s%s%s%s.lua"):format(
    home_directory,
    separator,
    config_directory,
    basename
)
```
