---@class TableUtils
TableUtils = {}

---Creates a deep copy of the given table.
---This is to avoid shallow copies where nested tables would still reference the original table.
---@nodiscard
---@param t table the table to copy
---@return table copy the deep copied table
function TableUtils:copy(t)
    if type(t) ~= "table" then
        return t
    end

    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = self:copy(v)
        else
            copy[k] = v
        end
    end

    return copy
end

---Converts a table to a string representation.
---@nodiscard
---@param t table
---@return string str the string representation of the table
function TableUtils.toString(t)
    if type(t) ~= "table" then
        return tostring(t)
    end

    if t.__tostring then
        return t:__tostring()
    end

    local str = "{"
    for k, v in pairs(t) do
        if type(k) == "string" then
            str = str .. k .. "="
        else
            str = str .. "[" .. tostring(k) .. "]="
        end

        if type(v) == "table" then
            if v.__tostring then
                str = str .. v:__tostring()
            else
                str = str .. TableUtils.toString(v)
            end
        else
            str = str .. tostring(v)
        end

        str = str .. ", "
    end

    if #str > 1 then
        str = str:sub(1, -3)
    end

    return str .. "}"
end
