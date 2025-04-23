---@class client
client = client or {}

---@class client.adapter
client.adapter = client.adapter or {}

---@class client.adapter.events
client.adapter.events = {}

---Registers the given event and adds the given function as handler
---@param name string the name of the event
---@param fun fun(...: any) the function to register
function client.adapter.events.register(name, fun) end

---Registers the given event as net event with the given handler
---@param name string the name of the event
---@param fun fun(...: any) the function to register
function client.adapter.events.registerNet(name, fun) end

---Calls the given event
---@param name string the name of the event to call
---@vararg any the parameters to pass to the event
function client.adapter.events.call(name, ...) end

---Calls the given event on the server
---@param name string the event to call on the server
---@vararg any the parameters to pass to the event
function client.adapter.events.callNet(name, ...) end
