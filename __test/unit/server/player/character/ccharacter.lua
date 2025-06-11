local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")

Test.new('CCharacter should exist', function()
    return Test.assert(CCharacter ~= nil, "CCharacter should not be nil")
end)

Test.runAll("Server.CCharacter")
