---@class LogSystem
---@field current table<LogSystem.LogEntry> the current log entries in the system
LogSystem = {}
setmetatable(LogSystem, {
    __call = function(self)
        local obj = {}
        setmetatable(obj, self)
        obj.current = {}
        return obj
    end
})
LogSystem.__index = LogSystem

---@class LogSystem.LogEntry
---@field timestamp number the timestamp of the log entry
---@field resource string the name of the resource that created the log entry
---@field tags table<string> a list of tags for the log entry
---@field message string the message of the log entry
---@field data table<string, string> additional data for the log entry (e.g. identifier, etc.)

---Adds the given entry to the log system. And saves it to the database.
---@param system LogSystem the log system to add the entry to
---@param entry LogSystem.LogEntry
local function addEntry(system, entry)
    -- TODO: Save the entry to the database
    --       This requires more info on the HELIX API
    table.insert(system.current, entry)
end

---Creates a new log entry.
---@param resource string the name of the resource that created the log entry
---@param tags table<string> a list of tags for the log entry
---@param message string the message of the log entry
---@param data table<string, string> additional data for the log entry (e.g. identifier, etc.)
---@return LogSystem.LogEntry entry
function LogSystem:createEntry(resource, tags, message, data)
    local entry = {
        timestamp = os.time(),
        resource = resource,
        tags = tags or {},
        message = message,
        data = data or {}
    }

    addEntry(self, entry)
    return entry
end

---@class LogSystem.LogFilter
---@field startTime number the start time of the filter (default: 0)
---@field endTime number the end time of the filter (default: current time)
---@field tags table<string> a list of tags to filter by
---@field values table<string> a list of values that must be present in the log entry data
---@field kvps table<string, string> a list of key-value pairs that must be present
LogSystem.Filter = {}
setmetatable(LogSystem.Filter, {
    __call = function(self, startTime, endTime)
        local obj = {}
        setmetatable(obj, self)
        obj.startTime = startTime or 0
        obj.endTime = endTime or os.time()
        obj.tags = {}
        obj.values = {}
        obj.kvps = {}
        return obj
    end
})
LogSystem.Filter.__index = LogSystem.Filter

---Adds a tag to the filter.
---Only one filter must be present in the log entry for it to match.
---@param tag string the tag to add
---@return LogSystem.LogFilter self
function LogSystem.Filter:tag(tag)
    table.insert(self.tags, tag)
    return self
end

---Adds a required value to the filter.
---All values must be present in the log entry data for it to match.
---@param value string the value to add
---@return LogSystem.LogFilter self
function LogSystem.Filter:value(value)
    table.insert(self.values, value)
    return self
end

---Adds a key-value pair to the filter.
---The log entry must contain this key with the specified value for it to match.
---@param key string the key to add
---@param value string the value to add
function LogSystem.Filter:kvp(key, value)
    self.kvps[key] = value
    return self
end

---Checks if the given entry matches the filter criteria.
---@nodiscard
---@param entry LogSystem.LogEntry the log entry to check
---@return boolean matches true if the entry matches the filter criteria, false otherwise
function LogSystem.Filter:match(entry)

    if entry.timestamp < self.startTime or entry.timestamp > self.endTime then
        return false
    end

    local hasOne = self.tags == nil or #self.tags == 0
    local tags = Collection(entry.tags) --[[@as Collection]]
    for _, tag in ipairs(self.tags) do
        if tags:contains(tag) then
            hasOne = true
        end
    end
    if not hasOne then
        return false
    end

    for _, value in ipairs(self.values) do
        local found = false
        for _, v in pairs(entry.data) do
            if v == value then
                found = true
                break
            end
        end
        if not found then
            return false
        end
    end

    for key, value in pairs(self.kvps) do
        if entry.data[key] ~= value then
            return false
        end
    end

    return true
end

---Returns all the log entries that match the filter criteria.
---@nodiscard
---@return table<LogSystem.LogEntry> filtered the filtered log entries
function LogSystem.Filter:apply(system)
    local filtered = {}

    for _, entry in ipairs(system.current) do
        if self:match(entry) then
            table.insert(filtered, entry)
        end
    end

    return filtered
end
