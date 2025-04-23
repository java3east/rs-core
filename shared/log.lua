---@class shared
shared = shared or {}

---@class shared.log
shared.log = shared.log or {}

---Logs a debug message if debugging is enabled
---@param msg string the message to log
---@param params table<string, any> the parameters to format the message with
function shared.log.debug(msg, params)
    if not shared.config.log.debug then return end
    local formatted = shared.string.format(msg, params)
    print("[DEBUG] " .. formatted)
end

---Logs an info message if info logging is enabled
---@param msg string the message to log
---@param params table<string, any> the parameters to format the message with
function shared.log.info(msg, params)
    if not shared.config.log.info then return end
    local formatted = shared.string.format(msg, params)
    print("[INFO] " .. formatted)
end

---Logs a warning message if warning logging is enabled
---@param msg string the message to log
---@param params table<string, any> the parameters to format the message with
function shared.log.warning(msg, params)
    if not shared.config.log.warning then return end
    local formatted = shared.string.format(msg, params)
    print("[WARNING] " .. formatted)
end

---Logs an error message if error logging is enabled
---@param msg string the message to log
---@param params table<string, any> the parameters to format the message with
function shared.log.error(msg, params)
    if not shared.config.log.error then return end
    local formatted = shared.string.format(msg, params)
    print("[ERROR] " .. formatted)
end
