---@class server
server = server or {}

---@class server.core
server.core = {}

---Returns the player object for the given vPlayer
---@nodiscard
---@param vPlayer vplayer
---@return server.player? player the player object
function server.core.getPlayer(vPlayer)
    return server.player.get(vPlayer)
end

shared.adapter.export.export("getCore", function()
    return server.core
end)
