---@diagnostic disable-next-line: undefined-global
require = Package.Require()

require("adapter/events.lua")
require("player/player.lua")

server.adapter.events.onJoin(function (player)
    server.player:new(player)
end)