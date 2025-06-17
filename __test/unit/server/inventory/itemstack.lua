local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local ItemStack = ENVIRONMENT_GET_VAR(env, "ItemStack")

Test.new('ItemStack should exist', function (self)
    return Test.assert(ItemStack ~= nil, "ItemStack should not be nil")
end)

Test.new('ItemStack() should create a new item stack object with the given id, name, quantity, and metadata', function (self)
    -- when
    local itemStack = ItemStack(1, "test_item", 10, { color = "red" })

    -- then
    return Test.assert(itemStack ~= nil and type(itemStack) == "table", "ItemStack should create a new item stack object") and
           Test.assert(itemStack.id == 1, "ItemStack should have the correct id") and
           Test.assert(itemStack.name == "test_item", "ItemStack should have the correct name") and
           Test.assert(itemStack.quantity == 10, "ItemStack should have the correct quantity") and
           Test.assert(itemStack.metadata.color == "red", "ItemStack should have the correct metadata")
end)

Test.new('ItemStack:getConstructor() should return the constructor of the item stack', function (self)
    -- given
    ItemStack.createConstructor("test_item", "Test Item", "This is a test item.", 1.0)
    
    -- when
    local itemStack = ItemStack(1, "test_item", 10, { color = "red" })
    local constructor = itemStack:getConstructor()

    -- then
    return Test.assert(constructor ~= nil, "ItemStack should have a constructor") and
           Test.assert(constructor.name == "test_item", "ItemStack constructor should have the correct name") and
           Test.assert(constructor.label == "Test Item", "ItemStack constructor should have the correct label") and
           Test.assert(constructor.description == "This is a test item.", "ItemStack constructor should have the correct description") and
           Test.assert(constructor.weight == 1.0, "ItemStack constructor should have the correct weight")
end)

Test.new('ItemStack:getWeight() should return the correct weight of the item stack', function (self)
    -- given
    ItemStack.createConstructor("test_item", "Test Item", "This is a test item.", 2.0)

    -- when
    local itemStack = ItemStack(1, "test_item", 5, { color = "red" })
    local weight = itemStack:getWeight()

    -- then
    return Test.assert(weight == 10.0, "ItemStack should have the correct weight (2.0 * 5 = 10.0)")
end)

Test.new('ItemStack.createConstructor() should add a new item stack constructor', function (self)
    -- given
    local stack = ItemStack(1, "new_item", 10, { })

    -- when
    ItemStack.createConstructor("new_item", "New Item", "This is a new item.", 3.0)

    -- then
    local constructor = stack:getConstructor()
    return Test.assert(constructor ~= nil, "ItemStack constructor should be created") and
           Test.assert(constructor.name == "new_item", "ItemStack constructor should have the correct name") and
           Test.assert(constructor.label == "New Item", "ItemStack constructor should have the correct label") and
           Test.assert(constructor.description == "This is a new item.", "ItemStack constructor should have the correct description") and
           Test.assert(constructor.weight == 3.0, "ItemStack constructor should have the correct weight")
end)

Test.new('ItemStack:__eq() should compare two item stacks for equality', function (self)
    -- given
    local itemStack1 = ItemStack(1, "test_item", 10, { color = "red" })
    local itemStack2 = ItemStack(2, "test_item", 10, { color = "red" })
    local itemStack3 = ItemStack(3, "test_item", 5, { color = "blue" })

    -- then
    return Test.assert(itemStack1 == itemStack2, "ItemStacks with the same name and metadata should be equal") and
           Test.assert(itemStack1 ~= itemStack3, "ItemStacks with different quantities or metadata should not be equal")
end)
