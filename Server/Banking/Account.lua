---@class Account
---@field id string the banking account ID
---@field balance number the current balance of the account
Account = {}
Account.__index = Account

---@nodiscard
---@param id string? the banking account ID, or nil to generate a new one
---@return Account account
function Account.new(id)
    local account = {}
    setmetatable(account, Account)
    account.id = id or Config.generateBankingAccountId()
    account.balance = 0.0
    return account
end

---This will load the account from the database.
function Account:load()
    -- TODO: requires more intel about the HELIX scripting API
end

---Adds the given amount of money to this account
function Account:addBalance(amount)
    self.balance = self.balance + amount
end

---Saves this account to the database.
function Account:save()
    -- TODO: requires more intel about the HELIX scripting API
end
