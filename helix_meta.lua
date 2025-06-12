---@meta HELIX

---@class Package
Package = {}

---@param path string the path to the file that should be loaded
---at this point in the program
function Package.Require(path) end

---@class Player

---@class Events
Events = {}

---Calls the given event with the given arguments.
---@param event string the name of the event to call
---@vararg any the arguments to pass to the event handler
function Events.Call(event, ...) end

---Calls the given event on the server.
---@param event string the name of the event to call
---@vararg any the arguments to pass to the event handler
function Events.CallRemote(event, ...) end

---Calls the given event on the given client.
---@param event string the name of the event to call
---@param player Player the player to call the event on
---@vararg any the arguments to pass to the event handler
function Events.CallRemote(event, player, ...) end

---Subscribes to the given event.
---@param event string the name of the event to subscribe to
---@param callback fun(...: any) the function to call when the event is triggered
function Events.Subscribe(event, callback) end

---Subscribes to the given event over the network.
---@param event string the name of the event to subscribe to
---@param callback fun(...: any) the function to call when the event is triggered
function Events.SubscribeRemote(event, callback) end
