---A core character holds all the information about a character.
---@class CCharacter
---@field possesedBy CPlayer? the player that is currently playing this character.
---@field citizenId string the unique id of the character.
---@field firstName string the first name of the character.
---@field lastName string the last name of the character.
---@field dateOfBirth string the date of birth of the character in the format YYYY-MM
---@field gender boolean false: male, true: female
CCharacter = {}
setmetatable(CCharacter, {
    __call = function(t, id)
        local cCharacter = {}
        setmetatable(cCharacter, CCharacter)
        cCharacter.citizenId = id
        return cCharacter
    end
})
CCharacter.__index = CCharacter

---@class CCharacter.Data
---@field citizenId string the unique id of the character.
---@field firstName string the first name of the character.
---@field lastName string the last name of the character.
---@field dateOfBirth string the date of birth of the character in the format YYYY-MM
---@field gender boolean true if the character is Female

---@type Cache
local characters = Cache()

---Creates a new entry in the database for this character.
---@param cCharacter CCharacter the character to create an entry for
local function create(cCharacter)
    -- TODO: implement the database creation logic
    --       this requires more intel on the HELIX scripting API
end

---Loads the data for the given character from the database.
---This will return true if the character was loaded successfully, false otherwise.
---@nodiscard
---@param cCharacter CCharacter the character to load data for
---@return boolean success true if the data was loaded successfully, false otherwise
local function load(cCharacter)
    -- TODO: implement the database loading logic
    --       this requires more intel on the HELIX scripting API
    return true
end

---Loads the core character object for the given citizenId.
---@nodiscard
---@param citizenId string the unique id of the character to load.
---@return CCharacter? cCharacter the loaded CCharacter instance or nil if the character does not have an entry.
function CCharacter.load(citizenId)
    return characters:get(citizenId, function()
        local cCharacter = CCharacter(citizenId)
        if load(cCharacter) then
            return cCharacter
        end
    end)
end

---Creates a new core character object and saves it into the database.
---This will generate a new citizenId for the character.
---@nodiscard
---@return CCharacter ccharacter the new core character object.
function CCharacter.new(firstName, lastName, dateOfBirth, gender)
    local id = Config.generateCharacterId()
    local cCharacter = CCharacter(id)
    cCharacter.firstName = firstName
    cCharacter.lastName = lastName
    cCharacter.dateOfBirth = dateOfBirth
    cCharacter.gender = gender
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

---Returns the full name of this character.
---@nodiscard
---@return string name the full name of this character.
function CCharacter:getName()
    return self.firstName .. ' ' .. self.lastName
end

---Returns the data of this character.
---This data can be used to be sent to the client.
---@nodiscard
---@return CCharacter.Data data the data of this character.
function CCharacter:getData()
    return {
        citizenId = self.citizenId,
        firstName = self.firstName,
        lastName = self.lastName,
        dateOfBirth = self.dateOfBirth,
        gender = self.gender
    }
end

---Checks if this character is a female.
---@nodiscard
---@return boolean isFemale true if the character is Female.
function CCharacter:isFemale()
    return self.gender
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
