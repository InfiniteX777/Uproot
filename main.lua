require("conf")
require("module.limed.init")
local ContentService = Instance:service("ContentService")
local InputService = Instance:service("InputService")
local grassydirt,grass,a,b,level,t,UI,player

function love.load()
	grassydirt = ContentService:loadImage("assets/tile/grassydirt.png")
	grass = ContentService:loadImage("assets/tile/grass1.png")
	grassydirt:bake(48,48)
	grass:bake(32,32)
	a = grass:sprite(32,32)
	a.bounce = true
	a:play()
	b = a:clone(function(self)
		self:seek(nil,1)
	end)
	level = Instance:new("Map",function(self)
		self.x = 32
		self.y = 32
	end)
	t = Instance:new("Tile")
	level:addTile(t:clone(function(self)
		self.image = a
		self.collision = false
	end),0,5)
	level:addTile(t:clone(function(self)
		self.image = b
		self.collision = false
	end),1,5)
	level:addTile(t:clone(function(self)
		self.image = a
		self.collision = false
	end),2,5)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48)
	end),4,5)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48)
	end),0,6)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,1)
	end),1,6)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,4)
	end),2,6)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,2)
	end),3,6)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,0,1)
	end),0,7)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,1,1)
	end),1,7)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,4,1)
	end),2,7)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,2,1)
	end),3,7)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,0,2)
	end),0,8)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,1,2)
	end),1,8)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,4,2)
	end),2,8)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,2,2)
	end),3,8)
	for i=2,32 do
		level:addTile(t:clone(function(self)
			self.image = grassydirt:quad(48,48,1)
		end),i,6)
	end

	for i=1,32 do
		level:addTile(t:clone(function(self)
			self.image = grassydirt:quad(48,48,1)
		end),i,2)
	end
	--[[UI = Instance:new("UI")
	frame = Instance:new("Label",function(self)
		self.text = "Hello There! Hello World!"
		self.textWrap = false
		self.textAlign = "topright"
		self.textColor = Color:new(255,0,0)
		self.image = a
		self.scale.size = Vector2:new(0.25,0.25)
		self.scale.position.x = 0.375
		self.scale.position.y = 0.375
		self.outlineColor.r = 255
	end)
	UI:add(frame)]]
	player = Instance:new("Entity",function(self)
		self.position.x = 16
		self.motion = 0
		self.hitbox = Vector2:new(32,32)
		self.sprite = ContentService:loadImage("assets/tile/box.png")
		self.map = level
	end)
	InputService.keyDown:connect(function(key)
		if key == "a" then
			player.motion = -160
		end
		if key == "d" then
			player.motion = 160
		end
		if key == "w" then
			player:push(Vector2:new(0,-5))
		end
		if key == "q" then
			player:push(Vector2:new(-50,0))
		end
		if key == "e" then
			player:push(Vector2:new(50,0))
		end
	end)
	InputService.keyUp:connect(function(key)
		if key == "a" or key == "d" then
			player.motion = 0
		end
	end)
end

function love.update(dt)
	level:update(dt)
	--UI:update(dt)
	player:update(dt)
	collectgarbage()
end

function love.draw()
	local width,height = love.graphics.getDimensions()
	local pos = ((player.position-Vector2:new(0,player.hitbox.y/2))*2-Vector2:new(width,height)/2)
	level:draw(-pos.x,-pos.y,0,2,2)
	player:draw(-pos.x,-pos.y,0,2,2)
	print(player.ground)
	--UI:draw(-pos.x,-pos.y,math.pi/4,2,2)

	-- Stats
	love.graphics.origin()
	local n = 1
	for k,v in pairs(love.graphics.getStats()) do
		if k == "texturememory" then
			v = v/1024
		end
		love.graphics.setColor(0,0,0)
		love.graphics.print(k.." = "..tostring(v)..(k == "texturememory" and " kB" or ""), 12,12+n*20)
		love.graphics.setColor(255,255,255)
		love.graphics.print(k.." = "..tostring(v)..(k == "texturememory" and " kB" or ""), 10,10+n*20)
		n = n+1
	end
	love.graphics.print('Memory actually used (in mB): ' .. collectgarbage('count')/1024, 10,10)
	collectgarbage()
end