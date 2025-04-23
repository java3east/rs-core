---@class shared
shared = shared or {}

---@class shared.string
shared.string = {}

---Formats the given string
---@nodiscard
---@param str string
---@param params table<string, string>
---@return string formatted
function shared.string.format(str, params)
    for k, v in pairs(params) do
        if type(v) == "table" then
            v = shared.adapter.json.encode(v)
        end
        str = str:gsub("{" .. k .. "}", tostring(v))
    end
    return str
end

---Returns a random string of the given length
---@nodiscard
---@param length number
---@return string randomString
function shared.string.random(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        result = result .. chars:sub(randomIndex, randomIndex)
    end
    return result
end
