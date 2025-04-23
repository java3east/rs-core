---@class shared
shared = shared or {}

---@class shared.adapter
shared.adapter = shared.adapter or {}

---@class shared.adapter.json
shared.adapter.json = {}

---Converts the given table into a json string
---@nodiscard
---@param data table the data to convert
---@return string json string
function shared.adapter.json.encode(data)
    return "[]"
end

---Converts the given json string into a table
---@nodiscard
---@param str string the json string to convert
---@return table data the converted table
function shared.adapter.json.decode(str)
    return {}
end

