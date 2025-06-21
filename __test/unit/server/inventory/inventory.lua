local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local ItemStack = ENVIRONMENT_GET_VAR(env, "ItemStack")
local Inventory = ENVIRONMENT_GET_VAR(env, "Inventory")

Test.new('Inventory should exist', function()
    return Test.assert(Inventory ~= nil, "Inventory should not be nil")
end)

Test.new('Inventory() should create a new inventory object with the given id', function (self)
    -- when
    local inventory = Inventory(1, 10, 100.0)

    -- then
    return Test.assert(inventory ~= nil and type(inventory) == "table", "Inventory should create a new inventory object") and
           Test.assertEqual(inventory.id, 1, "Inventory should have the correct id")
end)

Test.new('Inventory.new should create a new inventory with the given amount of slots and max weight', function (self)
    -- when
    local inventory = Inventory.new(10, 100.0)

    -- then
    return Test.assert(inventory ~= nil and type(inventory) == "table", "Inventory should create a new inventory object") and
           Test.assertEqual(inventory.slotCount, 10, "Inventory should have the correct number of slots") and
           Test.assertEqual(inventory.maxWeight, 100.0, "Inventory should have the correct max weight")
end)

Test.new('Inventory:set should set the slot at the given index to the given item stack', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    inventory:set(1, itemStack)

    -- then
    return Test.assertEqual(inventory.slots[1], itemStack, "Inventory should set the item stack at the given slot")
end)

Test.new('Inventory:set should return false if the slot is already occupied', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(2, "another_item", 3, { color = "blue" })

    -- when
    inventory:set(1, itemStack1)
    local result = inventory:set(1, itemStack2)

    -- then
    return Test.assert(result == false, "Inventory:set should return false if the slot is already occupied")
end)

Test.new('Inventory:find should return the slots of the item stacks that match the given item stack', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(2, "test_item", 3, { color = "blue" })

    -- when
    inventory:set(1, itemStack1)
    inventory:set(2, itemStack2)
    local foundSlots = inventory:find(itemStack1)

    -- then
    return Test.assert(#foundSlots == 1 and foundSlots[1] == 1, "Inventory:find should return the correct slot for the matching item stack")
end)

Test.new('Inventory:find should return an empty array if no matching item stack is found', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    local foundSlots = inventory:find(itemStack1)

    -- then
    return Test.assertEqual(#foundSlots, 0, "Inventory:find should return an empty array if no matching item stack is found")
end)

Test.new('Inventory:findFreeSlot should return the id of the next free slot', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)

    -- when
    local freeSlot = inventory:findFreeSlot()

    -- then
    return Test.assertEqual(freeSlot, 1, "Inventory:findFreeSlot should return the first free slot (1)")
end)

Test.new('Inventory:findFreeSlot should return -1 if no free slot is found', function (self)
    -- given
    local inventory = Inventory.new(2, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(2, "another_item", 3, { color = "blue" })

    -- when
    inventory:set(1, itemStack1)
    inventory:set(2, itemStack2)
    local freeSlot = inventory:findFreeSlot()

    -- then
    return Test.assertEqual(freeSlot, -1, "Inventory:findFreeSlot should return -1 if no free slot is found")
end)

Test.new('Inventory:findFreeSlot should start searching from the given slot', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    inventory:set(5, itemStack1)
    local freeSlot = inventory:findFreeSlot(5)

    -- then
    return Test.assertEqual(freeSlot, 6, "Inventory:findFreeSlot should return the next free slot starting from the given slot (6)")
end)

Test.new('Inventory:getWeight should return the current weight of the inventory', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(2, "another_item", 3, { color = "blue" })

    -- when
    inventory:set(1, itemStack1)
    inventory:set(2, itemStack2)
    local weight = inventory:getWeight()

    -- then
    return Test.assertEqual(weight, (itemStack1:getWeight() + itemStack2:getWeight()), "Inventory:getWeight should return the correct total weight")
end)

Test.new('Inventory:add should add item stack to next free slot', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    local added = inventory:add(itemStack1)

    -- then
    return Test.assert(added == true, "Inventory:add should return true when adding a new item stack") and
           Test.assertEqual(inventory.slots[1], itemStack1, "Inventory should have the item stack in the first slot")
end)

Test.new('Inventory:add should not add item stack if no free slot is available', function (self)
    -- given
    local inventory = Inventory.new(2, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(2, "another_item", 3, { color = "blue" })

    -- when
    inventory:set(1, itemStack1)
    inventory:set(2, itemStack2)
    local added = inventory:add(ItemStack(3, "new_item", 2, { color = "green" }))

    -- then
    return Test.assert(added == false, "Inventory:add should return false when no free slot is available")
end)

Test.new('Inventory:add should add item stack to existing stack if it matches', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(1, "test_item", 3, { color = "red" }) -- same name and metadata

    -- when
    inventory:set(1, itemStack1)
    local added = inventory:add(itemStack2)

    -- then
    return Test.assert(added == true, "Inventory:add should return true when adding to an existing stack") and
           Test.assertEqual(inventory.slots[1].quantity, 8, "Inventory should have updated the quantity of the existing stack")
end)

Test.new('Inventory:remove should remove the given quantity of the item stack', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    inventory:set(1, itemStack1)
    local removed = inventory:remove(itemStack1, 3)

    -- then
    return Test.assertEqual(removed, 3, "Inventory:remove should return the correct amount removed") and
           Test.assertEqual(inventory.slots[1].quantity, 2, "Inventory should have updated the quantity of the stack")
end)

Test.new('Inventory:remove should remove the entire stack if quantity matches', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    inventory:set(1, itemStack1)
    local removed = inventory:remove(itemStack1, 5)

    -- then
    return Test.assertEqual(removed, 5, "Inventory:remove should return the correct amount removed") and
           Test.assertEqual(inventory.slots[1], nil, "Inventory should have removed the entire stack")
end)

Test.new('Inventory:remove should return -1 if item stack is not found and ignoreMissing is false', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })

    -- when
    local removed = inventory:remove(itemStack1, 3)

    -- then
    return Test.assertEqual(removed, -1, "Inventory:remove should return -1 if the item stack is not found and ignoreMissing is false")
end)

Test.new('Inventory:__tostring should return a string representation of the inventory', function (self)
    -- given
    local inventory = Inventory.new(10, 100.0)
    local itemStack1 = ItemStack(1, "test_item", 5, { color = "red" })
    local itemStack2 = ItemStack(2, "another_item", 3, { color = "blue" })

    -- when
    inventory:set(1, itemStack1)
    inventory:set(2, itemStack2)
    local str = tostring(inventory)

    -- then
    return Test.assertEqual(str, "Inventory(id=0, slotCount=10, maxWeight=100.0, slots={[1]=ItemStack(id=1, name=test_item, quantity=5, metadata={color=red}), [2]=ItemStack(id=2, name=another_item, quantity=3, metadata={color=blue})})", "Inventory:__tostring should return the correct string representation")
end)
