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

---Adds all the required funtions to the object it self to avoid problems when
---using other resources
---@param character server.player.character
local function pack(character)
end

local function generateCitizenId()
    local citizenId = ""

    repeat
        citizenId = shared.string.random(8)
    until #server.adapter.database.select("SELECT * FROM rsc_characters WHERE citizenId = ?", {citizenId}) == 0

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
    local chars = {}

    local results = server.adapter.database.select("SELECT * FROM rsc_characters WHERE identifier = ?", {player:primaryIdentifier()})
    for _, result in ipairs(results) do
        local character = server.player.character:new(result.citizenId)
        table.insert(chars, character)
    end

    return chars
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
    local isNew = citizenId == nil
    setmetatable(obj, self)
    obj.data = {}
    obj._cache = {}
    obj.data["citizenId"] = citizenId or generateCitizenId()
    obj.data["isNew"] = isNew
    if (not isNew) then
        obj:load()
    end
    characters[obj.data["citizenId"]] = obj
    return obj
end

---Loads the data for this character from the database
function server.player:load()
    local results = server.adapter.database.select("SELECT * FROM rsc_characters WHERE citizenId = ?", {self._data["citizenId"]})
    if #results < 1 then return end
    local result = results[1]
    self._data["owned_by"] = result.owned_by
end

---Returns a string representing this character
---@nodiscard
---@return string character the string representation of the character
function server.player.character:__tostring()
    return "character(" .. tostring(self._data["citizenId"]) .. ")"
end
