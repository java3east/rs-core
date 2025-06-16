---@diagnostic disable: param-type-mismatch
local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local client = SIMULATOR_CREATE(simulation, "CLIENT")
local client2 = SIMULATOR_CREATE(simulation, "CLIENT")
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Player = ENVIRONMENT_GET_VAR(env, "Player")

local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")
local CPlayer = ENVIRONMENT_GET_VAR(env, "CPlayer")

Test.new('CCharacter should exist', function()
    return Test.assert(CCharacter ~= nil, "CCharacter should not be nil")
end)

Test.new('CCharacter.new should create a new core character', function()
    -- when
    local cCharacter = CCharacter.new()

    -- then
    return Test.assert(cCharacter.citizenId ~= nil and cCharacter.citizenId ~= "", "CCharacter.new should create a new core character")
end)

Test.new('CCharacter.load should use provided citizenId', function()
    -- given
    local id = "test_citizen_id"

    -- when
    local cCharacter = CCharacter.load(id)

    -- then
    return Test.assert(cCharacter.citizenId == id, "CCharacter.load should use the provided citizenId")
end)

Test.new('CCharacter:getData should return correct data', function (self)
    -- given
    local cCharacter = CCharacter.new("A", "B", "01/01/2000", false)

    -- when
    local data = cCharacter:getData()

    -- then
    return Test.assert(type(data.citizenId) == "string", "data.citizenId should be a string") and
              Test.assert(data.firstName == "A", "data.firstName should be 'A'") and
              Test.assert(data.lastName == "B", "data.lastName should be 'B'") and
              Test.assert(data.dateOfBirth == "01/01/2000", "data.dateOfBirth should be '01/01/2000'") and
              Test.assert(data.gender == false, "data.gender should be false")
end)

Test.new('Character:isFemale should return correct value', function (self)
    -- given
    local cCharacter = CCharacter.new("A", "B", "01/01/2000", true)
    local cCharacter2 = CCharacter.new("C", "D", "01/01/2000", false)

    -- when
    local isFemale = cCharacter:isFemale()
    local isFemale2 = cCharacter2:isFemale()

    -- then
    return  Test.assert(isFemale == true, "Character:isFemale should return correct value") and
            Test.assert(isFemale2 == false, "Character:isFemale should return correct value")
end)

Test.new('CCharacter:wake should set the character as active for the player', function()
    -- given
    local cCharacter = CCharacter.new()
    local cPlayer = CPlayer.new(Player.__of(client))

    -- when
    local success = cCharacter:wake(cPlayer)

    -- then
    return Test.assert(success == true and cCharacter.possesedBy == cPlayer, "CCharacter should be set as active for the player")
end)

Test.new('CCharacter:wake should not set the character as active if already possessed', function()
    -- given
    local cCharacter = CCharacter.new()
    local cPlayer1 = CPlayer.new(Player.__of(client))
    local cPlayer2 = CPlayer.new(Player.__of(client2))

    -- when
    cCharacter:wake(cPlayer1)
    local success = cCharacter:wake(cPlayer2)

    -- then
    return Test.assert(success == false and cCharacter.possesedBy == cPlayer1, "CCharacter should not be set as active for another player if already possessed")
end)

Test.new('CCharacter:sleep should mark the character as inactive', function()
    -- given
    local cCharacter = CCharacter.new()
    local cPlayer = CPlayer.new(Player.__of(client))

    -- when
    cCharacter:wake(cPlayer)
    cCharacter:sleep()

    -- then
    return Test.assert(cCharacter.possesedBy == nil, "CCharacter should be marked as inactive after sleep")
end)
