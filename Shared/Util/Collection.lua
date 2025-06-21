---@class Collection
---@field collection table<any>
Collection = {}
setmetatable(Collection, {
    __call = function(self, collection)
        local instance = {}
        setmetatable(instance, self)
        instance.collection = collection or {}
        return instance
    end,
})
Collection.__index = Collection

---Adds the given value to the collection.
---@param value any the value to add to the collection
function Collection:add(value)
    table.insert(self.collection, value)
end

---Removes the given value from the collection.
---@param value any the value to remove from the collection
---@return boolean success true if the value was removed, false if it was not found
function Collection:remove(value)
    for i, v in ipairs(self.collection) do
        if v == value then
            table.remove(self.collection, i)
            return true
        end
    end
    return false
end

---Checks if the collection contains the given value.
---@nodiscard
---@param value any the value to check for
---@return boolean contains true if the value is in the collection, false otherwise
function Collection:contains(value)
    for _, v in ipairs(self.collection) do
        if v == value then
            return true
        end
    end
    return false
end

function Collection:__tostring()
    local str = "{"
    for _, value in ipairs(self.collection) do
        str = str .. tostring(value) .. ", "
    end
    str = str:sub(1, -3) .. "}"  -- Remove the last comma and space, then close the brace
    return str
end
