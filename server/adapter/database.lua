---@class server
server = server or {}

---@class server.adapter
server.adapter = server.adapter or {}

---@class server.adapter.database
server.adapter.database = {}

---Runns a select query on the database
---@nodiscard
---@param query string the query to run
---@param data table<any> the data to bind to the query
---@return table<string, any> result the result of the query
function server.adapter.database.select(query, data) return {} end

---Runns a insert query on the databases
---@param query string the query to run
---@param data table<table<any>> the data to bind to the query
function server.adapter.database.prepare(query, data) return {} end

---Runns a raw query on the database
---@param query string the query to run
---@param data table<string, any> the data to bind to the query
function server.adapter.database.execute(query, data) end
