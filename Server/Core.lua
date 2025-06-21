---@diagnostic disable: undefined-field
---@class Server.Core
Core = {}
Core.LogSystem = LogSystem()

---@type table<string, CPlayer> the mapping of player identifiers to their corresponding CPlayer objects.
local playersByIdentifier = {}

---Called when a player joins the server.
---This creates the player object and adds it to the player mappings.
---@param player Player the player that just joined the server.
local function onJoin(player)
    local cPlayer = CPlayer.load(player)
    if not cPlayer then
       cPlayer = CPlayer.new(player)
    end
    playersByIdentifier[cPlayer:getIdentifier()] = cPlayer
    Log.info("Player {name} joined with identifier {identifier}.", {name = player:GetName(), identifier = cPlayer:getIdentifier()})
    Core.LogSystem:createEntry(
        "rs-core",
        {"join"},
        StringUtils.format("Player {name} joined the server with identifier {identifier}.", {
            name = player:GetName(),
            identifier = cPlayer:getIdentifier()
        }),
        {identifier = cPlayer:getIdentifier()}
    )
end

---Called when a player quits the server.
---This removes the player object from the player mappings and logs out the player.
---@param player Player the player that is quitting the server.
local function onQuit(player)
    Log.info("Player {name} left the server.", {name = player:GetName()})
    Core.LogSystem:createEntry(
        "rs-core",
        {"quit"},
        StringUtils.format("Player {name} left the server.", {name = player:GetName()}),
        {identifier = player:GetIdentifier()}
    )
    local cPlayer = playersByIdentifier[player:GetIdentifier()]
    if not cPlayer then return end
    cPlayer:logout()
    playersByIdentifier[cPlayer:getIdentifier()] = nil
end

---Returns a list of all players that are currently online.
---@nodiscard
---@return CPlayer[] players the list of all online players.
function Core.getPlayers()
    local playerList = {}
    for _, cPlayer in pairs(playersByIdentifier) do
        table.insert(playerList, cPlayer)
    end
    return playerList
end

---Returns the CPlayer object for the given Player object or identifier. This will only return players
---that are currently online. To get an offline player, you should use the static functions in the CPlayer class.
---@nodiscard
---@param player Player|string the player or player identifier to get the CPlayer object for.
---@return CPlayer? cplayer the core player object for the given player.
function Core.getPlayer(player)
    local isIdentifier = type(player) == 'string'
    if isIdentifier then
        return playersByIdentifier[player]
    else
        ---@cast player Player
        return playersByIdentifier[player:GetIdentifier()]
    end
end

---Adds the given function to the given object. This allowes to replace a single function in a module. This can be used to
---usefull if the function to replace is in a big module, e.g. the inventory system, and you only want to
---replace a single function in it, e.g. the function that handles the item usage and add a log message or something like that.
---@param object string the name of the object to add the function to ("<object>.<object>" to select a nested object)
---@param name string the name of the function to add
---@param func fun(...) : ... the function to add
function Core.addFunction(object, name, func)
    local objNames = StringUtils.split(object, ".")
    local obj = _G
    for _, objName in ipairs(objNames) do
        obj = obj[objName]
    end
    obj[name] = func
end

---With this function new modules can be added or old ones can be replaced. This can be used to e.g. override the
---inventory system or add a new module as a library to the core that may is required by another module / resource.
---@param name string the name of the module to set. This can be a nested module like "Core.Module.SubModule".
---@param module table the module to set, which should contain functions and properties.
function Core.setModule(name, module)
    local objNames = StringUtils.split(name, ".")
    local parent = nil
    local obj = _G
    for _, objName in ipairs(objNames) do
        if not obj[objName] then
            obj[objName] = {}
        end
        parent = obj
        obj = obj[objName]
    end
    parent[objNames[#objNames]] = module
end

---Checks if the given module is registered to the core. This can be used in scripts that require a specific module
---that is not guaranteed to be present, e.g. a module that is only available, if a specific resource is started.
---@nodiscard
---@param name string the name of the module to check. This can be a nested module like "Core.Module.SubModule".
---@return boolean isRegistered true if the module is registered, false otherwise.
function Core.hasModule(name)
    local objNames = StringUtils.split(name, ".")
    local obj = _G
    for _, objName in ipairs(objNames) do
        if not obj[objName] then
            return false
        end
        obj = obj[objName]
    end
    return true
end

---Registers a new item in the core item registry. This allowes the creation
---of itemsstacks of the given type.
---@param name string the name of the item
---@param label string the display name of the item
---@param description string the description of the item
---@param weight number the weight of the item
function Core.registerItem(name, label, description, weight)
    ItemStack.createConstructor(name, label, description, weight)
end

Player.Subscribe('Spawn', onJoin)
Player.Subscribe('Destroy', onQuit)

Events.Subscribe('rs:core:player:new', function()
  -- TODO: just to ignore warnings.
end)

Package.Export('Core', Core)
