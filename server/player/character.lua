---@class server
server = server or {}

---@class server.player
server.player = server.player or {}

---@class server.player.character
---@field _data table<string, any> the data of the character
---@field _cache table<string, any> the cache of the character
server.player.character = {}
server.player.character.__index = server.player.character

local function generateCitizenId()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local citizenId = ""

    repeat
        citizenId = ""
        for i = 1, 8 do
            local randomIndex = math.random(1, #chars)
            citizenId = citizenId .. chars:sub(randomIndex, randomIndex)
        end
    until server.adapter.database.select("SELECT * FROM rsc_characters WHERE citizenId = ?", {citizenId}) == 0

    return citizenId
end

---Creates a new character object
---@param citizenId string? the citizen id of the character
---@return server.player.character character the new character object
function server.player.character:new(citizenId)
    local obj = {}
    setmetatable(obj, self)
    obj._data = {}
    obj._cache = {}
    obj._data["citizenId"] = citizenId or generateCitizenId()
    return obj
end
