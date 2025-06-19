local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local LogSystem = ENVIRONMENT_GET_VAR(env, "LogSystem")

Test.new('LogSystem should exist', function (self)
    return Test.assert(LogSystem ~= nil, "LogSystem should not be nil")
end)

Test.new('LogSystem:createEntry should create a log entry', function (self)
    -- given
    local system = LogSystem()
    local resourceName = "TestResource"
    local tags = {"test", "log"}
    local message = "This is a test log entry"
    local data = {identifier = "test_id"}

    -- when
    local entry = system:createEntry(resourceName, tags, message, data)

    -- then
    return Test.assert(entry ~= nil, "Log entry should not be nil") and
           Test.assert(entry.resource == resourceName, "Log entry resource should match") and
           Test.assert(entry.tags[1] == tags[1], "Log entry tags should match") and
           Test.assert(entry.message == message, "Log entry message should match") and
           Test.assert(entry.data.identifier == data.identifier, "Log entry data should match")
end)

Test.new('LogSystem.Filter should exist', function (self)
    return Test.assert(LogSystem.Filter ~= nil, "LogSystem.Filter should not be nil")
end)

Test.new('LogSystem.Filter:match should return true for matching entry', function (self)
    -- given
    local system = LogSystem()
    local filter = LogSystem.Filter()
    local entry = system:createEntry("TestResource", {"test"}, "Test message", {identifier = "test_id"})

    -- when
    local matches = filter:match(entry)

    -- then
    return Test.assert(matches == true, "Filter should match the entry")
end)

Test.new('LogSystem.Filter:apply should return filtered entries', function (self)
    -- given
    local system = LogSystem()
    local filter = LogSystem.Filter()
    local entry1 = system:createEntry("TestResource1", {"test"}, "Test message 1", {identifier = "test_id_1"})
    local entry2 = system:createEntry("TestResource2", {"test"}, "Test message 2", {identifier = "test_id_2"})

    -- when
    local filteredEntries = filter:apply(system)

    -- then
    return Test.assertEqual(#filteredEntries, 2, "Filter should return all entries") and
           Test.assert(filteredEntries[1].message == entry1.message, "First filtered entry should match entry 1") and
           Test.assert(filteredEntries[2].message == entry2.message, "Second filtered entry should match entry 2")
end)

Test.new('LogSystem.Filter:apply should return empty table for no matching entries', function (self)
    -- given
    local system = LogSystem()
    local filter = LogSystem.Filter(os.time() + 1000, os.time() + 2000) -- future time range
    local entry = system:createEntry("TestResource", {"test"}, "Test message", {identifier = "test_id"})

    -- when
    local filteredEntries = filter:apply(system)

    -- then
    return Test.assert(#filteredEntries == 0, "Filter should return empty table for no matching entries")
end)

Test.new('LogSystem.Filter:tag should apply filter with tags', function (self)
    -- given
    local system = LogSystem()
    local filter = LogSystem.Filter():tag("test")
    local entry1 = system:createEntry("TestResource1", {"test"}, "Test message 1", {identifier = "test_id_1"})
    local entry2 = system:createEntry("TestResource2", {"other"}, "Test message 2", {identifier = "test_id_2"})

    -- when
    local filteredEntries = filter:apply(system)

    -- then
    return Test.assertEqual(#filteredEntries, 1, "Filter should return one entry with 'test' tag") and
           Test.assert(filteredEntries[1].message == entry1.message, "Filtered entry should match entry 1")
end)

Test.new('LogSystem.Filter:tag should require at least one tag', function (self)
    -- given
    local filter = LogSystem.Filter()
    local system = LogSystem()
    local entry = system:createEntry("TestResource", {"test"}, "Test message", {identifier = "test_id"})
    local entry2 = system:createEntry("TestResource2", {"other"}, "Test message 2", {identifier = "test_id_2"})

    -- when
    filter:tag("test"):tag("other")
    local matches = filter:apply(system)

    -- then
    return Test.assert(#matches == 2, "Filter should match both entries with multiple tags") and
           Test.assert(matches[1].message == entry.message, "First matched entry should be the first entry") and
           Test.assert(matches[2].message == entry2.message, "Second matched entry should be the second entry")
end)

Test.new('LogSystem.Filter:value should apply filter with values', function (self)
    -- given
    local system = LogSystem()
    local filter = LogSystem.Filter():value("test_value")
    local entry1 = system:createEntry("TestResource1", {"test"}, "Test message 1", {identifier = "test_id_1", value = "test_value"})
    local entry2 = system:createEntry("TestResource2", {"other"}, "Test message 2", {identifier = "test_id_2", value = "other_value"})

    -- when
    local filteredEntries = filter:apply(system)

    -- then
    return Test.assertEqual(#filteredEntries, 1, "Filter should return one entry with 'test_value'") and
           Test.assert(filteredEntries[1].message == entry1.message, "Filtered entry should match entry 1")
end)

Test.new('LogSystem.Filter:kvp should apply filter with key-value pairs', function (self)
    -- given
    local system = LogSystem()
    local filter = LogSystem.Filter():kvp("key1", "value")
    local entry1 = system:createEntry("TestResource1", {"test"}, "Test message 1", {key1 = "value"})
    local entry2 = system:createEntry("TestResource2", {"other"}, "Test message 2", {key = "other_value"})
    local entry3 = system:createEntry("TestResource3", {"test"}, "Test message 3", {key1 = "other_value"})

    -- when
    local filteredEntries = filter:apply(system)

    -- then
    return Test.assertEqual(#filteredEntries, 1, "Filter should return one entry with key-value pair") and
           Test.assert(filteredEntries[1].message == entry1.message, "Filtered entry should match entry 1")
end)
