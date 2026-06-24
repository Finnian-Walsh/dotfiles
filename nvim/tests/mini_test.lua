local T = MiniTest.new_set()

T["core"] = require("tests.core")
T["plugins"] = require("tests.plugins")

return T
