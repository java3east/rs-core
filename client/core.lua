---@class client
client = client or {}

---@class client.core
client.core = {}

---@type table<string, any>
client.core.playerData = {}

---@type number
local cid = 0

---@type table<number, fun(...: any)>
local callbacks = {}

local function nextCBID()
    cid = cid + 1
    return cid
end

function client.core.getPlayerData()
    return client.core.playerData
end

---Triggers the callback with the given name and returns the result
---@param name string the name of the callback to trigger
---@param cb fun(...: any) the function to call when the callback returns the result
---@vararg any the parameters to pass to the callback
function client.core.triggerAsyncCallback(name, cb, ...)
    local cbID = nextCBID()
    callbacks[cbID] = cb
    client.adapter.events.callNet("rs-core:async:callback:call", name, cbID, ...)
end

client.adapter.events.registerNet('rs-core:set:playerData', function (data)
    client.core.playerData = data
end)

client.adapter.events.registerNet('rs-core:async:callback:ret', function (cbid, ...)
    local cb = callbacks[cbid]
    if cb then
        callbacks[cbid] = nil
        cb(...)
    end
end)

shared.adapter.export.export("getCore", function()
    return client.core
end)

