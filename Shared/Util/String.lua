---@class StringUtils
StringUtils = {}
StringUtils.__index = StringUtils

---Generates a random string based on the given format.
---@nodiscard
---@param format string the format of the random string.
--- 'a' for lowercase letters, 'A' for uppercase letters, '0' for digits.
---@return string randomString the generated random string
function StringUtils.randomString(format)
    local str = ""
    local chars = {
        ["a"] = "abcdefghijklmnopqrstuvwxyz",
        ["A"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        ["0"] = "0123456789"
    }
    for i = 1, #format do
        local char = format:sub(i, i)
        if chars[char] then
            local randomIndex = math.random(1, #chars[char])
            str = str .. chars[char]:sub(randomIndex, randomIndex)
        end
    end
    return str
end
