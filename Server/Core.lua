---@class Server.Core
Core = {}

---@type table<Player, CPlayer> the mapping of Player objects to their corresponding CPlayer objects.
local players = {}

---@type table<string, CPlayer> the mapping of player identifiers to their corresponding CPlayer objects.
local playersByIdentifier = {}

---Returns the CPlayer object for the given Player object or identifier.
---@nodiscard
---@param player Player|string the player or player identifier to get the CPlayer object for.
---@return CPlayer? cplayer the core player object for the given player.
function Core.getPlayer(player)
    local isIdentifier = type(player) == 'string'
    if isIdentifier then
        return playersByIdentifier[player]
    else
        return players[player]
    end
end
