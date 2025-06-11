---A core character holds all the information about a character.
---@class CCharacter
---@field possesedBy CPlayer? the player that is currently playing this character.
---@field citizenId string the unique id of the character.
CCharacter = {}
CCharacter.__index = CCharacter

---@class CCharacter.Data
---@field citizenId string the unique id of the character.

---Creates a new core character object.
---@nodiscard
---@param id string? the id of the character. This should be unique.
--- if not provided, a random id will be generated, and when saved,
--- it will be added to the database.
---@return CCharacter ccharacter the new core character object.
function CCharacter.new(id)
    local cCharacter = {}
    setmetatable(cCharacter, CCharacter)
    cCharacter.citizenId = id or Config.generateCharacterId()
    return cCharacter
end

---Marks this character as active for the given player.
---A character can only be active for one player at a time.
---@param cPlayer CPlayer the player to set this character as active for.
---@return boolean success true if the character was successfully set as active for the player, false otherwise.
function CCharacter:wake(cPlayer)
    if self.possesedBy then
        return false
    end

    self.possesedBy = cPlayer
    cPlayer:trigger('rs:core:character:wake', self:getData())
    return true
end

---Returns the data of this character.
---This data can be used to be sent to the client.
---@nodiscard
---@return CCharacter.Data data the data of this character.
function CCharacter:getData()
    return {
        citizenId = self.citizenId
    }
end

---Marks this character as inactive.
---This will remove the player that is currently playing this character.
function CCharacter:sleep()
    local cPlayer = self.possesedBy
    self.possesedBy = nil
    if cPlayer then
        cPlayer:trigger('rs:core:character:sleep', self:getData())
    end
end
