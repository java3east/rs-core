---@class Log
Log = {}

---@param msg string
---@param args table<string, any>?
function Log.debug(msg, args)
    if not Config.log.debug then
        return
    end

    local msg = StringUtils.format("[DEBUG] " .. msg, args or {})
    print(msg)
end

---@param msg string
---@param args table<string, any>?
function Log.info(msg, args)
    if not Config.log.info then
        return
    end

    local msg = StringUtils.format("[INFO] " .. msg, args or {})
    print(msg)
end

---@param msg string
---@param args table<string, any>?
function Log.warning(msg, args)
    if not Config.log.warn then
        return
    end

    local msg = StringUtils.format("[WARNING] " .. msg, args or {})
    print(msg)
end

---@param msg string
---@param args table<string, any>?
function Log.error(msg, args)
    if not Config.log.error then
        return
    end

    local msg = StringUtils.format("[ERROR] " .. msg, args or {})
    print(msg)
end
