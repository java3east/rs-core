---@meta RFX

---@class RFX.Simulation
---@class RFX.Simulator
---@class RFX.Resource

---Creats a new simulation of the given type.
---@nodiscard
---@param type 'HELIX'|'FIVEM'
---@return RFX.Simulation simulation
function SIMULATION_CREATE(type) end

---Creates a new simulator of the given type for the specified simulation.
---@nodiscard
---@param simulation RFX.Simulation
---@param type string|'CLIENT'|'SERVER'
---@return RFX.Simulator simulator
function SIMULATOR_CREATE(simulation, type) end

---Loads the given resource.
---@nodiscard
---@param simulation RFX.Simulation
---@param path string
---@return RFX.Resource resource
function RESOURCE_LOAD(simulation, path) end

---Starts the given resource
---@param resource RFX.Resource
function RESOURCE_START(resource) end
