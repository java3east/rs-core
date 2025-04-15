---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.net
server.adapter.net = {}

---Triggers a net event for the given player
---@param player vplayer the player to trigger the event for
---@param event string the name of the event
---@vararg any the event parameters
function server.adapter.net.triggerNetEvent(player, event, ...) end

