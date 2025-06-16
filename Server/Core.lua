---@class Server.Core
Core = {}

---@type table<Player, CPlayer> the mapping of Player objects to their corresponding CPlayer objects.
local players = {}

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
    players[player] = cPlayer
    playersByIdentifier[cPlayer:getIdentifier()] = cPlayer
    Log.info("Player {name} joined with identifier {identifier}.", {name = player:GetName(), identifier = cPlayer:getIdentifier()})
end

---Called when a player quits the server.
---This removes the player object from the player mappings and logs out the player.
---@param player Player the player that is quitting the server.
local function onQuit(player)
    local cPlayer = players[player]
    if not cPlayer then return end
    cPlayer:logout()
    players[player] = nil
    playersByIdentifier[cPlayer:getIdentifier()] = nil
end

---Returns a list of all players that are currently online.
---@nodiscard
---@return CPlayer[] players the list of all online players.
function Core.getPlayers()
    local playerList = {}
    for _, cPlayer in pairs(players) do
        table.insert(playerList, cPlayer)
    end
    return playerList
end

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

---Adds the given function to the given object.
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

---With this function new modules can be added or old ones can be replaced.
---@param name string the name of the module to set
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
