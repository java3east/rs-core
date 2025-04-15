---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.events
server.adapter.events = {}

---Registers the player join event
---@param cb fun(player: vplayer) the callback to call when a player joins
function server.adapter.events.onJoin(cb) end
