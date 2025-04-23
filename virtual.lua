---Virtual (fake) types, just to better identify variables
---@meta virtual

---@class vplayer : any

---@class vdbcolumn
---@field name string
---@field type 'INT'|'FLOAT'|string the type of the column, e.g. "VARCHAR(255)", "INT", "FLOAT", etc.

---@class vdbformat
---@field name string the name of the database table
---@field columns table<string, vdbcolumn> the columns of the database table