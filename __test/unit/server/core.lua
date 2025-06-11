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
        Test.assert(Core.getPlayer ~= nil, "Core should have 'getPlayer' function")
end)

Test.runAll("Server.Core")