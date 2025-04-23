---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.events
server.adapter.events = {}

---Registers the given event and adds the given function as handler
---@param name string the name of the function
---@param fun fun(...: any) the function to register
function server.adapter.events.register(name, fun) end

---Registers the given event as network event and adds the given function as handler
---@param name string the name of the event
---@param fun fun(...: any) the handler function
function server.adapter.events.registerNet(name, fun) end

---Calls the given event
---@param name string the event to call
---@vararg any the parameters to pass to the event
function server.adapter.events.call(name, ...) end

---Calls the given network event on the given player
---@param name string the event to call
---@param vplayer vplayer the player to call the event on
---@vararg any the parameters to pass to the event
function server.adapter.events.callNet(name, vplayer, ...) end

---Registers the player join event
---@param cb fun(player: vplayer) the callback to call when a player joins
function server.adapter.events.onJoin(cb) end
