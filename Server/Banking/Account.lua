---@class Account
---@field id string the banking account ID
---@field balance number the current balance of the account
Account = {}
setmetatable(Account, {
    __call = function(t, id)
        local account = {}
        setmetatable(account, Account)
        account.id = id
        account.balance = 0.0
        return account
    end
})
Account.__index = Account

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

---Loads the account with the given ID from the database.
---@nodiscard
---@param id string the ID of the account to load
---@return Account? account the loaded account object, or nil if it could not be loaded
function Account.load(id)
    local account = Account(id)
    if load(account) then
        return account
    end
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

---Saves this account to the database.
function Account:save()
    -- TODO: requires more intel about the HELIX scripting API
end
