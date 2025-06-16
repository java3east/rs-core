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
    local account = Account.new()
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

Test.new('Account:createTransaction(to, amount, description) should create a transaction and update balances', function(self)
    -- given
    local fromAccount = Account.new()
    local toAccount = Account.new()
    fromAccount:addBalance(200.0)

    -- when
    local transaction = fromAccount:createTransaction(toAccount, 100.0, "Test Transaction")

    -- then
    return Test.assert(transaction ~= nil, "Transaction should be created") and
           Test.assert(transaction.from == fromAccount.id, "Transaction should have the correct from account") and
           Test.assert(transaction.to == toAccount.id, "Transaction should have the correct to account") and
           Test.assert(transaction.amount == 100.0, "Transaction should have the correct amount") and
           Test.assert(fromAccount.balance == 100.0, "From account balance should be updated") and
           Test.assert(toAccount.balance == 100.0, "To account balance should be updated") and
           Test.assert(transaction.description == "Test Transaction", "Transaction should have the correct description") and
           Test.assert(transaction.id ~= nil, "Transaction should have a valid ID") and
           Test.assert(#fromAccount.transactions > 0, "From account should have at least one transaction") and
           Test.assert(#toAccount.transactions > 0, "To account should have at least one transaction")
end)

Test.new('Account:createTransaction(to, amount, description) should return nil if the from account does not have enough balance', function(self)
    -- given
    local fromAccount = Account.new()
    local toAccount = Account.new()
    fromAccount:addBalance(50.0)

    -- when
    local transaction = fromAccount:createTransaction(toAccount, 100.0, "Test Transaction")

    -- then
    return Test.assert(transaction == nil, "Transaction should not be created due to insufficient balance") and
           Test.assert(fromAccount.balance == 50.0, "From account balance should remain unchanged") and
           Test.assert(toAccount.balance == 0.0, "To account balance should remain unchanged")
end)

