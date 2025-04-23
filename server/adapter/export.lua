---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.export
server.adapter.export = {}

---Exports the given function with the given name
---@param name string the name of the function
---@param func fun(...: any): any the function to export
function server.adapter.export.export(name, func)
end

---Calls the export of the given resource with the given name and parameters
---@param resource string the resource to call
---@param name string the name of the export
---@param ... any the parameters to pass to the export
---@return any the result of the export
function server.adapter.export.call(resource, name, ...)
end
