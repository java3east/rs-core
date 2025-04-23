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
