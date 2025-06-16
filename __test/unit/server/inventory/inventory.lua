local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Inventory = ENVIRONMENT_GET_VAR(env, "Inventory")

Test.new('Inventory should exist', function()
    return Test.assert(Inventory ~= nil, "Inventory should not be nil")
end)

Test.new('Inventory() should create a new inventory object with the given id', function (self)
    -- when
    local inventory = Inventory(1)

    -- then
    return Test.assert(inventory ~= nil and type(inventory) == "table", "Inventory should create a new inventory object") and
           Test.assert(inventory.id == 1, "Inventory should have the correct id")
end)
