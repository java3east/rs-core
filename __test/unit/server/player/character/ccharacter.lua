local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")

Test.new('CCharacter should exist', function()
    return Test.assert(CCharacter ~= nil, "CCharacter should not be nil")
end)

Test.new('CCharacter should generate new citizenId if not provided', function()
    -- when
    local cCharacter = CCharacter.new()

    -- then
    return Test.assert(cCharacter.citizenId ~= nil and cCharacter.citizenId ~= "", "CCharacter should generate a new citizenId if not provided")
end)

Test.new('CCharacter should use provided citizenId', function()
    -- given
    local id = "test_citizen_id"

    -- when
    local cCharacter = CCharacter.new(id)

    -- then
    return Test.assert(cCharacter.citizenId == id, "CCharacter should use the provided citizenId")
end)

Test.new('CCharacter get data should return correct data', function (self)
    -- given
    local cCharacter = CCharacter.new()

    -- when
    local data = cCharacter:getData()

    -- then
    return Test.assert(type(data.citizenId) == "string", "data.citizenId should be a string")
end)

Test.runAll("Server.CCharacter")
