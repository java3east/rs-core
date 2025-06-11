local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Core = ENVIRONMENT_GET_VAR(env, "Core")

Test.new('Core should exist', function()
    return Test.assert(Core ~= nil, "Core should not be nil")
end)

Test.new('Core should have all required functions', function (self)
    return
        Test.assert(Core.getPlayer ~= nil, "Core should have 'getPlayer' function") and
        Test.assert(Core.addFunction ~= nil, "Core should have 'addFunction' function")
end)

Test.new('Core.addFunction should add a function to an object', function (self)
    -- given
    local objName = "Core"
    local funcName = "testFunction"
    local func = function() return "Hello, World!" end

    -- when
    Core.addFunction(objName, funcName, func)

    -- then
    local obj = ENVIRONMENT_GET_VAR(env, objName)
    return Test.assert(obj[funcName] ~= nil, "Function '" .. funcName .. "' should be added to object '" .. objName .. "'") and
           Test.assert(obj[funcName]() == "Hello, World!", "Function '" .. funcName .. "' should return 'Hello, World!'")
end)

Test.runAll("Server.Core")