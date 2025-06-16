local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Collection = ENVIRONMENT_GET_VAR(env, "Collection")

Test.new('Collection should exist', function (self)
    -- given
    local collection = Collection()

    -- when
    local exists = collection ~= nil

    -- then
    return Test.assert(exists, "Collection should exist")
end)

Test.new('Collection should be empty on creation', function (self)
    -- given
    local collection = Collection()

    -- when
    local isEmpty = #collection.collection == 0

    -- then
    return Test.assert(isEmpty, "Collection should be empty on creation")
end)

Test.new('Collection:add should add a value', function (self)
    -- given
    local collection = Collection()
    local value = "testValue"

    -- when
    collection:add(value)

    -- then
    return Test.assert(collection:contains(value), "Collection should contain the added value")
end)

Test.new('Collection:remove should remove a value', function (self)
    -- given
    local collection = Collection()
    local value = "testValue"
    collection:add(value)

    -- when
    local removed = collection:remove(value)

    -- then
    return Test.assert(removed and not collection:contains(value), "Collection should not contain the removed value")
end)

Test.new('Collection:contains should return true for existing value', function (self)
    -- given
    local collection = Collection()
    local value = "testValue"
    collection:add(value)

    -- when
    local contains = collection:contains(value)

    -- then
    return Test.assert(contains, "Collection should contain the value")
end)

Test.new('Collection:contains should return false for non-existing value', function (self)
    -- given
    local collection = Collection()
    local value = "testValue"

    -- when
    local contains = collection:contains(value)

    -- then
    return Test.assert(not contains, "Collection should not contain the value")
end)

Test.new('Collection:__tostring should return a string representation of the collection', function (self)
    -- given
    local collection = Collection()
    collection:add("value1")
    collection:add("value2")

    -- when
    local str = tostring(collection)

    -- then
    return Test.assertEqual(str, "{value1, value2}", "Collection:__tostring should return the correct string representation")
end)
