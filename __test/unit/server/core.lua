local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local client = SIMULATOR_CREATE(simulation, "CLIENT")

local env = ENVIRONMENT_GET(server, resource)
local Core = ENVIRONMENT_GET_VAR(env, "Core")

Test.new('Core should exist', function()
    return Test.assert(Core ~= nil, "Core should not be nil")
end)

Test.new('Core should have all required functions', function (self)
    return
        Test.assert(Core.getPlayer ~= nil, "Core should have 'getPlayer' function") and
        Test.assert(Core.addFunction ~= nil, "Core should have 'addFunction' function")
end)

Test.new('Core.addFunction should add a function to an object', function (self)
    -- given
    local objName = "Core"
    local funcName = "testFunction"
    local func = function() return "Hello, World!" end

    -- when
    Core.addFunction(objName, funcName, func)

    -- then
    local obj = ENVIRONMENT_GET_VAR(env, objName)
    return Test.assert(obj[funcName] ~= nil, "Function '" .. funcName .. "' should be added to object '" .. objName .. "'") and
           Test.assert(obj[funcName]() == "Hello, World!", "Function '" .. funcName .. "' should return 'Hello, World!'")
end)

Test.new("Core.setModule should set a module", function (self)
    -- given
    local moduleName = "TestModule"
    local module = {
        testFunction = function() return "Test" end
    }

    -- when
    Core.setModule(moduleName, module)

    -- then
    local obj = ENVIRONMENT_GET_VAR(env, moduleName)
    return Test.assert(obj ~= nil, "Module '" .. moduleName .. "' should be set") and
           Test.assert(obj.testFunction ~= nil, "Module '" .. moduleName .. "' should have 'testFunction'") and
           Test.assert(obj.testFunction() == "Test", "Module '" .. moduleName .. "' should return 'Test' from 'testFunction'")
end)

Test.new("Core.setModule should replace existing module", function (self)
    -- given
    local moduleName = "Inventory"
    local newModule = {
        testFunction = function() return "New Test" end
    }
    local current = ENVIRONMENT_GET_VAR(env, moduleName)

    -- when
    Core.setModule(moduleName, newModule)
    local obj = ENVIRONMENT_GET_VAR(env, moduleName)

    -- then
    return Test.assert(obj ~= current, "Module '" .. moduleName .. "' should be replaced")
end)

Test.new('Player should be registered on spawn', function (self)
    -- given
    local size = #Core.getPlayers()

    -- when
    local client2 = SIMULATOR_CREATE(simulation, "CLIENT")
    local sizeNow = #Core.getPlayers()

    -- then
    return Test.assert(sizeNow == size + 1, "Player should be registered on spawn")
end)
