---@class Inventory
---@field id number the id of this inventory. This is the same as the database id.
---@field slots table<number, Inventory.ItemStack> the slots of this inventory, with their items.
---@field slotCount number the amount of slots in this inventory.
---@field maxWeight number the maximum weight this inventory can hold.
Inventory = {}
setmetatable(Inventory, {
    __call = function(cls, id, slotCount, maxWeight)
        local obj = {}
        setmetatable(obj, Inventory)
        obj.id = id
        obj.slots = {}
        obj.slotCount = slotCount
        obj.maxWeight = maxWeight
        return obj
    end
})
Inventory.__index = Inventory

---@type Cache
local inventories = Cache()

---Creates a new inventory in the database and returns its id.
---@nodiscard
---@return number id the id of the newly created inventory.
local function createInventory()
    -- TODO: Create a new database entry for the inventory.
    --       This requires more intel on the HELIX scripting API.
    return 0
end

---Loads the inventory with the given id from the database.
---@param inventory Inventory the inventory to load data for
---@return boolean success true if the inventory was loaded successfully, false otherwise
local function load(inventory)
    -- TODO: Load the inventory data from the database.
    --       This requires more intel on the HELIX scripting API.
    return true
end

---Loads the inventory with the given id.
---@nodiscard
---@param id string the id of the inventory to load.
---@return Inventory? inventory the loaded inventory, or nil if it could not be loaded.
function Inventory.load(id, slots, maxWeight)
    return inventories:get(id, function ()
        local inventory = Inventory(id, slots, maxWeight)
        if load(inventory) then
            return inventory
        end
    end)
end

---Creates a new inventory
function Inventory.new(slots, maxWeight)
    local id = createInventory()
    return Inventory(id, slots, maxWeight)
end

---Sets the itemstack on the given slot.
---if the slot is already used the itemstack won't be added and
---this function returns false.
---@nodiscard
---@param slot number
---@param itemStack Inventory.ItemStack
---@return boolean set true if the item was put on that slot
function Inventory:set(slot, itemStack)
    if self.slots[slot] ~= nil then
       return false
    end
    self.slots[slot] = itemStack
    itemStack:update()
    return true
end

---Searches for an itemstack similar to the given itemstack.
---This will return the slots of the matches, if itemstacks
---with the same constructor and metadata were found, else 
---the array will be empty.
---@nodiscard
---@param itemstack Inventory.ItemStack
---@return number[] slots
function Inventory:find(itemstack)
    local slots = {}
    for slot, stack in pairs(self.slots) do
        if stack == itemstack then
            table.insert(slots, slot)
        end
    end
    return slots
end

---Returns the id of the next free slot in the inventory.
---@nodiscard
---@param start number? the slot to start searching from, defaults to 1
---@return number slot the id of the next free slot, or -1 if no free slot was found
function Inventory:findFreeSlot(start)
    for i = (start or 1), self.slotCount do
        if self.slots[i] == nil then
            return i
        end
    end
    return -1
end

---Returns the current weight of the inventory.
---@nodiscard
---@return number weight the current weight of the inventory
function Inventory:getWeight()
    local weight = 0
    for _, stack in pairs(self.slots) do
        weight = weight + stack:getWeight()
    end
    return weight
end

---Adds the given itemstack to the next free slot in the inventory, or
---if a stack of the same type with the same meta exists, the item will
---be added to that slot. This function will return false, if the item could
---not be added to the inventory.
---@nodiscard
---@param itemstack Inventory.ItemStack the itemstack that should be added
---@return boolean added true if the itemstack was added
function Inventory:add(itemstack)
    local matches = self:find(itemstack)
    if #matches == 0 then
        local slot = self:findFreeSlot()
        if slot == -1 then
            return false
        end
        self.slots[slot] = itemstack
        itemstack:update()
        return true
    end
    local stack = self.slots[matches[1]]
    stack.quantity = stack.quantity + itemstack.quantity
    itemstack:delete()
    stack:update()
    return true
end

---Removes the given quantity of the given itemstack from this inventory.
---If the quantity is greater than the amount in the inventory, it will
---remove all of it, if the ignoreMissing flag is set to true. If not
---it will return -1.
---@nodiscard
---@param itemstack Inventory.ItemStack the itemstack to remove
---@param quantity number the amount of items to remove
---@param ignoreMissing boolean? if true, it will not return -1 if the itemstack is not found, defaults to false
---@return number removed the amount of items that were removed, or -1 if the itemstack was not found and ignoreMissing is false
function Inventory:remove(itemstack, quantity, ignoreMissing)
    ignoreMissing = ignoreMissing or false
    local matches = self:find(itemstack)
    local totalQuantity = 0
    for _, slot in ipairs(matches) do
        totalQuantity = totalQuantity + self.slots[slot].quantity
    end
    if totalQuantity < quantity and not ignoreMissing then
        return -1
    end
    for _, slot in ipairs(matches) do
        local stack = self.slots[slot]
        if stack.quantity > quantity then
            stack.quantity = stack.quantity - quantity
            stack:update()
            return quantity
        elseif stack.quantity == quantity then
            self.slots[slot] = nil
            stack:delete()
            return quantity
        else
            quantity = quantity - stack.quantity
            self.slots[slot] = nil
            stack:delete()
        end
    end
    return totalQuantity - quantity
end

function Inventory:__tostring()
    return ("Inventory(id=%s, slotCount=%d, maxWeight=%.2f, slots=%s)"):format(
        self.id,
        self.slotCount,
        self.maxWeight,
        TableUtils.toString(self.slots)
    )
end
