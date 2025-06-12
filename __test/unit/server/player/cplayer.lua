local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local CPlayer = ENVIRONMENT_GET_VAR(env, "CPlayer")

Test.new('CPlayer should exist', function()
    return Test.assert(CPlayer ~= nil, "CPlayer should not be nil")
end)

Test.new('CPlayer should have no active character by default', function()
    -- given
    local player = { }
    local cPlayer = CPlayer.new(player)

    -- when
    local activeCharacter = cPlayer:getActiveCharacter()

    -- then
    return Test.assert(activeCharacter == nil, "CPlayer should have no active character by default")
end)

Test.new('CPlayer:setActiveCharacter should set the active character', function()
    -- given
    local player = { }
    local cPlayer = CPlayer.new(player)
    local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")
    local cCharacter = CCharacter.new("test_citizen_id")

    -- when
    cPlayer:setActiveCharacter(cCharacter)

    -- then
    return Test.assert(cPlayer:getActiveCharacter() == cCharacter, "CPlayer should have the active character set") and
           Test.assert(cCharacter.possesedBy == cPlayer, "CCharacter should be possessed by the CPlayer")
end)

Test.new('CPlayer:isInCharacter should return correct state', function()
    -- given
    local player = { }
    local cPlayer = CPlayer.new(player)
    local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")
    local cCharacter = CCharacter.new("test_citizen_id")

    -- then
    if not Test.assert(cPlayer:isInCharacter() == false, "CPlayer should not be in character by default") then
        return false
    end

    -- when
    cPlayer:setActiveCharacter(cCharacter)

    -- then
    return Test.assert(cPlayer:isInCharacter() == true, "CPlayer should be in character")
end)

Test.new('CPlayer:logout should clear active character', function()
    -- given
    local player = { }
    local cPlayer = CPlayer.new(player)
    local CCharacter = ENVIRONMENT_GET_VAR(env, "CCharacter")
    local cCharacter = CCharacter.new("test_citizen_id")

    -- when
    cPlayer:setActiveCharacter(cCharacter)
    cPlayer:logout()

    -- then
    return Test.assert(cPlayer:getActiveCharacter() == nil, "CPlayer should have no active character after logout") and
           Test.assert(cCharacter.possesedBy == nil, "CCharacter should not be possessed by any CPlayer after logout")
end)

Test.runAll("Server.CPlayer")
