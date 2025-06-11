---@meta RFX

---@class RFX.Simulation
---@class RFX.Simulator
---@class RFX.Resource
---@class RFX.Environment

---Creats a new simulation of the given type.
---@nodiscard
---@param type 'HELIX'|'FIVEM'
---@return RFX.Simulation simulation
function SIMULATION_CREATE(type) end

---Returns the server of the given simulation.
---@nodiscard
---@param simulation RFX.Simulation the simulation to get the server for
---@return RFX.Simulator server the server simulator of the given simulation
function SIMULATION_GET_SERVER(simulation) end

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

---Loads the given file at this point in the program.
---@param path string the path to the file that should be loaded
function RFX_REQUIRE(path) end

---Returns the id of the environment for the given simulator
---and resource.
---@nodiscard
---@param simulator RFX.Simulator
---@param resource RFX.Resource
---@return RFX.Environment env
function ENVIRONMENT_GET(simulator, resource) end

---Returns a single global variable defined in the given
---environment.
---@nodiscard
---@param env RFX.Environment the environment to retrieve the variable from
---@param var string the name of the variable to retrieve
---@return any value the value of the variable
function ENVIRONMENT_GET_VAR(env, var) end

---@class Test
Test = {}

---Asserts that the given condition is true.
---@param condition boolean the condition to assert
---@param message string the message to display if the assertion fails
---@return boolean passed true if the assertion passed, false otherwise
function Test.assert(condition, message) end


---@class Test
---@field name string
---@field passed boolean
Test = {}

---@return boolean passed
function Test.assert(condition, message) end

---@param value any
---@param values any[]
---@param message string
---@return boolean passed
function Test.assertOneOf(value, values, message) end

---@param moduleName string the name of the module the tests are for
function Test.runAll(moduleName) end

---Creates a new test
---@param name string the name of the test
---@param fun fun(self: Test) : boolean the function to run for the test
function Test.new(name, fun) end

function Test:run() end

---@enum Color
Color = {
    RESET = "^0",
    BLACK = "^1",
    RED = "^2",
    GREEN = "^3",
    YELLOW = "^4",
    BLUE = "^5",
    MAGENTA = "^6",
    CYAN = "^7",
    WHITE = "^8",
    BOLD = "^9",
}
