---@diagnostic disable-next-line: undefined-global
require = function(path) end

require("server.adapter.database")
require("server.adapter.events")
require("server.adapter.net")
require("server.adapter.player")
require("server.core")
require("server.player.player")
require("server.player.character")

server.adapter.events.onJoin(function (player)
    server.player:new(player)
end)