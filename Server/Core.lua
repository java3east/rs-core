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
