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

function Config.generateBankingAccountId()
    return "BID-" .. StringUtils.randomString("AA")
                  .. StringUtils.randomString("00")
                  .. "-"
                  .. StringUtils.randomString("0000")
                  .. "-"
                  .. StringUtils.randomString("0000")
end
