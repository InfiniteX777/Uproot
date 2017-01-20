local Map = Instance:class("Map",3)({
	x = 32,
	y = 32,
	size = 32,
	background = {
		image = nil,
		parallax = 10
	},
	mask = {
		image = nil,
		parallax = 10
	},
	getTile = function(self,x,y)
		if self.tile then
			return self.tile[x+y*self.x]
		else self.tile = {}
		end
	end,
	addTile = function(self,tile,x,y)
		if not self.tile then
			self.tile = {}
		end
		if tile:is("Tile") and x >= 0 and y >= 0 and x < self.x and y < self.y then
			self.tile[x+y*self.x] = tile
		end
	end,
	remTile = function(self,x,y)
		if not self.tile then
			self.tile = {}
		end
		self.tile[x+y*self.x] = nil
	end,
	update = function(self,dt)
		-- Background
		if self.background.image then
			self.background.image:update(dt,self.background.parallax)
		end
		-- Entity
		if not self.entity then
			self.entity = {}
		end
		for _,v in pairs(self.entity) do
			v:update(dt)
		end
		-- Tile
		local list = {}
		if not self.tile then
			self.tile = {}
		end
		for _,v in pairs(self.tile) do
			if v and not list[v.image] then
				list[v.image] = true
				v.image:update(dt)
			end
		end
		-- Mask
		if self.mask.image then
			self.mask.image:update(dt,self.mask.parallax)
		end
	end,
	draw = function(self,x,y,angle,sx,sy)
		-- Background
		if self.background.image then
			self.background.image:draw(0,0,angle,sx,sy)
		end
		-- Entity
		if not self.entity then
			self.entity = {}
		end
		for _,v in pairs(self.entity) do
			v:draw(x,y,angle,sx,sy)
		end
		-- Tile
		if not self.tile then
			self.tile = {}
		end
		for i,v in pairs(self.tile) do
			local w = (i%self.x)*self.size+(self.size-v.image.width)/2
			local h = math.floor(i/self.y)*self.size+(self.size-v.image.height)/2
			v.image:draw(w*sx+x,h*sy+y,angle,sx,sy)
		end
		if self.mask.image then
			self.mask.image:draw(0,0,angle,sx,sy)
		end
	end
})

local Tile = Instance:class("Tile",3)({
	image = nil,
	visible = true,
	collision = true
})