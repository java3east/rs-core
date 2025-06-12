local simulation = SIMULATION_CREATE("HELIX")
local client1 = SIMULATOR_CREATE(simulation, "CLIENT")
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(client1, resource)
local Cache = ENVIRONMENT_GET_VAR(env, "Cache")

Test.new('cache should exist', function()
    return Test.assert(Cache ~= nil, "Cache should not be nil")
end)

Test.new('cache get should call producer on nil value', function (self)
    -- given
    local cache = Cache()

    -- when
    local result = cache:get('test', function ()
        return 'produced_value'
    end)

    -- then
    return Test.assert(result == 'produced_value', "Cache get should return the produced value when the key does not exist")
end)

Test.new('cache get should return existing value', function (self)
    -- given
    local cache = Cache()
    cache:set('test', 'existing_value')

    -- when
    local result = cache:get('test', function ()
        return 'produced_value'
    end)

    -- then
    return Test.assert(result == 'existing_value', "Cache get should return the existing value when the key exists")
end)

Test.new('cache should clear only 1 value when key is provided', function (self)
    -- given
    local cache = Cache()
    cache:set('test1', 'value1')
    cache:set('test2', 'value2')

    -- when
    cache:clear('test1')

    -- then
    return Test.assert(cache.data['test1'] == nil and cache.data['test2'] == 'value2', "Cache should clear only the specified key")
end)

Test.new('cache should clear all values when no key is provided', function (self)
    -- given
    local cache = Cache()
    cache:set('test1', 'value1')
    cache:set('test2', 'value2')

    -- when
    cache:clear()

    -- then
    return Test.assert(next(cache.data) == nil, "Cache should be empty after clearing without a key")
end)

Test.runAll("Shared.Cache")
