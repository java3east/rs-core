---@class Cache
---@field data table<any, any> the cache data
Cache = {}
setmetatable(Cache, {
    __call = function(t)
        local cache = {}
        setmetatable(cache, Cache)
        cache.data = {}
        return cache
    end
})
Cache.__index = Cache

---Returns the value associated with the given key in the cache.
---If the key does not exist, it will call the producer function
---to generate the value, store it in the cache, and return it.
---@nodiscard
---@param key any the key to retrieve the value for
---@param producer? fun(): any the function to call to produce the value if it does not exist
---@return any value the value associated with the key
function Cache:get(key, producer)
    if self.data[key] == nil and producer then
        self.data[key] = producer()
    end
    return self.data[key]
end

---Sets the value for the given key in the cache.
---@param key any the key to set the value for
---@param value any the value to set for the key
function Cache:set(key, value)
    self.data[key] = value
end

---Clears the cache.
---If a key is provided, it will only clear that key.
---@param key any? the key to clear, if nil it clears the entire cache
function Cache:clear(key)
    if key then
        self.data[key] = nil
    else
        self.data = {}
    end
end
