require("adapter/player.lua")

---@class server
server = server or {}

---@class server.player
---@field player vplayer
server.player = server.player or {}
server.player.__index = server.player

---@type table<vplayer, server.player> a list of all online players
local players = {}

---adds functions to the object it self to avoid problems with other
---resources
---@param player server.player
local function pack(player)
    player.getIdentifiers = server.player.getIdentifiers
    player.primaryIdentifier = server.player.primaryIdentifier
end

---Returns a map of all online players
---@nodiscard
---@return table<vplayer, server.player>
function server.player.getAll()
    return players
end

---Creates a new player object.
---@param player vplayer
---@return server.player
function server.player:new(player)
    local obj = {}
    setmetatable(obj, self)
    obj.player = player
    pack(obj)
    players[player] = obj
    return obj
end

---Returns the players identifiers
---@nodiscard
---@return string[] identifiers the players identifiers
function server.player:getIdentifiers()
    return server.adapter.player.getIdentifiers(self.player)
end

---Returns the players primary identifier
---@nodiscard
---@return string identifier the players primary identifier
function server.player:primaryIdentifier()
    return server.adapter.player.getIdentifier(self.player)
end
