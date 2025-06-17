local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local TableUtils = ENVIRONMENT_GET_VAR(env, "TableUtils")

Test.new('TableUtils should exist', function (self)
    return Test.assert(TableUtils ~= nil, "TableUtils should not be nil")
end)

Test.new('TableUtils:copy should create a deep copy of a table', function (self)
    -- given
    local original = { a = 1, b = { c = 2, d = 3 } }

    -- when
    local copy = TableUtils:copy(original)

    -- then
    return Test.assert(copy ~= original, "Copy should not be the same table") and
           Test.assertEqual(copy.a, original.a, "Copy should have the same value for key 'a'") and
           Test.assert(copy.b ~= original.b, "Nested table 'b' should also be copied") and
           Test.assert(copy.b.c == original.b.c and copy.b.d == original.b.d, "Nested table 'b' should have the same values")
end)

Test.new('TableUtils.toString should convert a table to a string representation', function (self)
    -- given
    local t = { a = 1, b = { c = 2, d = 3 } }

    -- when
    local str = TableUtils.toString(t)

    -- then
    return Test.assert(str == "{a=1, b={c=2, d=3}}", "TableUtils.toString should return the correct string representation")
end)

Test.new('TableUtils.toString should use __tostring if available', function (self)
    -- given
    local customTable = {
        a = 1,
        b = 2,
        __tostring = function()
            return "CustomTable(a=1, b=2)"
        end
    }

    -- when
    local str = TableUtils.toString(customTable)

    -- then
    return Test.assert(str == "CustomTable(a=1, b=2)", "TableUtils.toString should use __tostring if available")
end)

Test.new('TableUtils.toString should handle non-table values', function (self)
    -- given
    local nonTableValue = "Hello, World!"

    -- when
    local str = TableUtils.toString(nonTableValue)

    -- then
    return Test.assert(str == "Hello, World!", "TableUtils.toString should return the string representation of non-table values")
end)

Test.new('TableUtils.toString should use __tostring in inner tables if available', function (self)
    -- given
    local innerTable = {
        x = 10,
        y = 20,
        __tostring = function()
            return "InnerTable(x=10, y=20)"
        end
    }
    local outerTable = { a = 1, b = innerTable }

    -- when
    local str = TableUtils.toString(outerTable)

    -- then
    return Test.assert(str == "{a=1, b=InnerTable(x=10, y=20)}", "TableUtils.toString should use __tostring in inner tables if available")
end)

