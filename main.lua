require "conf"
require "module.limed.init"
local game = Instance:service"GameInterface"
local player = Instance:service"Player"
local utf8 = require 'utf8'

--[[ Group Index ]
0 = Environment
-1 = Entity
-2 = Projectile
]]

function love.load()
	love.physics.setMeter(32)
	love.graphics.setDefaultFilter("nearest","nearest")
	game.ui = Instance:new("UI",function(self)
		self.scale:set(0,0,1,1)
	end)

	menu = require("assets.scripts.ui.menu")
	game.ui:add(menu)
end

game.gameUpdate:connect(function(dt)
	if player.character then
		game:focusBody(player.character.body)
	end
end)
