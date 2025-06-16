local simulation = SIMULATION_CREATE("HELIX")
local client1 = SIMULATOR_CREATE(simulation, "CLIENT")
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(client1, resource)
local Config = ENVIRONMENT_GET_VAR(env, "Config")

Test.new('Config should exist', function()
    return Test.assert(Config ~= nil, "Config should not be nil")
end)

Test.new('Config.generateCharacterId should return a string <= 16 characters', function()
    -- when
    local citizenId = Config.generateCharacterId()

    -- then
    return Test.assert(type(citizenId) == "string" and #citizenId <= 16, "Config generateCharacterId should return a string with length <= 16")
end)

Test.new('Config.generateBankingAccountId should return a string <= 32 characters', function()
    -- when
    local bankingId = Config.generateBankingAccountId()

    -- then
    return Test.assert(type(bankingId) == "string" and #bankingId <= 32, "Config generateBankingAccountId should return a string with length <= 32")
end)

Test.new('Config.generateTransactionId should return a string <= 32 characters', function()
    -- when
    local transactionId = Config.generateTransactionId()

    -- then
    return Test.assert(type(transactionId) == "string" and #transactionId <= 32, "Config generateTransactionId should return a string with length <= 32")
end)

