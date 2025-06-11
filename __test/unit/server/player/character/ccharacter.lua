local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")
local CPlayer = ENVIRONMENT_GET_VAR(env, "CPlayer")

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

Test.new('CCharacter:wake should set the character as active for the player', function()
    -- given
    local cCharacter = CCharacter.new()
    local cPlayer = CPlayer.new({})

    -- when
    local success = cCharacter:wake(cPlayer)

    -- then
    return Test.assert(success == true and cCharacter.possesedBy == cPlayer, "CCharacter should be set as active for the player")
end)

Test.new('CCharacter:wake should not set the character as active if already possessed', function()
    -- given
    local cCharacter = CCharacter.new()
    local cPlayer1 = CPlayer.new({})
    local cPlayer2 = CPlayer.new({})

    -- when
    cCharacter:wake(cPlayer1)
    local success = cCharacter:wake(cPlayer2)

    -- then
    return Test.assert(success == false and cCharacter.possesedBy == cPlayer1, "CCharacter should not be set as active for another player if already possessed")
end)

Test.new('CCharacter:sleep should mark the character as inactive', function()
    -- given
    local cCharacter = CCharacter.new()
    local cPlayer = CPlayer.new({})

    -- when
    cCharacter:wake(cPlayer)
    cCharacter:sleep()

    -- then
    return Test.assert(cCharacter.possesedBy == nil, "CCharacter should be marked as inactive after sleep")
end)

Test.runAll("Server.CCharacter")
