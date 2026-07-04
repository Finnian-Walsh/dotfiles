local new_set = MiniTest.new_set
local expect = MiniTest.expect

local T = new_set()

T["works"] = function()
    expect.equality(1 + 1, 2)

    expect.equality(7 * 7, 49)
end

return T
