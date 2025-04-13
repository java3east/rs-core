---@class server
server = server or {}

---@class server.player
---@field player vplayer
server.player = server.player or {}
server.player.__index = server.player

---@type table<vplayer, server.player> a list of all online players
local players = {}

---Returns a map of all online players
---@nodiscard
---@return table<vplayer, server.player>
function server.player.getAll()
    return players
end

---Creates a new player object.
---@nodiscard
---@param player vplayer
---@return server.player
function server.player:new(player)
    local obj = {}
    setmetatable(obj, self)
    obj.player = player
    obj:pack()
    players[player] = obj
    return obj
end

---Returns the players identifiers
---@nodiscard
---@return string[] identifiers the players identifiers
function server.player:getIdentifiers()
    return server.adapter.player.getIdentifiers(self.player)
end

---Required for outside access to functions of the parent object
function server.player:pack()
    self.getIdentifiers = server.player.getIdentifiers
end
