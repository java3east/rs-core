---@class CPlayer
---@field player Player the helix player object
---@field activeCharacter CCharacter?
CPlayer = {}
CPlayer.__index = CPlayer

---Creates a new CPlayer instance.
---@nodiscard
---@param player Player the helix player object
---@return CPlayer cPlayer the new CPlayer instance
function CPlayer.new(player)
    local cPlayer = {}
    setmetatable(cPlayer, CPlayer)
    cPlayer.player = player

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

---Triggers the given event on this player.
---@param event string the name of the event to trigger
---@param ... any the arguments to pass to the event handler
function CPlayer:trigger(event, ...)
    -- TODO: implement a net event trigger
    --       this requires more intel on the HELIX scripting API
end

---Called when the player leaves the server.
---This will save the current character and do all the necessary cleanup.
function CPlayer:logout()
    self:setActiveCharacter(nil)
end
