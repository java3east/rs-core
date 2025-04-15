---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.database
server.adapter.database = {}

---Runns a select query on the database
---@nodiscard
---@param query string the query to run
---@vararg any the query parameters
---@return table<string, any> result the result of the query
function server.adapter.database.select(query, ...) return {} end
