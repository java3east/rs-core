---@class Config
Config = {}

---Generates a random character ID in the format "CITIZEN-AAAAAA-0000".
---This ID will be used to uniquely identify a character in the game and by default
---also shown on the players id card.
---DO NOT MAKE THIS LONGER THAN 16 CHARACTERS, AS THIS IS THE MAXIMUM LENGTH.
---@return string citizenId the generated character / citizen ID
function Config.generateCharacterId()
    return "CITIZEN-" .. StringUtils.randomString("AAAA")
                      .. StringUtils.randomString("0000")
end

---Generates a ranodm banking account ID in the format "BID-AA00-0000-0000".
---This ID will be used to uniquely identify a banking account in the game.
---@return string bankingAccountId the generated banking account ID
function Config.generateBankingAccountId()
    return "BID-" .. StringUtils.randomString("AA")
                  .. StringUtils.randomString("00")
                  .. "-"
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("0000")
end

---Generates a random transaction ID in the format "TID-AAAA0000-AAAA0000-AAAA0000".
---This ID will be used to uniquely identify a transaction in the game.
---@return string transactionId the generated transaction ID
function Config.generateTransactionId()
    return "TID-" .. StringUtils.randomString("AAAA")
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("AAAA")
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("AAAA")
                  .. StringUtils.randomString("0000")
end
