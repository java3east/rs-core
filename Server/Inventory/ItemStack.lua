---@class Inventory.ItemStack
---@field id number the id of this item stack. This is the same as the database id.
---@field name string the name of the item
---@field quantity number the amount of the item in this stack
---@field metadata table<string, any> the metadata of the item
---@field state 'update'|'delete'|'none' the operation that should be performed on the item stack in the database.s
ItemStack = {}
setmetatable(ItemStack, {
    __call = function(cls, id, name, quantity, metadata)
        local obj = {}
        setmetatable(obj, ItemStack)
        obj.id = id
        obj.name = name
        obj.quantity = quantity
        obj.metadata = metadata
        obj.state = 'none'
        return obj
    end
})
ItemStack.__index = ItemStack

---@class Inventory.ItemStack.Constructor
---@field name string the name of the item
---@field label string the display name of the item
---@field description string the description of the item
---@field weight number the weight of the item


---@type table<string, Inventory.ItemStack.Constructor>
local constructors = {}

---Creates a new item stack in the database and returns its id.
---@nodiscard
---@param name string the name of the item
---@param quantity number the amount of the item in this stack
---@param metadata table<string, any> the metadata of the item
---@return number id the id of the newly created item stack.
local function createItemStack(name, quantity, metadata)
    -- TODO: Create a new database entry for the item stack.
    --       This requires more intel on the HELIX scripting API.
    return 0
end

---Adds a new item stack constructor to the list of constructors.
---@param name string the name of the item
---@param label string the display name of the item
---@param description string the description of the item
---@param weight number the weight of the item
function ItemStack.createConstructor(name, label, description, weight)
    constructors[name] = {
        name = name,
        label = label,
        description = description,
        weight = weight
    }
end

---Creates a new itemstack with the given name, quantity, and metadata.
---@nodiscard
---@param name string the name of the item
---@param quantity number the amount of the item in this stack
---@param metadata table<string, any> the metadata of the item
---@return Inventory.ItemStack itemStack the newly created item stack.
function ItemStack.new(name, quantity, metadata)
    local id = createItemStack(name, quantity, metadata)
    return ItemStack(id, name, quantity, metadata)
end

---Returns the constructor of this item stack.
---@nodiscard
---@return Inventory.ItemStack.Constructor? constructor the constructor of this item stack, or nil if it does not exist.
function ItemStack:getConstructor()
    return constructors[self.name]
end

function ItemStack:getWeight()
    local constructor = self:getConstructor()
    if constructor then
        return constructor.weight * self.quantity
    end
    return 0
end

---Marks this item stack for deletion.
function ItemStack:delete()
    self.state = 'delete'
end

---Marks this item stack for update in the database.
function ItemStack:update()
    self.state = 'update'
end

function ItemStack:__eq(other)
    if type(self) ~= type(other) then return false end
    if self.name ~= other.name then return false end
    for key, value in pairs(self.metadata) do
        if other.metadata[key] ~= value then return false end
    end
        for key, value in pairs(other.metadata) do
        if self.metadata[key] ~= value then return false end
    end
    return true
end
