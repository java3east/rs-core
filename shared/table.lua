---@class shared
shared = shared or {}

---@class shared.table
shared.table = {}

---Returns the index of the first occurrence of the given value in the table.
---@nodiscard
---@param tbl table the table to search in
---@param value any the value to search for
---@return integer? index the index of the first occurrence of the value, or nil if not found
function shared.table.find(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end
