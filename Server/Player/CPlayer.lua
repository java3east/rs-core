---@class CPlayer
---@field player Player the helix player object
---@field activeCharacter CCharacter?
---@field data Cache the data cache for this player
CPlayer = {}
setmetatable(CPlayer, {
    __call = function (t, player)
        local cPlayer = {}
        setmetatable(cPlayer, CPlayer)
        cPlayer.player = player
        cPlayer.data = Cache() --[[@as Cache]]
        local identifier = player:getIdentifier()
        cPlayer.data:set('identifier', identifier)
        return cPlayer
    end
})
CPlayer.__index = CPlayer

---Creates a new entry in the database for this player.
---@param cPlayer CPlayer the player to create an entry for
local function create(cPlayer)
    -- TODO: implement the database creation logic
    --       this requires more intel on the HELIX scripting API
end

---Loads the data for the given player from the database.
---@nodiscard
---@param cPlayer CPlayer the player to load data for
---@return boolean success true if the data was loaded successfully, false otherwise
local function load(cPlayer)
    -- TODO: implement the database loading logic
    --       this requires more intel on the HELIX scripting API
    return true
end

---Loads the cPlayer object for the given player.
---If the player does not have an entry in the database, it will return nil.
---@nodiscard
---@param player Player the helix player object
---@return CPlayer? cPlayer the loaded CPlayer instance or nil if the player does not have an entry
function CPlayer.load(player)
    local cPlayer = CPlayer(player)
    if not load(cPlayer) then
        return nil
    end
    return cPlayer
end

---Creates a new CPlayer Object that will be saved directly into the database.
---@nodiscard
---@param player Player the helix player object
---@return CPlayer cPlayer the new CPlayer instance
function CPlayer.new(player)
    local cPlayer = CPlayer(player)
    create(cPlayer)

    -- we may need to add all the functions here since metatables might not work.
    -- at least they didn't work in fivem when sharing this object with other scripts.

    return cPlayer
end

---Returns the character the player is currently playing.
---This will return nil if the player is currently not playing any character.
---@nodiscard
---@return CCharacter? activeCharacter the character that is currently active for the player.
function CPlayer:getActiveCharacter()
    return self.activeCharacter
end

---Sets the character the player is currently playing.
---@param character CCharacter? the character to set as active for this player.
function CPlayer:setActiveCharacter(character)
    if self.activeCharacter then
        self.activeCharacter:sleep()
        self.activeCharacter = nil
    end
    if character and character:wake(self) then
        self.activeCharacter = character
    end
end

---Returns whether or not the player is currently in a character.
---Players are not in a character when they just joined the server, and are currently in the
---multicharacter selection menu.
---@nodiscard
---@return boolean inCharacter true if the player is currently in a character, false otherwise.
function CPlayer:isInCharacter()
    return self.activeCharacter ~= nil
end

function CPlayer:getIdentifier()
    return self.data:get('identifier')
end

---Triggers the given event on this player.
---@param event string the name of the event to trigger
---@param ... any the arguments to pass to the event handler
function CPlayer:trigger(event, ...)
    Events.CallRemote(event, self.player, ...)
end

---Called when the player leaves the server.
---This will save the current character and do all the necessary cleanup.
function CPlayer:logout()
    self:setActiveCharacter(nil)
end
