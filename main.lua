require("conf")
require("module.limed.init")
local ContentService = Instance:service("ContentService")

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
	level = Instance:new("Map")
	t = Instance:new("Tile")
	level:addTile(t:clone(function(self)
		self.image = a
	end),0,0)
	level:addTile(t:clone(function(self)
		self.image = b
	end),1,0)
	level:addTile(t:clone(function(self)
		self.image = a
	end),2,0)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48)
	end),0,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,1)
	end),1,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,4)
	end),2,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,2)
	end),3,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,0,1)
	end),0,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,1,1)
	end),1,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,4,1)
	end),2,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,2,1)
	end),3,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,0,2)
	end),0,3)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,1,2)
	end),1,3)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,4,2)
	end),2,3)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:quad(48,48,2,2)
	end),3,3)
	UI = Instance:new("UI")
	UI:add(Instance:new("Label",function(self)
		self.text = "Hello There! Hello World!"
		self.textWrap = true
		self.image = a
		self.size.scale = Vector2:new(0.25,0.25)
		self.position.scale.x = 0.375
		self.position.scale.y = 0.375
		self.fillColor.r = 0
		self.outlineColor.r = 255
	end))
end

function love.update(dt)
	level:update(dt)
	UI:update(dt)
end

function love.draw()
	level:draw(0,0,0,2,2)
	UI:draw(0,0,math.pi/12,1,1)

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
	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
end