local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local CPlayer = ENVIRONMENT_GET_VAR(env, "CPlayer")

Test.new('CPlayer should exist', function()
    return Test.assert(CPlayer ~= nil, "CPlayer should not be nil")
end)

Test.runAll("Server.CPlayer")
