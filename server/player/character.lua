---@class server
server = server or {}

---@class server.player
server.player = server.player or {}

---@class server.player.character
---@field _data table<string, any> the data of the character
---@field _cache table<string, any> the cache of the character
server.player.character = {}
server.player.character.__index = server.player.character

---@type table<string, server.player.character>
local characters = {}

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

---Saves all characters
function server.player.character.saveAll()
    local data = {}

    for _, character in pairs(characters) do
        table.insert(data,
            {
                character._data["citizenId"],
                character._data["owned_by"],
                character._data["owned_by"]
            }
        )
    end

    server.adapter.database.prepare("INSERT INTO rsc_characters (citizenId, owned_by) VALUES (?, ?) ON DUPLICATE KEY UPDATE owned_by = ?", data)
end

---Loads all the characters for the given player
---@nodiscard
---@param player server.player the player to load the characters for
---@return server.player.character[] characters the loaded characters
function server.player.character.loadForPlayer(player)
    local characters = {}

    local results = server.adapter.database.select("SELECT * FROM rsc_characters WHERE identifier = ?", {player:primaryIdentifier()})
    for _, result in ipairs(results) do
        local character = server.player.character:new(result.citizenId)
        table.insert(characters, character)
    end

    return characters
end

---Returns the character with the given citizen id
---@nodiscard
---@param citizenId string the citizenId
---@return server.player.character? character the character object
function server.player.character.get(citizenId)
    return characters[citizenId]
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
    characters[obj._data["citizenId"]] = obj
    return obj
end
