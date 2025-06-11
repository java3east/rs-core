---@class Inventory
---@field id number the id of this inventory. This is the same as the database id.
---@field slots table<number, Inventory.ItemStack> the slots of this inventory, with their items.
Inventory = {}
setmetatable(Inventory, {
    __call = function(cls, id)
        local obj = {}
        setmetatable(obj, Inventory)
        obj.id = id
        obj.slots = {}
        return obj
    end
})
Inventory.__index = Inventory

---Creates a new inventory in the database and returns its id.
---@nodiscard
---@return number id the id of the newly created inventory.
local function createInventory()
    -- TODO: Create a new database entry for the inventory.
    --       This requires more intel on the HELIX scripting API.
    return 0
end

---Loads the inventory with the given id.
---@nodiscard
---@param id string the id of the inventory to load.
---@return Inventory? inventory the loaded inventory, or nil if it could not be loaded.
function Inventory.load(id)
    -- TODO: Load the inventory from the database.
    --       This requires more intel on the HELIX scripting API.
end

---Creates a new inventory
function Inventory.new()
    local id = createInventory()
    return Inventory(id)
end


