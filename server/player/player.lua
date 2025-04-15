require("adapter/player.lua")

---@class server
server = server or {}

---@class server.player
---@field player vplayer
---@field _data table<string, any>
---@field _cache table<string, any>
server.player = server.player or {}
server.player.__index = server.player

---@type table<vplayer, server.player> a list of all online players
local players = {}

---@type table<string, server.player> a list of all players by their identifier
local byIdentifier = {}

---adds functions to the object it self to avoid problems with other
---resources
---@param player server.player
local function pack(player)
    player.getIdentifiers = server.player.getIdentifiers
    player.primaryIdentifier = server.player.primaryIdentifier
    player.getGroup = server.player.getGroup
    player.isNew = server.player.isNew
end

---@nodiscard
---@param player server.player
---@param func fun() : any
---@param name string
---@return any
local function getOrLoad(player, func, name)
    local obj = player._cache[name]
    if obj == nil then
        obj = func()
        player._cache[name] = obj
    end
    return obj
end

---Loads the given player from the database
---@param player server.player
---@return boolean exists if the player exists
local function load(player)
    local identifier = player:primaryIdentifier()
    local results = server.adapter.database.select("SELECT * FROM players WHERE identifier = ?", {identifier})
    if #results < 1 then return false end
    local result = results[1]
    player._data["group"] = result.group
    return true
end

---Returns a map of all online players
---@nodiscard
---@return table<vplayer, server.player>
function server.player.getAll()
    return players
end

---Returns the player object for the given vplayer
---@nodiscard
---@param player vplayer the vplayer to load the player for
---@return server.player? player the player object
function server.player.get(player)
    return players[player]
end

---Returns a player object by their identifier
---@nodiscard
---@param identifier string the identifier of the player to get
---@return server.player? player 
function server.player.getByIdentifier(identifier)
    return byIdentifier[identifier]
end

---Saves all currently saved players
function server.player.saveAll()
    local data = {}

    for _, player in pairs(players) do
        local identifier = player:primaryIdentifier()
        local group = player:getGroup()
        table.insert(data, { identifier, group, group })
    end

    server.adapter.database.prepare("INSERT INTO players (identifier, group) VALUES (?, ?) ON DUPLICATE KEY UPDATE group = ?", data)
end

---Creates a new player object.
---@param player vplayer
---@return server.player
function server.player:new(player)
    local obj = {}
    setmetatable(obj, self)
    obj.player = player
    obj._data = {}
    obj._data["group"] = "user"
    obj._cache = {}
    obj._cache["isNew"] = load(obj)
    pack(obj)
    players[player] = obj
    return obj
end

---Returns the players identifiers
---@nodiscard
---@return string[] identifiers the players identifiers
function server.player:getIdentifiers()
    return getOrLoad(self, function()
        return server.adapter.player.getIdentifiers(self.player)
    end, "identifiers")
end

---Returns the players primary identifier
---@nodiscard
---@return string identifier the players primary identifier
function server.player:primaryIdentifier()
    return getOrLoad(self, function()
        return server.adapter.player.getIdentifier(self.player)
    end, "identifier")
end


---Returns the group name of this player
---@nodiscard
---@return string group the group name
function server.player:getGroup()
    return self._data["group"]
end

---Sets the group of this player
---@param group string the group name
function server.player:setGroup(group)
    self._data["group"] = group
end

---Returns wheather or not this player is new
---@nodiscard
---@return boolean isNew
function server.player:isNew()
    return self._cache["isNew"]
end
