---@class Account
---@field id string the banking account ID
---@field balance number the current balance of the account
---@field transactions Transaction[] the list of transactions associated with this account
Account = {}
setmetatable(Account, {
    __call = function(t, id)
        local account = {}
        setmetatable(account, Account)
        account.id = id
        account.balance = 0.0
        account.transactions = {}
        return account
    end
})
Account.__index = Account

---@type Cache
local accounts = Cache()

---@class Transaction
---@field id string the transaction ID
---@field from Account the account that initiated the transaction
---@field to Account the account that received the transaction
---@field amount number the amount of money transferred in the transaction
---@field description string a description of the transaction
---@field timestamp number the timestamp of the transaction

---Saves the given account into the database.
---@param account Account the account to save
local function create(account)
    -- TODO: implement the database creation logic
    --       this requires more intel on the HELIX scripting API
end

---Loads the data for the given account from the database.
---@nodiscard
---@param account Account the account to load
---@return boolean success true if the account was loaded successfully, false otherwise
local function load(account)
    -- TODO: implement the database loading logic
    --       this requires more intel on the HELIX scripting API
    return true
end

---Adds the given transaction to the account's transaction history.
---@param account Account the account to add the transaction to
---@param transaction Transaction the transaction to add
local function addTransaction(account, transaction)
    table.insert(account.transactions, transaction)
end

---Loads the account with the given ID from the database.
---@nodiscard
---@param id string the ID of the account to load
---@return Account? account the loaded account object, or nil if it could not be loaded
function Account.load(id)
    return accounts:get(id, function ()
        local account = Account(id)
        if load(account) then
            return account
        end
    end)
end

---Creates a new banking account. This account will be directly saved
---into the database.
---@nodiscard
---@return Account account the new account object
function Account.new()
    local account = Account(Config.generateBankingAccountId())
    create(account)
    return account
end

---Adds the given amount of money to this account
---@param amount number the amount of money to add
function Account:addBalance(amount)
    self.balance = self.balance + amount
end

---Removes the given amount of money from this account
---@nodiscard
---@param amount number the amount of money to remove
---@return boolean success true if the amount was successfully removed, false if the account does not have enough balance
function Account:removeBalance(amount)
    if self.balance < amount then
        return false
    end
    self.balance = self.balance - amount
    return true
end

---Transfers the given amount of money from this account to another account.
---@nodiscard
---@param to Account the account to transfer the money to
---@param amount number the amount of money to transfer
---@param description string a description of the transaction
---@return Transaction? transaction the created transaction object,
--- or nil if the trasaction failed (e.g. due to insufficient balance)
function Account:createTransaction(to, amount, description)
    if not self:removeBalance(amount) then
        return nil
    end
    to:addBalance(amount)
    local id = Config.generateTransactionId()
    local transaction = {
        id = id,
        from = self.id,
        to = to.id,
        amount = amount,
        description = description,
        timestamp = os.time()
    }
    addTransaction(self, transaction)
    addTransaction(to, transaction)
    return transaction
end

---Saves this account to the database.
function Account:save()
    -- TODO: requires more intel about the HELIX scripting API
end
