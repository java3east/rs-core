---@class server
server = server or {}

---@class server.package
server.package = server.package or {}

---@class server.package.manager
server.package.manager = {}

---Ensures that a database table with the given format exists.
---@param db vdbformat the database format to check
function server.package.manager.ensureTable(db)
    local columns = server.adapter.database.select("SELECT * FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_NAME`=?", {db.name})
    for _, column in ipairs(columns) do
        if not db.columns[column.COLUMN_NAME] then
            server.adapter.database.execute("ALTER TABLE `" .. db.name .. "` DROP COLUMN `" .. column.COLUMN_NAME .. "`", {})
        elseif db.columns[column.COLUMN_NAME].type ~= column.DATA_TYPE then
            server.adapter.database.execute("ALTER TABLE `" .. db.name .. "` CHANGE COLUMN `" .. column.COLUMN_NAME .. "` `" .. column.COLUMN_NAME .. "` " .. db.columns[column.COLUMN_NAME].type, {})
        end
    end
    for name, column in pairs(db.columns) do
        if not shared.table.find(columns, function(v) return v.COLUMN_NAME == name end) then
            server.adapter.database.execute("ALTER TABLE `" .. db.name .. "` ADD COLUMN `" .. name .. "` " .. column.type, {})
        end
    end
end
