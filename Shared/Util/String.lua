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

---Splits the given string by the given separator.
---@nodiscard
---@param str string the string to split
---@param sep string the separator to split by
---@return string[] parts the parts of the string after splitting
function StringUtils.split(str, sep)
    local t = {}
    for part in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, part)
    end
    return t
end

---Formats the given string with the given arguments.
---This will replace {key} with the value of args[key].
---@nodiscard
---@param str string the string to format
---@param args table<string, any> args the arguments to format the string with
---@return string formattedStr the formatted string
function StringUtils.format(str, args)
    local formattedStr = str
    for key, value in pairs(args) do
        formattedStr = formattedStr:gsub("{" .. key .. "}", tostring(value))
    end
    return formattedStr
end
