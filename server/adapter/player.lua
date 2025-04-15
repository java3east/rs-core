---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.player
server.adapter.player = {}

---Returns the identifiers for the given player
---@nodiscard
---@param player vplayer the player to get identifiers for
---@return string[] identifiers the players identifiers
function server.adapter.player.getIdentifiers(player)
    return {}
end

---Returns the primary identifier for the player
---@nodiscard
---@param player vplayer the player to get the identifier for
---@return string identifier the primary identifier
function server.adapter.player.getIdentifier(player)
    return ""
end
