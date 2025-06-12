local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Account = ENVIRONMENT_GET_VAR(env, "Account")

Test.new('Account should exist', function()
    return Test.assert(Account ~= nil, "Account should not be nil")
end)

Test.new('Account.load(id) should load the account with the given id', function(self)
    -- given
    local id = "test_account_id"

    -- when
    local account = Account.load(id)

    -- then
    return Test.assert(account ~= nil, "Account should not be nil") and
           Test.assert(account.id == id, "Account should have the correct id")
end)

Test.new('Account:addBalance(amount) should add the given amount to the account balance', function(self)
    -- given
    local account = Account.load("test_account_id")
    local initialBalance = account.balance
    local amountToAdd = 100.0

    -- when
    account:addBalance(amountToAdd)

    -- then
    return Test.assert(account.balance == initialBalance + amountToAdd, "Account balance should be updated correctly")
end)

Test.new('Account:removeBalance(amount) should remove the given amount from the account balance', function(self)
    -- given
    local account = Account.load("test_account_id")
    local amountToRemove = 50.0
    account:addBalance(100.0)

    -- when
    local success = account:removeBalance(amountToRemove)

    -- then
    return Test.assert(success == true, "Account should allow removing the amount") and
           Test.assert(account.balance == 50.0, "Account balance should be updated correctly")
end)

Test.new('Account:removeBalance(amount) should return false if the account does not have enough balance', function(self)
    -- given
    local account = Account.load("test_account_id")
    local initialBalance = account.balance
    local amountToRemove = initialBalance + 100.0

    -- when
    local success = account:removeBalance(amountToRemove)

    -- then
    return Test.assert(success == false, "Account should not allow removing more than the balance") and
           Test.assert(account.balance == initialBalance, "Account balance should remain unchanged")
end)

Test.runAll('Server.Account')
