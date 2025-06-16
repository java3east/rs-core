local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local StringUtils = ENVIRONMENT_GET_VAR(env, "StringUtils")

Test.new('StringUtils should exist', function()
    return Test.assert(StringUtils ~= nil, "StringUtils should not be nil")
end)

local charLists = {
    a = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'},
    A = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'},
    ['0'] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
}

Test.new('StringUtils.randomString should return a string with the correct format', function()
    -- when
    local randomString = StringUtils.randomString("aA0aA0")

    -- then
    return Test.assert(type(randomString) == "string" and #randomString == 6, "StringUtils randomString should return a string with length 6 for input 'aA0aA0'") and
        Test.assertOneOf(randomString:sub(1, 1), charLists.a, "StringUtils randomString first character should be a lowercase letter for input 'aA0aA0'") and
        Test.assertOneOf(randomString:sub(2, 2), charLists.A, "StringUtils randomString second character should be an uppercase letter for input 'aA0aA0'") and
        Test.assertOneOf(randomString:sub(3, 3), charLists["0"], "StringUtils randomString third character should be a digit for input 'aA0aA0'") and
        Test.assertOneOf(randomString:sub(4, 4), charLists.a, "StringUtils randomString fourth character should be a lowercase letter for input 'aA0aA0'") and
        Test.assertOneOf(randomString:sub(5, 5), charLists.A, "StringUtils randomString fifth character should be an uppercase letter for input 'aA0aA0'") and
        Test.assertOneOf(randomString:sub(6, 6), charLists["0"], "StringUtils randomString sixth character should be a digit for input 'aA0aA0'")
end)

Test.new('StringUtils.split should return the correct parts', function()
    -- when
    local parts = StringUtils.split("hello.world.test", ".")

    -- then
    return Test.assert(#parts == 3, "StringUtils split should return 3 parts for input 'hello.world.test'") and
        Test.assert(parts[1] == "hello", "First part should be 'hello'") and
        Test.assert(parts[2] == "world", "Second part should be 'world'") and
        Test.assert(parts[3] == "test", "Third part should be 'test'")
end)

Test.new('StringUtils.format should replace keys with values', function()
    -- given
    local str = "Hello, {name}! You have {count} new messages."
    local args = {name = "Alice", count = 5}

    -- when
    local formattedStr = StringUtils.format(str, args)

    -- then
    return Test.assert(formattedStr == "Hello, Alice! You have 5 new messages.", "StringUtils format should replace keys with values correctly")
end)
