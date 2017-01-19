require("conf")
require("module.limed.init")

function love.load()
	grassydirt = Instance:new("Bitmap")
	grassydirt:bake("assets/tile/grassydirt.png",48,48)
	grass = Instance:new("Bitmap")
	grass:bake("assets/tile/grass1.png",32,32)
	a = grass:sprite(function(self)
		self.bitmap = grass
		self.bounce = true
	end)
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
		self.image = grassydirt:get()
	end),0,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(1)
	end),1,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(4)
	end),2,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(2)
	end),3,1)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(0,1)
	end),0,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(1,1)
	end),1,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(4,1)
	end),2,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(2,1)
	end),3,2)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(0,2)
	end),0,3)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(1,2)
	end),1,3)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(4,2)
	end),2,3)
	level:addTile(t:clone(function(self)
		self.image = grassydirt:get(2,2)
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
end