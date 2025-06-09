local simulation = SIMULATION_CREATE("HELIX")
local client1 = SIMULATOR_CREATE(simulation, "CLIENT")
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)